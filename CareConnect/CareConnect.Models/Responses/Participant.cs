using System; 

namespace CareConnect.Models.Responses
{
    public class Participant
    {
        public DateTime RegistrationDate { get; set; }

        public DateTime ModifiedDate { get; set; }

        public virtual AttendanceStatus AttendanceStatus { get; set; } = null!;

        public virtual User User { get; set; } = null!;

        public virtual Workshop Workshop { get; set; } = null!;
    }
}