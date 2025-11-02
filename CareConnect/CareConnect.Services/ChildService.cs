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
    public class ChildService : BaseCRUDService<Models.Responses.Child, ChildSearchObject, ChildAdditionalData, Child, ChildInsertRequest, ChildUpdateRequest>, IChildService
    {
        public ChildService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Database.Child> AddFilter(ChildSearchObject search, IQueryable<Database.Child> query)
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

            if (search?.BirthDateGTE.HasValue == true)
            {
                var mappedBirthDate = search.BirthDateGTE;
                query = query.Where(x => x.BirthDate >= mappedBirthDate);
            }

            if (search?.BirthDateLTE.HasValue == true)
            {
                var mappedBirthDate = search.BirthDateLTE;
                query = query.Where(x => x.BirthDate <= mappedBirthDate);
            }

            if (!string.IsNullOrWhiteSpace(search?.Gender))
            {
                query = query.Where(x => search.Gender.StartsWith(x.Gender.ToString()));
            }

            return query;
        }

        protected override void AddInclude(ChildAdditionalData additionalData, ref IQueryable<Database.Child> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsDiagnosisIncluded.HasValue && additionalData.IsDiagnosisIncluded == true)
                {
                    additionalData.IncludeList.Add("ChildrenDiagnoses.Diagnosis");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(ChildInsertRequest request, Child entity)
        {
            base.BeforeInsert(request, entity);
        }

        public int InsertAndReturnId(ChildInsertRequest request)
        {
            var child = Mapper.Map<Child>(request);
            Context.Children.Add(child);
            Context.SaveChanges();
            return child.ChildId;
        }

        public override Child GetByIdWithIncludes(int id)
        {
            return Context.Children
                .First(c => c.ChildId == id);
        }
    }
}
