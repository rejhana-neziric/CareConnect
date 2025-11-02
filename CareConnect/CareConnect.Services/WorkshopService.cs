using CareConnect.Models.Requests;
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
using CareConnect.Models.SearchObjects;
using CareConnect.Services.AppointmentStateMachine;
using CareConnect.Services.WorkshopStateMachine;
using Microsoft.Extensions.Logging;
using CareConnect.Models.Responses;
using CareConnect.Models.Enums;
using static Permissions;
using Stripe;


namespace CareConnect.Services
{
    public class WorkshopService : BaseCRUDService<Models.Responses.Workshop, WorkshopSearchObject, WorkshopAdditionalData, Database.Workshop, WorkshopInsertRequest, WorkshopUpdateRequest>, IWorkshopService
    {
        public BaseWorkshopState BaseWorkshopState { get; set; }

        ILogger<WorkshopService> _logger;

        private readonly IPaymentService _paymentService;

        public WorkshopService(
            CareConnectContext context, 
            IMapper mapper, 
            BaseWorkshopState baseWorkshopState, 
            ILogger<WorkshopService> logger, 
            IPaymentService paymentService)
            : base(context, mapper) 
        {
            BaseWorkshopState = baseWorkshopState;
            _logger = logger;
            _paymentService = paymentService;
        }

        public override IQueryable<Database.Workshop> AddFilter(WorkshopSearchObject search, IQueryable<Database.Workshop> query)
        {
            query = base.AddFilter(search, query);


            if (!string.IsNullOrWhiteSpace(search?.NameGTE))
            {
                query = query.Where(x => x.Name.StartsWith(search.NameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.Status))
            {
                query = query.Where(x => x.Status == search.Status);
            }

            if (search?.DateGTE.HasValue == true)
            {
                query = query.Where(x => x.Date >= search.DateGTE);
            }

            if (search?.DateLTE.HasValue == true)
            {
                query = query.Where(x => x.Date <= search.DateLTE);
            }

            if (search?.Price.HasValue == true)
            {
                query = query.Where(x => x.Price == search.Price);
            }

            if (search?.MaxParticipants.HasValue == true)
            {
                query = query.Where(x => x.MaxParticipants == search.MaxParticipants);
            }

            if (search?.Participants.HasValue == true)
            {
                query = query.Where(x => x.Participants == search.Participants);
            }

            if (!string.IsNullOrWhiteSpace(search?.WorkshopType))
            {
                query = query.Where(x => x.WorkshopType == search.WorkshopType);
            }

            if (search?.ParticipantId.HasValue == true)
            {
                query = query.Where(w => w.ParticipantsNavigation.Any(p => p.UserId == search.ParticipantId));

            }

            if (!string.IsNullOrWhiteSpace(search?.SortBy))
            {
                query = search?.SortBy switch
                {
                    "name" => search.SortAscending ? query.OrderBy(x => x.Name) : query.OrderByDescending(x => x.Name),
                    "price" => search.SortAscending ? query.OrderBy(x => x.Price) : query.OrderByDescending(x => x.Price),
                    "date" => search.SortAscending ? query.OrderBy(x => x.Date) : query.OrderByDescending(x => x.Date),
                    "maxParticipants" => search.SortAscending ? query.OrderBy(x => x.MaxParticipants) : query.OrderByDescending(x => x.MaxParticipants),
                    "participants" => search.SortAscending ? query.OrderBy(x => x.Participants) : query.OrderByDescending(x => x.Participants),
                    _ => query
                };
            }

            return query;
        }

        public override Database.Workshop GetByIdWithIncludes(int id)
        {
            return Context.Workshops
                .Include(w => w.WorkshopType)
                .First(w => w.WorkshopId == id);
        }

        public Models.Responses.Workshop Insert(WorkshopInsertRequest request)
        {
            var state = BaseWorkshopState.CreateWorkshopState("Initial");
            return state.Insert(request);
        }

        public override Models.Responses.Workshop Update(int id, WorkshopUpdateRequest request)
        {
            var entity = GetById(id);
            var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
            return state.Update(id, request);
        }

        public Models.Responses.Workshop Cancel(int id)
        {
            var entity = GetById(id);
            var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
            return state.Cancel(id);
        }

        public Models.Responses.Workshop Close(int id)
        {
            var entity = GetById(id);
            var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
            return state.Close(id);
        }

        public Models.Responses.Workshop Publish(int id)
        {
            var entity = GetById(id);

            var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
            return state.Publish(id);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed action called for: {id}.");

            if (id <= 0)
            {
                var state = BaseWorkshopState.CreateWorkshopState("Initial");
                return state.AllowedActions(null);
            }

            else
            {
                var entity = Context.Workshops.Find(id);
                var state = BaseWorkshopState.CreateWorkshopState(entity.Status);
                return state.AllowedActions(entity);
            }
        }

        public WorkshopStatistics GetStatistics()
        {
            var now = DateTime.Now;
            var startOfMonth = new DateTime(now.Year, now.Month, 1);
            var startOfNextMonth = startOfMonth.AddMonths(1);

            return new WorkshopStatistics
            {
                TotalWorkshops = Context.Workshops.Count(),
                Upcoming = Context.Workshops.Where(x => x.Status == "Published").Count(),
                AverageParticipants = (int)Context.Workshops.Average(x => x.Participants),

            };
        }

        public async Task<bool> EnrollInWorkshopAsync(int clientId, int? childId, int workshopId, string? paymentIntentId = null)
        {
            var workshop = await Context.Workshops.FindAsync(workshopId);

            if (workshop == null) return false;

            var client = await Context.Clients.FirstOrDefaultAsync(x => x.ClientId == clientId);

            if (client == null) return false;

            if (childId != null)
            {
                var child = Context.Children.Find(childId);

                if (child == null) return false; 

                var clientsChild = Context.ClientsChildren
                    .FirstOrDefault(x => x.ClientId == clientId && x.ChildId == childId);

                if (clientsChild == null) return false;

                if (workshop.WorkshopType == "Parents") return false; 
            }

            // Check if already enrolled
            var existingParticipant = await Context.Participants
                .AnyAsync(x => x.WorkshopId == workshopId && x.UserId == clientId && (childId == null || x.ChildId == childId));

            if (existingParticipant) return false;

            // For paid workshops, verify payment
            if (workshop.Price != null)
            {
                if (string.IsNullOrEmpty(paymentIntentId))
                    return false;

                var isPaymentVerified = await _paymentService.VerifyPaymentAsync(paymentIntentId);
                if (!isPaymentVerified)
                    return false;

                var paymentRecord = await Context.Payments
                .FirstOrDefaultAsync(pr => pr.PaymentIntentId == paymentIntentId);

                if (paymentRecord == null) return false; 

                // Update payment status
                paymentRecord.Status = Models.Enums.PaymentStatus.Completed.ToString();
                paymentRecord.CompletedAt = DateTime.Now;
            }

            // Check capacity
            var currentParticipants = await Context.Participants
                .CountAsync(wp => wp.WorkshopId == workshopId);

            if (currentParticipants >= workshop.MaxParticipants)
                return false;

            // Enroll 
            var participant = new Database.Participant
            {
                UserId = clientId,
                ChildId = childId,
                WorkshopId = workshop.WorkshopId,
                AttendanceStatusId = 1,
                RegistrationDate = DateTime.Now,
                ModifiedDate = DateTime.Now,
                PaymentIntentId = paymentIntentId
            };

            Context.Participants.Add(participant);

            workshop.Participants = (workshop.Participants ?? 0) + 1;
            workshop.ModifiedDate = DateTime.Now;

            await Context.SaveChangesAsync();

            _logger.LogInformation("User {clientId} enrolled in workshop {WorkshopId}", clientId, workshopId);
            return true;
        }

        public async Task<bool> IsEnrolledInWorkshopAsync(int client, int? childId, int workshopId)
        {
            return await Context.Participants.AnyAsync(x => x.WorkshopId == workshopId 
                                                         && x.UserId == client 
                                                         && (childId == null 
                                                         || x.ChildId == childId));
        }
    }
}
