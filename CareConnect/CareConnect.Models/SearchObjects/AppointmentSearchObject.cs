using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class AppointmentSearchObject : BaseSearchObject<AppointmentAdditionalData>
    {
        public string? AppointmentType { get; set; } = null!;

        public DateTime? DateGTE { get; set; }

        public DateTime? DateLTE { get; set; }

        public string? AttendanceStatusName { get; set; } = null!;

        public string? EmployeeFirstNameGTE { get; set; } = null!;

        public string? EmployeeLastNameGTE { get; set; } = null!;

        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        public string? UserFirstNameGTE { get; set; } = null!;

        public string? UserLastNameGTE { get; set; } = null!;
    }
}
