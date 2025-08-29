using CareConnect.Models.Responses;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class EmployeeAvailabilityUpdateRequest
    {
        public int? ServiceId { get; set; }

        public string? DayOfWeek { get; set; } = null!;

        public string? StartTime { get; set; }

        public string? EndTime { get; set; }

        [JsonIgnore]
        public DateTime? ModifiedDate { get; set; } = DateTime.Now;
    }
}
