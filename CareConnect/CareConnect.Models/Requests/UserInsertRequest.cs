using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class UserInsertRequest
    {
        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string? Email { get; set; }

        public string? PhoneNumber { get; set; }

        public string Username { get; set; } = null!;

        public string Password { get; set; } = null!;

        public string ConfirmationPassword { get; set; } = null!;

        [JsonIgnore]
        public bool Status { get; set; } = true; 

        public DateTime? BirthDate { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now; 

        public string Gender { get; set; } = null!;

        public string? Address { get; set; }
    }
}
