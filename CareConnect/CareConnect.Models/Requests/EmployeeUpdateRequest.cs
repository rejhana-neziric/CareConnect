using CareConnect.Models.Responses;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class EmployeeUpdateRequest
    {
        public string? JobTitle { get; set; } = null!;

        public DateTime? EndDate { get; set; }

        [JsonIgnore]
        public DateTime? ModifiedDate { get; set; } = DateTime.Now;

        public UserUpdateRequest? User {  get; set; }

        public QualificationUpdateRequest? Qualification { get; set; }
    }
}
