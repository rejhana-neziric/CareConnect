using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ClientsChildInsertRequest
    {
        public ClientInsertRequest clientInsertRequest { get; set; }

        public ChildInsertRequest childInsertRequest { get; set; }

        [JsonIgnore]
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}
