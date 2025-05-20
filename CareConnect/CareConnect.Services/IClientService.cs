using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IClientService : ICRUDService<Client, ClientSearchObject, ClientAdditionalData, ClientInsertRequest, ClientUpdateRequest>
    {

    }
}
