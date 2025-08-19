using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class WorkshopUpdateRequest
    {
        public string? Name { get; set; } = null!;

        public string? Description { get; set; } = null!;

        public string? WorkshopType { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        public decimal? Price { get; set; }

        public decimal? MemberPrice { get; set; }

        public int? MaxParticipants { get; set; }

        public int? Participants { get; set; }

        public string? Notes { get; set; }

        [JsonIgnore]
        public DateTime ModifiedDate { get; set; } = DateTime.Now;
    }
}
