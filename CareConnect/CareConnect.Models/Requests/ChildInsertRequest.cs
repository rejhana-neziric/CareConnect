using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ChildInsertRequest
    {
        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public DateTime BirthDate { get; set; }

        public string Gender { get; set; } = null!;

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }   
}