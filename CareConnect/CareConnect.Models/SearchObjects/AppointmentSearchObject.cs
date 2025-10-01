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

        public DateTime? Date { get; set; }

        public string? AttendanceStatusName { get; set; }

        public string? EmployeeFirstName { get; set; }

        public string? EmployeeLastName { get; set; } 

        public string? StartTime { get; set; }

        public string? EndTime { get; set; }

        public string? Status { get; set; }

        public string? ChildFirstName { get; set; } 

        public string? ChildLastName { get; set; }

        public int? ClientId { get; set; }

        public int? ChildId { get; set; }

        public string? ClientUsername { get; set; }

        public int? ServiceTypeId { get; set; }

        public string? ServiceNameGTE { get; set; }

        public int? EmployeeAvailabilityId { get; set; }

    }
}
