using System;

namespace CareConnect.Models.Responses
{
    public class Member
    {
        public DateTime JoinedDate { get; set; }

        public DateTime? LeftDate { get; set; }

        public virtual Client Client { get; set; } = null!;
    }
}