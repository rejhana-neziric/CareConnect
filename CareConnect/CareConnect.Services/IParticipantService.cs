using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{ 
    public interface IParticipantService : ICRUDService<Participant, ParticipantSearchObject, ParticipantAdditionalData, ParticipantInsertRequest, ParticipantUpdateRequest>
    {
    }
}