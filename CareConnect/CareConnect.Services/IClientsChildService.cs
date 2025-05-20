using CareConnect.Models.Responses;

namespace CareConnect.Services
{
    public interface IClientsChildService
    {
        public List<Child> GetChildren(int clientId);

        public ClientsChild AddChildToClient(int clientId, int childId);

        public bool RemoveChildFromClient(int clientId, int childId);
    }
}
