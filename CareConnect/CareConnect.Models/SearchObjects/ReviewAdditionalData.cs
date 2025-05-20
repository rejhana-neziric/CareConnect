using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ReviewAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsUserIncluded { get; set; }

        public bool? IsEmployeeIncluded { get; set; }

        public bool? IsWorkshopIncluded { get; set; }

    }
}