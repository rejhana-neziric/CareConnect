using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace CareConnect.Services
{
    public class ClientsChildService : IClientsChildService
    {
        public CareConnectContext Context { get; set; }

        public IMapper Mapper { get; }

        public ClientsChildService(CareConnectContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
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
            var clientsChild = new ClientsChild()
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

    }
}