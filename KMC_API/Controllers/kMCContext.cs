using System.Data.Entity;

namespace KMC_API.Models
{
    public class KMCContext : DbContext
    {
        public KMCContext() : base(@"Data Source=.\SQLEXPRESS;Initial Catalog=KMC_DB;Integrated Security=True;MultipleActiveResultSets=True;")
        {
        }

        public DbSet<Event> Events { get; set; }
        public DbSet<Participant> Participants { get; set; }
        public DbSet<Organizer> Organizers { get; set; }
    }
}