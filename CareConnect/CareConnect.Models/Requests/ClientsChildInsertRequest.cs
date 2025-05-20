using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ClientsChildInsertRequest
    {
        public int ClientId { get; set; }

        public int ChildId { get; set; }

        [JsonIgnore]
        public DateTime? ModifiedDate { get; set; } = DateTime.Now;
    }
}
