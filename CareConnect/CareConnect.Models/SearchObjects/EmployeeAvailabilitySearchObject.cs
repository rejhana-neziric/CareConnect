using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class EmployeeAvailabilitySearchObject : BaseSearchObject<EmployeeAvailabilityAdditionalData>
    {
        public string? DayOfWeek { get; set; } = null!;

        public string? StartTime { get; set; }

        public string? EndTime { get; set; }

        public string? EmployeeFirstNameGTE { get; set; } = null!;

        public string? EmployeeLastNameGTE { get; set; } = null!;

        public string? ServiceNameGTE { get; set; } = null!;

        public int? EmployeeId { get; set; }

        public int? ServiceId { get; set; }
    }
}