using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class InstructorInsertRequest
    {

        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string? Email { get; set; }

        public string? PhoneNumber { get; set; }

        public string ProfessionalTitle { get; set; } = null!;

        public string? InstitutionName { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}
