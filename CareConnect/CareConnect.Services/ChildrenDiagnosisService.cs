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
using System.Security.Cryptography.X509Certificates;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public class ChildrenDiagnosisService : BaseCRUDService<Models.Responses.ChildrenDiagnosis, ChildrenDiagnosisSearchObject, ChildrenDiagnosisAdditionalData, ChildrenDiagnosis, ChildrenDiagnosisInsertRequest, ChildrenDiagnosisUpdateRequest>, IChildrenDiagnosisService
    {
        public ChildrenDiagnosisService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<ChildrenDiagnosis> AddFilter(ChildrenDiagnosisSearchObject search, IQueryable<ChildrenDiagnosis> query)
        {
            query = base.AddFilter(search, query);


            if (search?.DiagnosisDateGTE.HasValue == true)
            {
                query = query.Where(x => x.DiagnosisDate >= search.DiagnosisDateGTE);
            }

            if (search?.DiagnosisDateLTE.HasValue == true)
            {
                query = query.Where(x => x.DiagnosisDate <= search.DiagnosisDateLTE);
            }

            if (!string.IsNullOrWhiteSpace(search?.ChildFirstNameGTE))
            {
                query = query.Where(x => x.Child.FirstName.StartsWith(search.ChildFirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.ChildLastNameGTE))
            {
                query = query.Where(x => x.Child.LastName.StartsWith(search.ChildLastNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.DiagnosisNameGTE))
            {
                query = query.Where(x => x.Diagnosis.Name.StartsWith(search.DiagnosisNameGTE));
            }

            return query;
        }

        protected override void AddInclude(ChildrenDiagnosisAdditionalData additionalData, ref IQueryable<ChildrenDiagnosis> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsChildIncluded.HasValue && additionalData.IsChildIncluded == true)
                {
                    additionalData.IncludeList.Add("Child");
                }

                if (additionalData.IsDiagnosisIncluded.HasValue && additionalData.IsDiagnosisIncluded == true)
                {
                    additionalData.IncludeList.Add("Diagnosis");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(ChildrenDiagnosisInsertRequest request, ChildrenDiagnosis entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(ChildrenDiagnosisUpdateRequest request, ref ChildrenDiagnosis entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override ChildrenDiagnosis GetByIdWithIncludes(int id)
        {
            return Context.ChildrenDiagnoses
                .Include(c => c.Child)
                .Include(d => d.Diagnosis)
                .First(c => c.ChildId == id);
        }

        public override Models.Responses.ChildrenDiagnosis GetById(int id, ChildrenDiagnosisAdditionalData additionalData = null)
        {
            var query = Context.Set<ChildrenDiagnosis>().AsQueryable();

            if (additionalData != null)
            {
                AddInclude(additionalData, ref query);
            }

            var entity = query.FirstOrDefault(e => EF.Property<int>(e, "ChildId") == id);

            if (entity == null) return null;

            return Mapper.Map<Models.Responses.ChildrenDiagnosis>(entity);
        }

        public override void BeforeDelete(ChildrenDiagnosis entity)
        {
            /*
            if(entity.Diagnosis != null)    
                Context.Remove(entity.Diagnosis);
            */

            base.BeforeDelete(entity);
        }

        public override void AfterDelete(int id)
        {
            base.AfterDelete(id);
        }
    }
}
