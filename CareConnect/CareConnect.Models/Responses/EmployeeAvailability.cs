using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class EmployeeAvailability
    {
        public int EmployeeAvailabilityId { get; set; }

        public string DayOfWeek { get; set; } = null!;

        public string StartTime { get; set; } = null!;

        public string EndTime { get; set; } = null!;

        public DateTime ModifiedDate { get; set; }

        //public virtual Employee Employee { get; set; } = null!;

        public virtual Service? Service { get; set; }
    }
}
