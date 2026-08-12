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
                return Ok(new { message = "Event Saved Successfully!" });
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
        public IHttpActionResult PutEvent(int id, [FromBody] Event @event)
        {
            if (!ModelState.IsValid || @event == null)
            {
                return BadRequest(ModelState);
            }

            if (id != @event.EventID)
            {
                return BadRequest("Event ID Mismatch");
            }

            db.Entry(@event).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
                return Ok(new { message = "Event Updated Successfully !!" });
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EventExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
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

            return Ok(new { message = "Event Deleted Successfully!" });
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
}