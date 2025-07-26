using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System.Linq.Dynamic.Core;
using System.Security.Permissions;
using System.Xml;

namespace CareConnect.Services
{
    public class ClientsChildService 
        : BaseCRUDService<Models.Responses.ClientsChild, ClientsChildSearchObject, ClientsChildAdditionalData, Database.ClientsChild, ClientsChildInsertRequest, NoRequest>, IClientsChildService
    {
        //public CareConnectContext Context { get; set; }

        //public IMapper Mapper { get; }

        //public ClientsChildService(CareConnectContext context, IMapper mapper)
        //{
        //    Context = context;
        //    Mapper = mapper;
        //}

        private readonly IChildService _childService;
        private readonly IClientService _clientService; 

        public ClientsChildService(CareConnectContext context, IMapper mapper, IChildService childService, IClientService clientService) : base(context, mapper)
        {
            _childService = childService;
            _clientService = clientService;   
        }


        public override IQueryable<Database.ClientsChild> AddFilter(ClientsChildSearchObject search, IQueryable<Database.ClientsChild> query)
        {
            query = base.AddFilter(search, query);

            query = query.Include(x => x.Child).Include(x => x.Client).ThenInclude(x => x.User);
           // query = query.Include(x => x.Appointments);

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


                if (additionalData.IsAppoinmentIncluded.HasValue && additionalData.IsAppoinmentIncluded == true)
                {
                    additionalData.IncludeList.Add("Appointments");
                }
            }

            base.AddInclude(additionalData, ref query);
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

        public Models.Responses.ClientsChild AddChildToClient(int clientId, int childId)
        {
            var clientsChild = new Database.ClientsChild()
            {
                ClientId = clientId,
                ChildId = childId,
                ModifiedDate = DateTime.Now
            };

            Context.Add(clientsChild);
            Context.SaveChanges();

            var response = Context.ClientsChildren.Include(c => c.Client)
                                                    .ThenInclude(u => u.User)
                                                  .Include(c => c.Child)
                                                  .FirstOrDefault(c => c.ClientId == clientId && c.ChildId == childId);

            if (response == null) return null;

            return Mapper.Map<Models.Responses.ClientsChild>(response);
        }

        // to think about 
        public bool RemoveChildFromClient(int clientId, int childId)
        {
            return true;
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
                NewClientsThisMonth = Context.Members.Where(m => m.JoinedDate >= startOfMonth && m.JoinedDate < startOfNextMonth).Count(), 
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
    }
}