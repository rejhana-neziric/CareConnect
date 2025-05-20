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

namespace CareConnect.Services
{
    public class PaymentService : BaseCRUDService<Models.Responses.Payment, PaymentSearchObject, PaymentAdditionalData, Payment, PaymentInsertRequest, PaymentUpdateRequest>, IPaymentService
    {
        public PaymentService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Payment> AddFilter(PaymentSearchObject search, IQueryable<Payment> query)
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

            if (search?.PaymentDateGTE.HasValue == true)
            {
                query = query.Where(x => x.PaymentDate >= search.PaymentDateGTE);
            }

            if (search?.PaymentDateLTE.HasValue == true)
            {
                query = query.Where(x => x.PaymentDate <= search.PaymentDateLTE);
            }

            if (!string.IsNullOrWhiteSpace(search?.PaymentPurposeNameGTE))
            {
                query = query.Where(x => x.PaymentPurpose.Name.StartsWith(search.PaymentPurposeNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.PaymentStatusNameGTE))
            {
                query = query.Where(x => x.PaymentStatus.Name.StartsWith(search.PaymentStatusNameGTE));
            }

            return query;
        }

        protected override void AddInclude(PaymentAdditionalData additionalData, ref IQueryable<Payment> query)
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

        public override void BeforeInsert(PaymentInsertRequest request, Payment entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(PaymentUpdateRequest request, ref Payment entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Payment GetByIdWithIncludes(int id)
        {
            return Context.Payments
                .Include(u => u.User)
                .Include(p => p.PaymentPurpose)
                .Include(p => p.PaymentStatus)
                .First(p => p.PaymentId == id);
        }

        public override void BeforeDelete(Payment entity)
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
    }
}
