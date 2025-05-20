using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface ISessionService : ICRUDService<Session, SessionSearchObject, SessionAdditionalData, SessionInsertRequest, SessionUpdateRequest>
    {
    }
}