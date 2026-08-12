using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace KMC_API.Models
{

    public class Event
    {
        [Key]
        public int EventID { get; set; }
        [Required(ErrorMessage ="Event name is required")]
        [StringLength(100)]
        public string EventName { get; set; }
        public string Category { get; set; }

        [Required]
        public DateTime EventDate { get; set; }
        public string Location { get; set; }
        public string ImageURL { get; set; }


    }
}