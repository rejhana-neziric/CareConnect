using System;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class ParticipantSearchObject : BaseSearchObject<ParticipantAdditionalData>
    {
        public string? UserFirstNameGTE { get; set; } = null!;

        public string? UserLastNameGTE { get; set; } = null!;

        public string? WorkshopNameGTE { get; set; } = null!;

        public string? AttendanceStatusNameGTE { get; set; } = null!;

        public DateTime? RegistrationDateGTE { get; set; }

        public DateTime? RegistrationDateLTE { get; set; }
    }
}
