using System;
using System.Text.Json.Serialization;


namespace CareConnect.Models.Requests
{
    public class MemberUpdateRequest
    {
        public DateTime? LeftDate { get; set; }

        [JsonIgnore]
        public DateTime? ModifiedDate { get; set; } = DateTime.Now;
    }
}
