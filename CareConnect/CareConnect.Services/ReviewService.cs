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
    public class ReviewService : BaseCRUDService<Models.Responses.Review, ReviewSearchObject, ReviewAdditionalData, Review, ReviewInsertRequest, ReviewUpdateRequest>, IReviewService
    {
        public ReviewService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Review> AddFilter(ReviewSearchObject search, IQueryable<Review> query)
        {
            query = base.AddFilter(search, query);


            if (!string.IsNullOrWhiteSpace(search?.TitleGTE))
            {
                query = query.Where(x => x.Title.StartsWith(search.TitleGTE));
            }

            if (search?.PublishDateGTE.HasValue == true)
            {
                query = query.Where(x => x.PublishDate >= search.PublishDateGTE);
            }

            if (search?.PublishDateLTE.HasValue == true)
            {
                query = query.Where(x => x.PublishDate <= search.PublishDateLTE);
            }

            if (search?.Stars.HasValue == true)
            {
                query = query.Where(x => x.Stars == search.Stars);
            }

            if (!string.IsNullOrWhiteSpace(search?.UserFirstNameGTE))
            {
                query = query.Where(x => x.User.FirstName.StartsWith(search.UserFirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.UserLastNameGTE))
            {
                query = query.Where(x => x.User.LastName.StartsWith(search.UserLastNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.EmployeeFirstNameGTE))
            {
                query = query.Where(x => x.Employee.User.FirstName.StartsWith(search.EmployeeFirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.EmployeeLastNameGTE))
            {
                query = query.Where(x => x.Employee.User.LastName.StartsWith(search.EmployeeLastNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.WorkshopNameGTE))
            {
                query = query.Where(x => x.Workshop.Name.StartsWith(search.WorkshopNameGTE));
            }

            return query;
        }

        protected override void AddInclude(ReviewAdditionalData additionalData, ref IQueryable<Review> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsUserIncluded.HasValue && additionalData.IsUserIncluded == true)
                {
                    additionalData.IncludeList.Add("User");
                }

                if (additionalData.IsEmployeeIncluded.HasValue && additionalData.IsEmployeeIncluded == true)
                {
                    additionalData.IncludeList.Add("Employee");
                    additionalData.IncludeList.Add("Employee.User");
                }

                if (additionalData.IsWorkshopIncluded.HasValue && additionalData.IsWorkshopIncluded == true)
                {
                    additionalData.IncludeList.Add("Workshop");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(ReviewInsertRequest request, Review entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(ReviewUpdateRequest request, ref Review entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Review GetByIdWithIncludes(int id)
        {
            return Context.Reviews
                .Include(u => u.User)
                .Include(e => e.Employee)
                .Include(w => w.Workshop)
                .First(r => r.ReviewId == id);
        }

        public override void BeforeDelete(Review entity)
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
