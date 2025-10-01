using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using Mapster;
using CareConnect.Services.Helpers;
using System.Security.Cryptography.X509Certificates;
using CareConnect.Models.SearchObjects;
using CareConnect.Models.Requests;
using Microsoft.Extensions.Configuration;
using Stripe;
using Stripe.Checkout;
using CareConnect.Models.Responses;
using Microsoft.Extensions.Logging;
using static Permissions;


namespace CareConnect.Services
{
    public class PaymentService : BaseCRUDService<Models.Responses.Payment, PaymentSearchObject, PaymentAdditionalData, Database.Payment, PaymentInsertRequest, PaymentUpdateRequest>, IPaymentService
    {
        private readonly IConfiguration _configuration;

        private readonly ILogger<PaymentService> _logger;

        public PaymentService(CareConnectContext context, IMapper mapper, IConfiguration configuration, ILogger<PaymentService> logger) : base(context, mapper) 
        {
            _configuration = configuration;
            _logger = logger;

            StripeConfiguration.ApiKey = _configuration["Stripe:SecretKey"];
        }

        public override IQueryable<Database.Payment> AddFilter(PaymentSearchObject search, IQueryable<Database.Payment> query)
        {
            query = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.UserFirstNameGTE))
            {
                query = query.Where(x => x.User.FirstName.StartsWith(search.UserFirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.UserLastNameGTE))
            {
                query = query.Where(x => x.User.LastName.StartsWith(search.UserLastNameGTE));
            }

            if (search?.Amount.HasValue == true)
            {
                query = query.Where(x => x.Amount == search.Amount);
            }

            //if (search?.PaymentDateGTE.HasValue == true)
            //{
            //    query = query.Where(x => x.PaymentDate >= search.PaymentDateGTE);
            //}

            //if (search?.PaymentDateLTE.HasValue == true)
            //{
            //    query = query.Where(x => x.PaymentDate <= search.PaymentDateLTE);
            //}

            //if (!string.IsNullOrWhiteSpace(search?.PaymentPurposeNameGTE))
            //{
            //    query = query.Where(x => x.PaymentPurpose.Name.StartsWith(search.PaymentPurposeNameGTE));
            //}

            //if (!string.IsNullOrWhiteSpace(search?.PaymentStatusNameGTE))
            //{
            //    query = query.Where(x => x.PaymentStatus.Name.StartsWith(search.PaymentStatusNameGTE));
            //}

            return query;
        }

        protected override void AddInclude(PaymentAdditionalData additionalData, ref IQueryable<Database.Payment> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsUserIncluded.HasValue && additionalData.IsUserIncluded == true)
                {
                    additionalData.IncludeList.Add("User");
                }

                if (additionalData.IsPaymentPurposeIncluded.HasValue && additionalData.IsPaymentPurposeIncluded == true)
                {
                    additionalData.IncludeList.Add("PaymentPurpose");
                }

                if (additionalData.IsPaymentStatusIncluded.HasValue && additionalData.IsPaymentStatusIncluded == true)
                {
                    additionalData.IncludeList.Add("PaymentStatus");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(PaymentInsertRequest request, Database.Payment entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(PaymentUpdateRequest request, ref Database.Payment entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Database.Payment GetByIdWithIncludes(int id)
        {
            return Context.Payments
                .Include(u => u.User)
                //.Include(p => p.PaymentPurpose)
                //.Include(p => p.PaymentStatus)
                .First(p => p.PaymentId == id);
        }

        public override void BeforeDelete(Database.Payment entity)
        {
            //foreach (var child in entity.ClientsChildren)
            //    Context.Remove(child);

            //foreach (var review in entity)
            //    Context.Remove(review);

            base.BeforeDelete(entity);
        }

        public override void AfterDelete(int id)
        {
            //var user = Context.Users.Find(id);

            //if (user != null)
            //{
            //    Context.Remove(user);
            //    Context.SaveChanges();
            //}

            base.AfterDelete(id);
        }

        public async Task<PaymentIntentResponse> CreatePaymentIntentAsync(PaymentIntentRequest request)
        {
            decimal amount;
            string itemTitle;

            // Get item details and validate
            if (request.ItemType.Equals("Workshop", StringComparison.OrdinalIgnoreCase))
            {
                var workshop = await Context.Workshops.FindAsync(request.ItemId);

                if (workshop == null)
                    throw new ArgumentException("Workshop not found");

                if (workshop.Price == null)
                    throw new ArgumentException("Cannot create payment intent for free workshop");

                var existingParticipant = await Context.Participants.AnyAsync(x => x.WorkshopId == request.ItemId 
                                                                                && x.User.UserId == request.ClientId 
                                                                                && (request.ChildId == null 
                                                                                || x.ChildId == request.ChildId));

                if (existingParticipant)
                    throw new ArgumentException("Already enrolled in this workshop");

                amount = workshop.Price.Value;
                itemTitle = workshop.Name;
            }
            else if (request.ItemType.Equals("Appointment", StringComparison.OrdinalIgnoreCase))
            {
                var availability = await Context.EmployeeAvailabilities
                                            .Where(x => x.EmployeeAvailabilityId == request.Appointment.EmployeeAvailabilityId)
                                            .Include(x => x.Service)
                                            .FirstOrDefaultAsync();

                if(availability == null)
                    throw new ArgumentException("Availability not found");

                if (availability.Service!.Price == null)
                    throw new ArgumentException("Cannot create payment intent for free appointment");

                var alreadyExist = Context.Appointments
                                           .FirstOrDefault(x => x.ClientId == request.ClientId
                                                             && x.ChildId == request.ChildId
                                                             && x.EmployeeAvailabilityId == request.Appointment.EmployeeAvailabilityId
                                                             && x.Date == request.Appointment.Date);

                if (alreadyExist != null)
                    throw new ArgumentException("Appointment already booked");

                amount = availability.Service.Price.Value;
                itemTitle = availability.Service.Name;
            }
            else
            {
                throw new ArgumentException("Invalid item type");
            }

            // Create Stripe PaymentIntent
            var metadata = new Dictionary<string, string>
            {
                ["userId"] = request.ClientId.ToString(),
                ["itemType"] = request.ItemType
            };

            if (request.ItemId.HasValue)
            {
                metadata["itemId"] = request.ItemId.Value.ToString();
            }

            var options = new PaymentIntentCreateOptions
            {
                Amount = (long)(amount * 100),
                Currency = "usd",
                Description = $"{request.ItemType}: {itemTitle}",
                Metadata = metadata
            };

            var service = new PaymentIntentService();
            var paymentIntent = await service.CreateAsync(options);

            // Save payment record
            var paymentRecord = new Database.Payment
            {
                PaymentIntentId = paymentIntent.Id,
                UserId = request.ClientId,
                ItemType = request.ItemType,
                WorkshopId = request.ItemId,
                Amount = amount,
                Currency = "usd",
                Status = Models.Enums.PaymentStatus.Pending.ToString(),
                CreatedAt = DateTime.Now, 
                EmployeeAvailabilityId = request.Appointment?.EmployeeAvailabilityId,
                AppointmentDate = request.Appointment?.Date,
                ChildId = request.ChildId ?? request.Appointment?.ChildId,  
            };

            Context.Payments.Add(paymentRecord);
            await Context.SaveChangesAsync();

            return new PaymentIntentResponse
            {
                ClientSecret = paymentIntent.ClientSecret,
                PaymentIntentId = paymentIntent.Id,
                Amount = amount,
                Currency = "usd"
            };
        }

        public async Task<bool> VerifyPaymentAsync(string paymentIntentId)
        {
            try
            {
                var service = new PaymentIntentService();
                var paymentIntent = await service.GetAsync(paymentIntentId);

                return paymentIntent.Status == "succeeded";
            }
            catch (Exception ex)
            {
                return false;
            }
        }   
    }   
}
