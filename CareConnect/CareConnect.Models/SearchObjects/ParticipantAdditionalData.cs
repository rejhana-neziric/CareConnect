using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ParticipantAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsUserIncluded { get; set; }

        public bool? IsWorkshopIncluded { get; set; }

        public bool? IsAttendanceStatusIncluded { get; set; }

        public bool? IsChildIncluded { get; set; }  

    }
}