using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class EmployeeAvailability
    {
        public string DayOfWeek { get; set; } = null!;

        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }

        public bool IsAvailable { get; set; }

        public string? ReasonOfUnavailability { get; set; }

        public DateTime ModifiedDate { get; set; }

        public virtual Employee Employee { get; set; } = null!;

        public virtual Service? Service { get; set; }
    }
}
