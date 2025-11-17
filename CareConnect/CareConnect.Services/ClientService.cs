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
using Stripe.TestHelpers.Treasury;

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
   ///             .Include(c => c.ClientsChildren)
                .First(c => c.ClientId == id);
        }

        public override void BeforeDelete(Client entity)
        {
            var client = Context.Clients
                                        .Include(c => c.ClientsChildren)
                                        .ThenInclude(cc => cc.Child)
                                        .FirstOrDefault(c => c.ClientId == entity.ClientId);

            if (client != null)
            {
                foreach (var clientsChild in client.ClientsChildren)
                {
                    if (!Context.ClientsChildren.Any(cc => cc.ChildId == clientsChild.ChildId && cc.ClientId != client.ClientId))
                    {
                        Context.Remove(clientsChild.Child);
                    }
                    Context.Remove(clientsChild);
                }
            }

            base.BeforeDelete(entity);
        }

        public override void AfterDelete(int clientId)
        {
            var user = Context.Users.FirstOrDefault(u => u.UserId == Context.Clients
                .Where(c => c.ClientId == clientId)
                .Select(c => c.User.UserId)
                .FirstOrDefault());

            if (user != null)
            {
                Context.Remove(user);
            }

            base.AfterDelete(clientId);
        }

        public override object Delete(int id) 
        {
            using var transaction = Context.Database.BeginTransaction();

            try
            {
                var client = Context.Clients
                    .Include(c => c.ClientsChildren)
                        .ThenInclude(cc => cc.Child)
                    .Include(c => c.User)
                    .FirstOrDefault(c => c.ClientId == id);

                if (client == null) return new { success = false, message = "Not found." };

                foreach (var clientsChild in client.ClientsChildren.ToList())
                {
                    var child = clientsChild.Child;

                    Context.ClientsChildren.Remove(clientsChild);

                    bool isChildShared = Context.ClientsChildren
                        .Any(cc => cc.ChildId == child.ChildId && cc.ClientId != id);

                    if (!isChildShared)
                    {
                        Context.Children.Remove(child);
                    }
                }

                Context.Clients.Remove(client);

                if (client.User != null)
                {
                    var userRoles = Context.UsersRoles.Where(ur => ur.UserId == client.User.UserId).ToList();
                    Context.UsersRoles.RemoveRange(userRoles);
                    Context.Users.Remove(client.User);
                }

                var reviews = Context.Reviews.Where(r => r.UserId == client.User.UserId).ToList();
                Context.Reviews.RemoveRange(reviews);

                Context.SaveChanges();
                transaction.Commit();

                return new { success = true, message = "Deleted successfully." };
            }
            catch (DbUpdateException ex)
            {
                transaction.Rollback();

                if (ex.InnerException != null &&
                   (ex.InnerException.Message.Contains("REFERENCE constraint") ||
                    ex.InnerException.Message.Contains("FOREIGN KEY constraint")))
                {
                    return new { success = false, message = "Sorry, you cannot delete this item because it is referenced by other records." };
                }

                return new { success = false, message = "An error occurred while deleting." };
            }
        }

        public Models.Responses.Client AddChildToClient(int id, ChildInsertRequest childInsertRequest)
        {
            var client = Context.Clients.Include(x => x.User).First(x => x.ClientId == id);

            return Mapper.Map<Models.Responses.Client>(client);
        }
    }
}
