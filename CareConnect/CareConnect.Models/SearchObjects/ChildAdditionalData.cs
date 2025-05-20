using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ChildAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsDiagnosisIncluded { get; set; }
    }
}