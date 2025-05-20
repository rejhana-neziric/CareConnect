using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class EmployeeAvailabilityAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsEmployeeIncluded { get; set; }

        public bool? IsServiceIncluded { get; set; }

    }
}