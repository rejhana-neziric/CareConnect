using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class MemberSearchObject : BaseSearchObject<MemberAdditionalData>
    {
        public string? FirstNameGTE { get; set; }

        public string? LastNameGTE { get; set; }

        public string? Email { get; set; }

        public DateTime? JoinedDateGTE { get; set; }

        public DateTime? JoinedDateLTE { get; set; }

        public DateTime? LeftDateGTE { get; set; }

        public DateTime? LeftDateLTE { get; set; }
    }
}
