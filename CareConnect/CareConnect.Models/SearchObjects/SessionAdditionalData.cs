using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class SessionAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsEmployeeIncluded { get; set; }

        public bool? IsInstructorIncluded { get; set; }

        public bool? IsWorkshopIncluded { get; set; }

    }
}