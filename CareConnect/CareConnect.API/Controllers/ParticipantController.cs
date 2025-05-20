using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ParticipantController : BaseCRUDController<Participant, ParticipantSearchObject, ParticipantAdditionalData, ParticipantInsertRequest, ParticipantUpdateRequest>
    {
        public ParticipantController(IParticipantService service) : base(service) { }
    }
}
