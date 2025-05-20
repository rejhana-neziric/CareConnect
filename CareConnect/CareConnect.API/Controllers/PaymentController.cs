using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PaymentController : BaseCRUDController<Payment, PaymentSearchObject, PaymentAdditionalData, PaymentInsertRequest, PaymentUpdateRequest>
    {
        public PaymentController(IPaymentService service) : base(service) { }
    }
}
