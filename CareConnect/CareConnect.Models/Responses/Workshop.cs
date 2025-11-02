using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
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

        public string? PaymentIntentId { get; set; }

        [NotMapped]
        public bool Paid => PaymentIntentId != null;

        public DateTime ModifiedDate { get; set; }

        public  string WorkshopType { get; set; } = null!;
    }

}