using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class UserUpdateRequest
    {
        public string? FirstName { get; set; }

        public string? LastName { get; set; } 

        public string? PhoneNumber { get; set; }

        public string? Username { get; set; } = null!;

        public string? Password { get; set; } = null!;

        public string? ConfirmationPassword { get; set; } = null!;

        public string? Email { get; set; }

        public bool? Status { get; set; }

        public string? Address { get; set; }


        [JsonIgnore]
        public DateTime? ModifiedDate { get; set; } = DateTime.Now;
    }
}
