using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ClientAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsUserIncluded { get; set; }

        //public bool? IsChildrenIncluded { get; set; }
    }
}