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
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using CareConnect.Models.SearchObjects;
using System.Security.Permissions;

namespace CareConnect.Services
{
    public class ClientService : BaseCRUDService<Models.Responses.Client, ClientSearchObject, ClientAdditionalData, Database.Client, ClientInsertRequest, ClientUpdateRequest>, IClientService
    {
        private readonly IChildService _childService;   

        public ClientService(CareConnectContext context, IMapper mapper, IChildService childService) : base(context, mapper)
        {
            _childService = childService;
        }

        public override IQueryable<Database.Client> AddFilter(ClientSearchObject search, IQueryable<Database.Client> query)
        {
            query = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.User.FirstName.StartsWith(search.FTS) || x.User.LastName.StartsWith(search.FTS) || x.User.Email == search.FTS);
            }

            if (!string.IsNullOrWhiteSpace(search?.FirstNameGTE))
            {
                query = query.Where(x => x.User.FirstName.StartsWith(search.FirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.LastNameGTE))
            {
                query = query.Where(x => x.User.LastName.StartsWith(search.LastNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(search?.Email))
            {
                query = query.Where(x => x.User.Email == search.Email);
            }

            if (search?.EmploymentStatus.HasValue == true)
            {
                query = query.Where(x => x.EmploymentStatus == search.EmploymentStatus);
            }

            return query;
        }

        protected override void AddInclude(ClientAdditionalData additionalData, ref IQueryable<Database.Client> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsUserIncluded.HasValue && additionalData.IsUserIncluded == true)
                {
                    additionalData.IncludeList.Add("User");
                }

                
                if (additionalData.IsChildrenIncluded.HasValue && additionalData.IsChildrenIncluded == true)
                {
                    additionalData.IncludeList.Add("ClientsChildren.Child");
                }
                
            }

            base.AddInclude(additionalData, ref query);
        }

        public override void BeforeInsert(ClientInsertRequest request, Client entity)
        {
            if (request.User.Password != request.User.ConfirmationPassword)
                throw new Exception("Password and confirmation password must be same.");

            entity.User.PasswordSalt = SecurityHelper.GenerateSalt();
            entity.User.PasswordHash = SecurityHelper.GenerateHash(entity.User.PasswordSalt, request.User.Password);

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(ClientUpdateRequest request, ref Client entity)
        {
            if (request.User != null)
            {
                if (request.User.ConfirmationPassword != null)
                {
                    if (request.User.Password != request.User.ConfirmationPassword)
                        throw new Exception("Password and confirmation password must be same.");

                    entity.User.PasswordSalt = SecurityHelper.GenerateSalt();
                    entity.User.PasswordHash = SecurityHelper.GenerateHash(entity.User.PasswordSalt, request.User.Password);
                }

                Mapper.Map(request.User, entity.User);
                entity.User.ModifiedDate = DateTime.Now; ;
            }

            entity.ModifiedDate = DateTime.Now;

            base.BeforeUpdate(request, ref entity);
        }

        public override Client GetByIdWithIncludes(int id)
        {
            return Context.Clients
                .Include(c => c.User)
                .Include(c => c.ClientsChildren)
                .First(c => c.ClientId == id);
        }

        public override void BeforeDelete(Client entity)
        {
            foreach (var child in entity.ClientsChildren)
                Context.Remove(child);

            //foreach (var review in entity)
            //    Context.Remove(review);

            base.BeforeDelete(entity);
        }

        public override void AfterDelete(int id)
        {
            var user = Context.Users.Find(id);

            if (user != null)
            {
                Context.Remove(user);
                Context.SaveChanges();
            }

            base.AfterDelete(id);
        }

        public Models.Responses.Client AddChildToClient(int id, ChildInsertRequest childInsertRequest)
        {
            var client = Context.Clients.Include(x => x.User).First(x => x.ClientId == id);


            return Mapper.Map<Models.Responses.Client>(client);
        }


    }
}
