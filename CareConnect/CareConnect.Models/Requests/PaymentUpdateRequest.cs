using System;
using System.Text.Json.Serialization;

namespace CareConnect.Models.Requests
{
    public class PaymentUpdateRequest
    {
        public decimal? Amount { get; set; }

        public DateTime? PaymentDate { get; set; }

        public int? PaymentStatusId { get; set; }

        public int? PaymentPurposeId { get; set; }

        [JsonIgnore]
        public DateTime? ModifiedDate { get; set; } = DateTime.Now;
    }
}
