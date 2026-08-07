using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Web.Http;
using KMC_API.Models;

namespace KMC_API.Controllers
{
    public class EventsController : ApiController
    {
        private KMCContext db = new KMCContext();


        public IEnumerable<Event> GetEvents()
        {
            return db.Events.ToList();
        }

        public Event GetEvent(int id)
        {

            return db.Events.Find(id);
        }


        public string PostEvent(Event @event)
        {


            db.Events.Add(@event);
            db.SaveChanges();

            return "Events Saved Successfully !!!";
        }


        public string PutEvent(int id, Event @event)
        {
            if (id == @event.EventID)
            {
                db.Entry(@event).State = EntityState.Modified;
                db.SaveChanges();
                return "Events Updated Successfully !!";
            }
            return "Event ID Mismatch";
        }

        public string DeleteEvent(int id)
        {
            Event @event = db.Events.Find(id);
            if (@event != null)
            {
                db.Events.Remove(@event);
                db.SaveChanges();
                return "Event Deleted Successfully!";
            }
            return "Event Not Found!";
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