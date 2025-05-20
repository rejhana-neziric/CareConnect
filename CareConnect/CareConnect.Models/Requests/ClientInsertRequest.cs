using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ClientInsertRequest
    {
        public bool EmploymentStatus { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;

        public UserInsertRequest User { get; set; }
    }
}
