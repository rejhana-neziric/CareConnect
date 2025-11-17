using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using EasyNetQ.Logging;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using System.Linq.Dynamic.Core;
using System.Security.Permissions;
using System.Xml;

namespace CareConnect.Services
{
    public class ClientsChildService 
        : BaseCRUDService<Models.Responses.ClientsChild, ClientsChildSearchObject, ClientsChildAdditionalData, Database.ClientsChild, ClientsChildInsertRequest, ClientsChildUpdateRequest>, IClientsChildService
    {
        public CareConnectContext Context { get; set; }

        public IMapper Mapper { get; }

        private readonly IChildService _childService;
        private readonly IClientService _clientService; 

        public ClientsChildService(CareConnectContext context, IMapper mapper, IChildService childService, IClientService clientService) : base(context, mapper)
        {
            _childService = childService;
            _clientService = clientService;   

            Mapper = mapper;
            Context = context;
        }


        public override IQueryable<Database.ClientsChild> AddFilter(ClientsChildSearchObject search, IQueryable<Database.ClientsChild> query)
        {
            query = base.AddFilter(search, query);

            query = query.Include(x => x.Child).Include(x => x.Client).ThenInclude(x => x.User);

            query = query.Include(x => x.Client).ThenInclude(x => x.User);

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(x =>
                    x.Client.User.FirstName.StartsWith(search.FTS) ||
                    x.Client.User.LastName.StartsWith(search.FTS) ||
                    x.Client.User.Email == search.FTS ||
                    x.Child.FirstName.StartsWith(search.FTS) ||
                    x.Child.LastName.StartsWith(search.FTS)
                );
            }

            if (search.clientSearchObject != null)
            {
                if (search.clientSearchObject?.EmploymentStatus.HasValue == true)
                {
                    query = query.Where(x => x.Client.EmploymentStatus == search.clientSearchObject.EmploymentStatus);
                }
            }

            if (search.childSearchObject != null)
            {
                if (!string.IsNullOrWhiteSpace(search.childSearchObject?.Gender))
                {
                    query = query.Where(x => search.childSearchObject.Gender.StartsWith(x.Child.Gender.ToString()));
                }

                if (search.childSearchObject?.BirthDateGTE.HasValue == true)
                {
                    var mappedBirthDate = search.childSearchObject.BirthDateGTE;
                    query = query.Where(x => x.Child.BirthDate >= mappedBirthDate);
                }

                if (search.childSearchObject?.BirthDateLTE.HasValue == true)
                {
                    var mappedBirthDate = search.childSearchObject.BirthDateLTE;
                    query = query.Where(x => x.Child.BirthDate <= mappedBirthDate);
                }
            }

            if (!string.IsNullOrWhiteSpace(search?.SortBy))
            {
                query = search?.SortBy switch
                {
                    "clientFirstName" => search.SortAscending ? query.OrderBy(x => x.Client.User.FirstName) : query.OrderByDescending(x => x.Client.User.FirstName),
                    "clientLastName" => search.SortAscending ? query.OrderBy(x => x.Client.User.LastName) : query.OrderByDescending(x => x.Client.User.LastName),
                    "childFirstName" => search.SortAscending ? query.OrderBy(x => x.Child.FirstName) : query.OrderByDescending(x => x.Child.FirstName),
                    "childLastName" => search.SortAscending ? query.OrderBy(x => x.Child.LastName) : query.OrderByDescending(x => x.Child.LastName),
                    "childBirthDate" => search.SortAscending ? query.OrderBy(x => x.Child.BirthDate) : query.OrderByDescending(x => x.Child.BirthDate),
                    _ => query
                };
            }

            return query;
        }

        protected override void AddInclude(ClientsChildAdditionalData additionalData, ref IQueryable<Database.ClientsChild> query)
        {
            if (additionalData != null)
            {
                if (additionalData.IsChildIncluded.HasValue && additionalData.IsChildIncluded == true)
                {
                    additionalData.IncludeList.Add("Child");
                }

                if (additionalData.IsClientIncluded.HasValue && additionalData.IsClientIncluded == true)
                {
                    additionalData.IncludeList.Add("Client");
                }
            }

            base.AddInclude(additionalData, ref query);
        }

      

        public override void AfterInsert(Database.ClientsChild entity)
        {
            var client = Context.Clients.Local.FirstOrDefault(x => x.ClientId == entity.ClientId) ?? Context.Clients.Find(entity.ClientId);

            if (client == null) return;

            var roleId = Context.Roles.Where(x => x.Name == "Employee").Select(x => x.RoleId).FirstOrDefault();

            if (roleId == 0) return;

            var alreadyExists = Context.UsersRoles.Any(x => x.UserId == entity.ClientId && x.RoleId == roleId);

            if(!alreadyExists) 
            {
                var request = new UsersRoleInsertRequest()
                {
                    RoleId = roleId,
                    UserId = entity.ClientId,
                };

                var dbEntity = Mapper.Map<Database.UsersRole>(request);

                Context.Add(dbEntity);
            }
           
            base.AfterInsert(entity);
        }

        public List<Models.Responses.Child> GetChildren(int clientId)
        {
            var client = Context.Clients.Include(c => c.ClientsChildren)
                                            .ThenInclude(c => c.Child)
                                        .FirstOrDefault(c => c.ClientId == clientId);

            if (client == null) return null;

            var children = client.ClientsChildren.Select(c => c.Child).ToList();

            return Mapper.Map<List<Models.Responses.Child>>(children);
        }

        public Models.Responses.ClientsChild AddChildToClient(int clientId, ChildInsertRequest childInsertRequest)
        {

            using var transaction = Context.Database.BeginTransaction();

            try
            {
                var child = _childService.Insert(childInsertRequest);

                var clientsChild = new Database.ClientsChild
                {
                    ClientId = clientId,
                    ChildId = child.ChildId,
                    CreatedAt = DateTime.Now
                };

                Context.ClientsChildren.Add(clientsChild);
                Context.SaveChanges();


                var response = Context.ClientsChildren.Include(x => x.Client)
                                            .ThenInclude(x => x.User).Include(x => x.Child)
                                        .FirstOrDefault(x => x.ClientId == clientId && x.ChildId == child.ChildId);

                transaction.Commit();

                return Mapper.Map<Models.Responses.ClientsChild>(response);

            }
            catch (Exception ex)
            {

                transaction.Rollback();
                throw;
            }
        }


        public object RemoveChildFromClient(int clientId, int childId)
        {
            using var transaction = Context.Database.BeginTransaction();

            try
            {
                var clientsChild = Context.ClientsChildren.FirstOrDefault(x => x.ClientId == clientId && x.ChildId == childId);

                if (clientsChild == null) return new { success = false, message = "Not found." };

                Context.ClientsChildren.Remove(clientsChild);   
                
                Context.SaveChanges();

                var child = _childService.Delete(childId);  

                transaction.Commit();

                return new { success = true, message = "Deleted successfully." };

            }
            catch (DbUpdateConcurrencyException)
            {
                transaction.Rollback();
                return new { success = false, message = "The item was already deleted or modified by another process." };
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

        public override Models.Responses.ClientsChild Insert(ClientsChildInsertRequest request)
        {
            using var transaction = Context.Database.BeginTransaction();

            try
            {
                var client = _clientService.Insert(request.clientInsertRequest); 
                var child = _childService.Insert(request.childInsertRequest);   

                var clientsChild = new Database.ClientsChild
                {
                    ClientId = client.User.UserId,
                    ChildId = child.ChildId, 
                    CreatedAt = request.CreatedAt
                };  

                Context.ClientsChildren.Add(clientsChild);
                AfterInsert(clientsChild);
                Context.SaveChanges();  

                transaction.Commit();

                var saved = Context.ClientsChildren
                            .Include(cc => cc.Client)
                            .Include(cc => cc.Child)
                            .FirstOrDefault(cc => cc.ClientId == clientsChild.ClientId && cc.ChildId == clientsChild.ChildId);


                return new Models.Responses.ClientsChild
                {
                    Child = new Models.Responses.Child 
                    { 
                        ChildId = saved.ChildId, 
                        FirstName = saved.Child.FirstName, 
                        LastName = saved.Child.LastName,
                        BirthDate = saved.Child.BirthDate, 
                        Gender = saved.Child.Gender},
                    Client = new Models.Responses.Client
                    { 
                        EmploymentStatus = saved.Client.EmploymentStatus, 
                        User = new Models.Responses.User 
                        { 
                            UserId = saved.ClientId, 
                            FirstName = saved.Client.User.FirstName, 
                            LastName = saved.Client.User.LastName, 
                            Email = saved.Client.User.Email, 
                            Address = saved.Client.User.Address, 
                            BirthDate = saved.Client.User.BirthDate, 
                            PhoneNumber = saved.Client.User.PhoneNumber, 
                            Username = saved.Client.User.Username,
                            Status = saved.Client.User.Status, 
                            Gender = saved.Client.User.Gender 
                        } 
                    }   
                };


            }
            catch (Exception ex)
            {

               transaction.Rollback();
                throw; 
            }
        }

        public override Models.Responses.ClientsChild Update(int id, ClientsChildUpdateRequest request)
        {
            var response = _clientService.Update(id, request.clientUpdateRequest);

            var clientsChild = Context.ClientsChildren.Include(x => x.Child).Include(x => x.Client).ThenInclude(x => x.User).Where(x => x.ClientId == id).FirstOrDefault(); 

            return Mapper.Map<Models.Responses.ClientsChild>(clientsChild);
        }

        public ClientsChildStatistics GetStatistics()
        {
            var now = DateTime.Now;
            var startOfMonth = new DateTime(now.Year, now.Month, 1);
            var startOfNextMonth = startOfMonth.AddMonths(1);

            return new ClientsChildStatistics
            {
                TotalParents = Context.Clients.Count(),
                TotalChildren = Context.Children.Count(),
                EmployedParents = Context.Clients.Count(x => x.EmploymentStatus == true),
                NewClientsThisMonth = Context.Clients.Where(m => m.CreatedDate >= startOfMonth && m.CreatedDate < startOfNextMonth).Count(), 
                 ChildrenPerAgeGroup = Context.Children.GroupBy(d =>
                    d.BirthDate.Year <= DateTime.Now.Year - 6 ? "6+" :
                    d.BirthDate.Year <= DateTime.Now.Year - 4 ? "4-6" : "0-3")
                        .Select(g => new AgeGroup
                        {
                            Category = g.Key,
                            Number = g.Count()
                        }).ToList(),
                ChildrenPerGender = Context.Children.GroupBy(x => x.Gender).Select(g => new GenderGroup { Gender = g.Key, Number = g.Count() }).ToList(),
            }; 
        }

        public Models.Responses.ClientsChild GetClientAndChildByIds(int clientId, int childId)
        {
            var response = Context.ClientsChildren.Where(x => x.ClientId == clientId && x.ChildId == childId).Include(x => x.Client)
                                                                                                              .Include(x => x.Client.User)
                                                                                                              .Include(x => x.Appointments)
                                                                                                              .Include(x => x.Child)
                                                                                                              .FirstOrDefault();

            if (response == null) return null;

            return Mapper.Map<Models.Responses.ClientsChild>(response);
        }

        public List<Models.Responses.Appointment> GetAppointment(int clientId, int childId)
        {
            var client = Context.Clients.Find(clientId);

            var child = Context.Children.Find(childId);

            var clientsChild = Context.ClientsChildren.Where(x => x.ClientId == clientId && x.ChildId == childId).FirstOrDefault(); 

            if (client == null || child == null || clientsChild == null) return null;

            var response = Context.ClientsChildren.Where(x => x.ClientId == clientId && x.ChildId == childId).SelectMany(x => x.Appointments).Include(x => x.EmployeeAvailability).ThenInclude(x => x.Employee).ThenInclude(x => x.User).Include(x => x.EmployeeAvailability).ThenInclude(x=> x.Service).ToList();

            if (response.Any() == false) return null;

            List<Models.Responses.Appointment> list = new List<Models.Responses.Appointment>();

            foreach (var appointment in response)
            {
                list.Add(Mapper.Map<Models.Responses.Appointment>(appointment));
            }

            return list;
        }
    }
}