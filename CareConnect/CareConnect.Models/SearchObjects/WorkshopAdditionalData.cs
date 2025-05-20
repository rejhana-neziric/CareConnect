using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class WorkshopAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsWorkshopTypeIncluded { get; set; }
    }
}