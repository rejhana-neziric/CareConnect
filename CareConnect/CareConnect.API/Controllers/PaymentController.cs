using CareConnect.API.Filters;
using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Stripe;
using Stripe.Checkout;
using System.Security.Claims;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PaymentController : BaseCRUDController<Payment, PaymentSearchObject, PaymentAdditionalData, PaymentInsertRequest, PaymentUpdateRequest>
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<PaymentController> _logger;

        public PaymentController(IPaymentService service, IConfiguration configuration, ILogger<PaymentController> logger) : base(service) 
        {
            _configuration = configuration;
            _logger = logger;
            StripeConfiguration.ApiKey = _configuration["Stripe:SecretKey"];
        }

        [HttpPost("create-intent")]
        [PermissionAuthorize("CreatePaymentIntent")]
        public async Task<IActionResult> CreatePaymentIntent([FromBody] PaymentIntentRequest request)
        {
            try
            {
                var response = await (_service as IPaymentService)!.CreatePaymentIntentAsync(request);
                return Ok(response);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(new { error = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating payment intent");
                return StatusCode(500, new { error = "Internal server error" });
            }
        }

        [HttpGet("verify/{paymentIntentId}")]
        [PermissionAuthorize("VerifyPayment")]
        public async Task<IActionResult> VerifyPayment(string paymentIntentId)
        {
            var isValid = await (_service as IPaymentService)!.VerifyPaymentAsync(paymentIntentId);
            return Ok(new { isValid });
        }
    }
}
