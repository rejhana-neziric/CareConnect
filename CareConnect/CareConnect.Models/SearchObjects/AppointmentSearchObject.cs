using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class AppointmentSearchObject : BaseSearchObject<AppointmentAdditionalData>
    {
        public string? AppointmentType { get; set; } 

        public DateTime? DateGTE { get; set; }

        public DateTime? DateLTE { get; set; }

        public string? AttendanceStatusName { get; set; }

        public string? EmployeeFirstNameGTE { get; set; }

        public string? EmployeeLastNameGTE { get; set; } 

        public string? StartTime { get; set; }

        public string? EndTime { get; set; }

        public string? UserFirstNameGTE { get; set; } 

        public string? UserLastNameGTE { get; set; }
    }
}
