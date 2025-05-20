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
    public class MemberService : BaseCRUDService<Models.Responses.Member, MemberSearchObject, MemberAdditionalData, Database.Member, MemberInsertRequest, MemberUpdateRequest>, IMemberService
    {
        public MemberService(CareConnectContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Database.Member> AddFilter(MemberSearchObject search, IQueryable<Database.Member> query)
        {
            query = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.FirstNameGTE))
            {
                query = query.Where(x => x.Client.User.FirstName.StartsWith(search.FirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.LastNameGTE))
            {
                query = query.Where(x => x.Client.User.LastName.StartsWith(search.LastNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.Email))
            {
                query = query.Where(x => x.Client.User.Email == search.Email);
            }

            if (search?.JoinedDateGTE.HasValue == true)
            {
                query = query.Where(x => x.JoinedDate >= search.JoinedDateGTE);
            }

            if (search?.JoinedDateLTE.HasValue == true)
            {
                query = query.Where(x => x.JoinedDate <= search.JoinedDateLTE);
            }

            if (search?.LeftDateGTE.HasValue == true)
            {
                query = query.Where(x => x.LeftDate >= search.LeftDateGTE);
            }

            if (search?.LeftDateLTE.HasValue == true)
            {
                query = query.Where(x => x.LeftDate <= search.LeftDateLTE);
            }

            return query;
        }

        protected override void AddInclude(MemberAdditionalData additionalData, ref IQueryable<Database.Member> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsClientIncluded.HasValue && additionalData.IsClientIncluded == true)
                {
                    additionalData.IncludeList.Add("Client.User");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(MemberInsertRequest request, Member entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(MemberUpdateRequest request, ref Member entity)
        {
            base.BeforeUpdate(request, ref entity);
        }

        public override Member GetByIdWithIncludes(int id)
        {
            return Context.Members
                .Include(m => m.Client)
                .First(m => m.MemberId == id);
        }

        public override void BeforeDelete(Member entity)
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
