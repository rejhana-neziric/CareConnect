using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;

namespace CareConnect.Models.Requests
{
    public class ClientUpdateRequest
    {
        public bool? EmploymentStatus { get; set; }

        [JsonIgnore]
        public DateTime? ModifiedDate { get; set; } = DateTime.Now;

        public UserUpdateRequest? User { get; set; }
    }
}
