using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class InstructorAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsSessionsIncluded { get; set; }
    }
}