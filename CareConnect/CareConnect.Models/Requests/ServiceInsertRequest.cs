using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ServiceInsertRequest
    {
        public string Name { get; set; } = null!;

        public string? Description { get; set; }

        public decimal? Price { get; set; }

        public decimal? MemberPrice { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}