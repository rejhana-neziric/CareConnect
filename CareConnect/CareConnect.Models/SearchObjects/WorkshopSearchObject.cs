using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class WorkshopSearchObject : BaseSearchObject<WorkshopAdditionalData>
    {
        public string? NameGTE { get; set; } = null!;

        public string? Status { get; set; } = null!;

        public DateTime? DateGTE { get; set; }

        public DateTime? DateLTE { get; set; }

        public decimal? Price { get; set; }

        public int? MaxParticipants { get; set; }

        public int? Participants { get; set; }

        public string? WorkshopType { get; set; }

        public int? ParticipantId { get; set; }
    }
}
