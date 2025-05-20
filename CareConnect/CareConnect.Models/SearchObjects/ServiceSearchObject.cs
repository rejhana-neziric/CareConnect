using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ServiceSearchObject : BaseSearchObject<ServiceAdditionalData>
    {
        public string? NameGTE { get; set; } = null!;

        public decimal? Price { get; set; }

        public decimal? MemberPrice { get; set; }
    }
}
