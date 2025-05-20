using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class MemberAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsClientIncluded { get; set; }
    }
}