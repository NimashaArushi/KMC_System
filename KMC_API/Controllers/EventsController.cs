using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Web.Http;
using KMC_API.Models;

namespace KMC_API.Controllers
{
    [RoutePrefix("api/events")]
    public class EventsController : ApiController
    {
        private readonly KMCContext db = new KMCContext();

        // GET: api/events
        [HttpGet]
        [Route("")]
        public IHttpActionResult GetEvents()
        {
            var events = db.Events.ToList();
            return Ok(events);
        }

        // GET: api/events/5
        [HttpGet]
        [Route("{id:int}")]
        public IHttpActionResult GetEvent(int id)
        {
            Event @event = db.Events.Find(id);
            if (@event == null)
            {
                return NotFound();
            }
            return Ok(@event);
        }

        // POST: api/events
        [HttpPost]
        [Route("")]
        public IHttpActionResult PostEvent([FromBody] Event @event)
        {
            if (@event == null)
            {
                return BadRequest("Invalid event data.");
            }

            if (string.IsNullOrEmpty(@event.ImageURL))
            {
                @event.ImageURL = "";
            }

            try
            {
                db.Events.Add(@event);
                db.SaveChanges();
                return Ok(new { message = "Event saved successfully! 🎉" });
            }
            catch (Exception ex)
            {
                string errorMessage = ex.InnerException?.InnerException?.Message ?? ex.Message;
                return InternalServerError(new Exception("Database Error: " + errorMessage));
            }
        }

        // PUT: api/events/5
        [HttpPut]
        [Route("{id:int}")]
        public IHttpActionResult PutEvent(int id, [FromBody] EventUpdateRequest request)
        {
            if (request == null || request.Event == null)
            {
                return BadRequest("Invalid request payload.");
            }

            if (id != request.Event.EventID)
            {
                return BadRequest("Event ID Mismatch.");
            }

            // 1. Organizer Credentials Check
            var organizer = db.Organizers.FirstOrDefault(o => o.Email == request.Email && o.Password == request.Password);

            if (organizer == null)
            {
                return Content(HttpStatusCode.Unauthorized, new { message = "Invalid Organizer Credentials! Email or Password incorrect. ❌" });
            }

            // 2. DB Event Search
            var existingEvent = db.Events.Find(id);
            if (existingEvent == null)
            {
                return NotFound();
            }

            // 3. Ownership Verification
            if (existingEvent.OrganizerID != organizer.OrganizerID)
            {
                return Content(HttpStatusCode.Forbidden, new { message = "Unauthorized! You are not the organizer who created this event." });
            }

            // 4. Update Event Values
            existingEvent.EventName = request.Event.EventName;
            existingEvent.Category = request.Event.Category;
            existingEvent.EventDate = request.Event.EventDate;
            existingEvent.Location = request.Event.Location;
            existingEvent.ImageURL = request.Event.ImageURL;
            existingEvent.OrganizerName = request.Event.OrganizerName;

            try
            {
                db.SaveChanges();
                return Ok(new { message = "Event updated successfully! ✏️" });
            }
            catch (Exception ex)
            {
                string errorMessage = ex.InnerException?.InnerException?.Message ?? ex.Message;
                return InternalServerError(new Exception("Database Error: " + errorMessage));
            }
        }

        // DELETE: api/events/5
        [HttpDelete]
        [Route("{id:int}")]
        public IHttpActionResult DeleteEvent(int id)
        {
            Event @event = db.Events.Find(id);
            if (@event == null)
            {
                return NotFound();
            }

            db.Events.Remove(@event);
            db.SaveChanges();

            return Ok(new { message = "Event deleted successfully! 🗑️" });
        }

        private bool EventExists(int id)
        {
            return db.Events.Count(e => e.EventID == id) > 0;
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }

    public class EventUpdateRequest
    {
        public Event Event { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
    }
}