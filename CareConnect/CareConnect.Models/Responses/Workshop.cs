using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.Responses
{
    public class Workshop
    {
        public int WorkshopId { get; set; }

        public string Name { get; set; } = null!;

        public string Description { get; set; } = null!;

        public string Status { get; set; } = null!;

        public DateTime Date { get; set; }

        public decimal? Price { get; set; }

        public int? MaxParticipants { get; set; }

        public int? Participants { get; set; }

        public string? Notes { get; set; }

        public DateTime ModifiedDate { get; set; }

        //public virtual ICollection<Participant> ParticipantsNavigation { get; set; } = new List<Participant>();

        //public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

        //public virtual ICollection<Session> Sessions { get; set; } = new List<Session>();

        public  string WorkshopType { get; set; } = null!;
    }

}