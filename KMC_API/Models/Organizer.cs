using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace KMC_API.Models
{
    [Table("Organizers")]
    public class Organizer
    {
        [Key]
        public int OrganizerID { get; set; }
        public string OrganizerName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
    }
}