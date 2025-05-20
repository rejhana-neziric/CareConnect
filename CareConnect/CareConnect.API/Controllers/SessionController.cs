using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SessionController : BaseCRUDController<Session, SessionSearchObject, SessionAdditionalData, SessionInsertRequest, SessionUpdateRequest>
    {
        public SessionController(ISessionService service) : base(service) { }
    }
}