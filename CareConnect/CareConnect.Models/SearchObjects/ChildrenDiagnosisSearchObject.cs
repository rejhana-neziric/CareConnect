using System;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ChildrenDiagnosisSearchObject : BaseSearchObject<ChildrenDiagnosisAdditionalData>
    {
        public DateTime? DiagnosisDateGTE { get; set; }

        public DateTime? DiagnosisDateLTE { get; set; }

        public string? ChildFirstNameGTE { get; set; } = null!;

        public string? ChildLastNameGTE { get; set; } = null!;

        public string? DiagnosisNameGTE { get; set; } = null!;
    }
}
