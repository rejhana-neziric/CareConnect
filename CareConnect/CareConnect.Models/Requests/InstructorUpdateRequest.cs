using System;
using System.Text.Json.Serialization;


namespace CareConnect.Models.Requests
{
    public class InstructorUpdateRequest
    {
        public string? Email { get; set; }

        public string? PhoneNumber { get; set; }

        public string? ProfessionalTitle { get; set; }

        public string? InstitutionName { get; set; }

        [JsonIgnore]
        public DateTime? ModifiedDate { get; set; } = DateTime.Now;
    }
}
