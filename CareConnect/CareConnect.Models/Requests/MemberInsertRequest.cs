using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class MemberInsertRequest
    {
        public DateTime JoinedDate { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;

        public int ClientId { get; set; }
    }
}
