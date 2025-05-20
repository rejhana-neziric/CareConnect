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

        public DateTime? StartDateGTE { get; set; }

        public DateTime? StartDateLTE { get; set; }

        public DateTime? EndDateGTE { get; set; }

        public DateTime? EndDateLTE { get; set; }

        public decimal? Price { get; set; }

        public decimal? MemberPrice { get; set; }

        public int? MaxParticipants { get; set; }

        public int? Participants { get; set; }
    }
}
