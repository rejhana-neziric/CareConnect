using System; 

namespace CareConnect.Models.Responses
{
    public class Participant
    {
        public int ParticipantId { get; set; }

        public DateTime RegistrationDate { get; set; }

        public DateTime ModifiedDate { get; set; }

        public int AttendanceStatusId { get; set; }

        public virtual AttendanceStatus AttendanceStatus { get; set; } = null!;

        public virtual User User { get; set; } = null!;

        public virtual Workshop Workshop { get; set; } = null!;

        public virtual Child? Child { get; set; } 
    }
}