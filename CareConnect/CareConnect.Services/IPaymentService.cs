using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IPaymentService : ICRUDService<Payment, PaymentSearchObject, PaymentAdditionalData, PaymentInsertRequest, PaymentUpdateRequest>
    {
        public Task<PaymentIntentResponse> CreatePaymentIntentAsync(PaymentIntentRequest request);

        public Task<bool> VerifyPaymentAsync(string paymentIntentId);
    }
}