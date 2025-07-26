using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ChildSearchObject : BaseSearchObject<ChildAdditionalData>
    {
        public string? FirstNameGTE { get; set; }

        public string? LastNameGTE { get; set; }

        public DateTime? BirthDateGTE { get; set; }

        public DateTime? BirthDateLTE { get; set; }

        public String? Gender { get; set; }
    }
}
