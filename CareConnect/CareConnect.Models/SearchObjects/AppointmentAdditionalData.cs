using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class AppointmentAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsClientsChildIncluded { get; set; }

        public bool? IsEmployeeAvailabilityIncluded { get; set; }

        public bool? IsAttendanceStatusIncluded { get; set; }
    }
}
