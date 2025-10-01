using CareConnect.Models.Responses;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class AppointmentInsertRequest
    {
        public int EmployeeAvailabilityId { get; set; }

        public int ClientId { get; set; }

        public int ChildId { get; set; }

        public string AppointmentType { get; set; } = null!;

        public int AttendanceStatusId { get; set; }

        public DateTime Date { get; set; }

        public string? Description { get; set; }

        public string? Note { get; set; }

        public string? PaymentIntentId { get; set; } = null; // null for free items

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}
