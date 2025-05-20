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

namespace CareConnect.Services
{
    public class InstructorService : BaseCRUDService<Models.Responses.Instructor, InstructorSearchObject, InstructorAdditionalData, Instructor, InstructorInsertRequest, InstructorUpdateRequest>, IInstructorService
    {
        public InstructorService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Instructor> AddFilter(InstructorSearchObject search, IQueryable<Instructor> query)
        {
            query = base.AddFilter(search, query);


            if (!string.IsNullOrWhiteSpace(search?.FirstNameGTE))
            {
                query = query.Where(x => x.FirstName.StartsWith(search.FirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.LastNameGTE))
            {
                query = query.Where(x => x.LastName.StartsWith(search.LastNameGTE));
            }

            return query;
        }

        protected override void AddInclude(InstructorAdditionalData additionalData, ref IQueryable<Instructor> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsSessionsIncluded.HasValue && additionalData.IsSessionsIncluded == true)
                {
                    additionalData.IncludeList.Add("Sessions");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(InstructorInsertRequest request, Instructor entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(InstructorUpdateRequest request, ref Instructor entity)
        {
            //entity.ModifiedDate = DateTime.Now;

            base.BeforeUpdate(request, ref entity);
        }

        public override Instructor GetByIdWithIncludes(int id)
        {
            return Context.Instructors
                .Include(i => i.Sessions)
                .First(i => i.InstructorId == id);
        }

        public override void BeforeDelete(Instructor entity)
        {
            foreach (var session in entity.Sessions)
                Context.Remove(session);

            base.BeforeDelete(entity);
        }

        public override void AfterDelete(int id)
        {

        }
    }
}
