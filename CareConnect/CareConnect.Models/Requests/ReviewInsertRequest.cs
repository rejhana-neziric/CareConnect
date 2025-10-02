using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class ReviewInsertRequest
    {
        public int UserId { get; set; }

        public string Title { get; set; } = null!;

        public string Content { get; set; } = null!;

        public int EmployeeId { get; set; }

        public int? Stars { get; set; }

        [JsonIgnore]
        public DateTime PublishDate { get; set; } = DateTime.Now;

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}
