using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class AppointmentRescheduleRequest
    {
        public int? EmployeeAvailabilityId { get; set; }

        public DateTime? Date { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}
