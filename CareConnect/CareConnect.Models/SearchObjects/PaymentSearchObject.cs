using System;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class PaymentSearchObject : BaseSearchObject<PaymentAdditionalData>
    {

        public string? UserFirstNameGTE { get; set; }

        public string? UserLastNameGTE { get; set; }

        public decimal? Amount { get; set; }

        public DateTime? PaymentDateGTE { get; set; }

        public DateTime? PaymentDateLTE { get; set; }

        public string? PaymentPurposeNameGTE { get; set; }

        public string? PaymentStatusNameGTE { get; set; }
    }
}