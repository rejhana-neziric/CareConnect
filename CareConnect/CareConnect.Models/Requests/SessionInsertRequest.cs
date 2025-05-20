using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class SessionInsertRequest
    {
        public string Name { get; set; } = null!;

        public string Description { get; set; } = null!;

        public int WorkshopId { get; set; }

        public int? EmployeeId { get; set; }

        public int? InstructorId { get; set; }

        public DateTime Date { get; set; }

        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;

        public string Status { get; set; } = null!;
    }
}