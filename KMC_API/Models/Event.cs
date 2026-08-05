using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KMC_API.Models
{
    public class Event
    {

        public int EventID { get; set; }
        public string EventName { get; set; }
        public string Category { get; set; }
        public DateTime EventDate { get; set; }
        public string Location { get; set; }
        public string ImageURL { get; set; }


    }
}