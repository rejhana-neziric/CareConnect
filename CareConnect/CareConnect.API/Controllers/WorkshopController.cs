using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WorkshopController : BaseCRUDController<Workshop, WorkshopSearchObject, WorkshopAdditionalData, WorkshopInsertRequest, WorkshopUpdateRequest>
    {
        public WorkshopController(IWorkshopService service) : base(service) { }
    }
}
