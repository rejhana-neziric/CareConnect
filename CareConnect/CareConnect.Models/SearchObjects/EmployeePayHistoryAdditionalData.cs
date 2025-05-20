using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class EmployeePayHistoryAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsEmployeeIncluded { get; set; }
    }
}