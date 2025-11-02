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
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using CareConnect.Models.SearchObjects;
using CareConnect.Models.Requests;

namespace CareConnect.Services
{
    public class ParticipantService : BaseCRUDService<Models.Responses.Participant, ParticipantSearchObject, ParticipantAdditionalData, Participant, ParticipantInsertRequest, ParticipantUpdateRequest>, IParticipantService
    {
        public ParticipantService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Participant> AddFilter(ParticipantSearchObject search, IQueryable<Participant> query)
        {
            query = base.AddFilter(search, query);

            query = query.Include(x => x.Child);
            query = query.Include(x => x.AttendanceStatus); 

            if (search?.WorkshopId.HasValue == true)
            {
                query = query.Where(x => x.WorkshopId == search.WorkshopId);
            }

            if (!string.IsNullOrWhiteSpace(search?.UserFirstNameGTE))
            {
                query = query.Where(x => x.User.FirstName.StartsWith(search.UserFirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.UserLastNameGTE))
            {
                query = query.Where(x => x.User.LastName.StartsWith(search.UserLastNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.WorkshopNameGTE))
            {
                query = query.Where(x => x.Workshop.Name.StartsWith(search.WorkshopNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.AttendanceStatusNameGTE))
            {
                query = query.Where(x => x.AttendanceStatus.Name.StartsWith(search.AttendanceStatusNameGTE));
            }

            if (search?.RegistrationDateGTE.HasValue == true)
            {
                query = query.Where(x => x.RegistrationDate >= search.RegistrationDateGTE);
            }

            if (search?.RegistrationDateLTE.HasValue == true)
            {
                query = query.Where(x => x.RegistrationDate <= search.RegistrationDateLTE);
            }

            if (search?.UserId.HasValue == true)
            {
                query = query.Where(x => x.UserId == search.UserId);
            }

            if (!string.IsNullOrWhiteSpace(search?.SortBy))
            {
                query = query.Include(x => x.AttendanceStatus); 

                query = search?.SortBy switch
                {
                    "firstName" => search.SortAscending ? query.OrderBy(x => x.Child == null ? x.User.FirstName : x.Child.FirstName) : 
                                                          query.OrderByDescending(x => x.Child == null ? x.User.FirstName : x.Child.FirstName),
                    "lastName" => search.SortAscending ? query.OrderBy(x => x.Child == null ? x.User.LastName : x.Child.LastName) : 
                                                         query.OrderByDescending(x => x.Child == null ? x.User.LastName : x.Child.LastName),
                    "date" => search.SortAscending ? query.OrderBy(x => x.RegistrationDate) : query.OrderByDescending(x => x.RegistrationDate),
                    "status" => search.SortAscending ? query.OrderBy(x => x.AttendanceStatus.Name) : query.OrderByDescending(x => x.AttendanceStatus.Name),
                    _ => query
                };
            }

            return query;
        }

        protected override void AddInclude(ParticipantAdditionalData additionalData, ref IQueryable<Participant> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsUserIncluded.HasValue && additionalData.IsUserIncluded == true)
                {
                    additionalData.IncludeList.Add("User");
                }

                if (additionalData.IsWorkshopIncluded.HasValue && additionalData.IsWorkshopIncluded == true)
                {
                    additionalData.IncludeList.Add("Workshop");
                }

                if (additionalData.IsAttendanceStatusIncluded.HasValue && additionalData.IsAttendanceStatusIncluded == true)
                {
                    additionalData.IncludeList.Add("AttendanceStatus");
                }

                if (additionalData.IsChildIncluded.HasValue && additionalData.IsChildIncluded == true)
                {
                    additionalData.IncludeList.Add("Child");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(ParticipantInsertRequest request, Participant entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(ParticipantUpdateRequest request, ref Participant entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Participant GetByIdWithIncludes(int id)
        {
            return Context.Participants
                .Include(u => u.User)
                .Include(w => w.Workshop)
                .Include(a => a.AttendanceStatus)
                .Include(c => c.Child)
                .First(p => p.ParticipantId == id);
        }
    }
}
