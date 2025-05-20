using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ParticipantInsertRequest
    {
        public int UserId { get; set; }

        public int WorkshopId { get; set; }

        public int AttendanceStatusId { get; set; }

        public DateTime RegistrationDate { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}