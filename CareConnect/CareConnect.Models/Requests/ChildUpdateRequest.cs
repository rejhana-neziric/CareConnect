using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ChildUpdateRequest
    {
        public string? FirstName { get; set; } 

        public string? LastName { get; set; } 

        public DateTime? BirthDate { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }   
}