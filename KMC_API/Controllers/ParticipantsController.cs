using KMC_API.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace KMC_API.Controllers
{
    public class ParticipantsController : ApiController
    {
        private KMCContext db = new KMCContext();

     
        public IEnumerable<Participant> GetParticipants()
        {
            return db.Participants.ToList();
        }

   
        public Participant GetParticipant(int id)
        {
            return db.Participants.Find(id);
        }

     
        public string PostParticipant(Participant participant)
        {
            db.Participants.Add(participant);
            db.SaveChanges();
            return "Saved successfully !!";
        }

        public string DeleteParticipant(int id)
        {
     
            Participant participant = db.Participants.Find(id);

            if (participant != null)
            {
                db.Participants.Remove(participant);
                db.SaveChanges();
                return "Deleted successfully !!!!";
            }
            return "Participant Not Found!";
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