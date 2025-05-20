using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class SessionSearchObject : BaseSearchObject<SessionAdditionalData>
    {
        public string? NameGTE { get; set; } = null!;

        public DateTime? DateGTE { get; set; }

        public DateTime? DateLTE { get; set; }

        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        public string? Status { get; set; } = null!;
    }
}
