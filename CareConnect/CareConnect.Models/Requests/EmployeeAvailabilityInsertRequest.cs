using CareConnect.Models.Responses;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class EmployeeAvailabilityInsertRequest
    {
        public int EmployeeId { get; set; }

        public int? ServiceId { get; set; }

        public string DayOfWeek { get; set; } = null!;

        [RegularExpression(@"^\d{2}:\d{2}(:\d{2})?$", ErrorMessage = "StartTime must be in format HH:mm or HH:mm:ss.")]
        public string StartTime { get; set; }

        [RegularExpression(@"^\d{2}:\d{2}(:\d{2})?$", ErrorMessage = "StartTime must be in format HH:mm or HH:mm:ss.")]
        public string EndTime { get; set; }

        public bool IsAvailable { get; set; }

        public string? ReasonOfUnavailability { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now; 
    }
}
