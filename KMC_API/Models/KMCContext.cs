using System;
using System.Data.Entity;

namespace KMC_API.Models
{
    public class KMCContext : DbContext
    {
        public KMCContext() : base("name=KMCConnection")
        {
        }

        public DbSet<Event> Events { get; set; }
        public DbSet<Participant> Participants{ get; set; }

      
    }
}