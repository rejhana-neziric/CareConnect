using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IClientsChildService : ICRUDService<ClientsChild, ClientsChildSearchObject, ClientsChildAdditionalData, ClientsChildInsertRequest, ClientsChildUpdateRequest>
    {
        public List<Child> GetChildren(int clientId);

        public Models.Responses.ClientsChild AddChildToClient(int clientId, ChildInsertRequest childInsertRequest); 

        public bool RemoveChildFromClient(int clientId, int childId);

        public ClientsChildStatistics GetStatistics();

        public ClientsChild GetClientAndChildByIds(int clientId, int childId);

        public List<Appointment> GetAppointment(int clientId, int childId); 
    }
}
