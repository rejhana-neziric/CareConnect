using System;
using System.Collections.Generic;
using System.Text;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ReviewSearchObject : BaseSearchObject<ReviewAdditionalData>
    {
        public string? TitleGTE { get; set; } = null!;

        public DateTime? PublishDateGTE { get; set; }

        public DateTime? PublishDateLTE { get; set; }

        public int? Stars { get; set; }

        public string? UserFirstNameGTE { get; set; } = null!;

        public string? UserLastNameGTE { get; set; } = null!;

        public string? EmployeeFirstNameGTE { get; set; } = null!;

        public string? EmployeeLastNameGTE { get; set; } = null!;

        public string? WorkshopNameGTE { get; set; } = null!;
    }
}
