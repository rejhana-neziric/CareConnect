using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ChildrenDiagnosisAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsChildIncluded { get; set; }

        public bool? IsDiagnosisIncluded { get; set; }
    }
}