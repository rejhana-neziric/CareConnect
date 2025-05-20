using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ReviewUpdateRequest
    {
        public string? Title { get; set; } = null!;

        public string? Content { get; set; } = null!;

        public int? Stars { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}
