using CareConnect.Models.SearchObjects;

namespace CareConnect.Models.SearchObjects
{
    public class PaymentAdditionalData : BaseAdditionalSearchRequestData
    {
        public bool? IsUserIncluded { get; set; }

        public bool? IsPaymentStatusIncluded { get; set; }

        public bool? IsPaymentPurposeIncluded { get; set; }

    }
}
