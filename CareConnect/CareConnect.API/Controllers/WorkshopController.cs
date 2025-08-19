using CareConnect.API.Filters;
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

        [HttpPut("{id}/cancel")]
        [PermissionAuthorize("Cancel")]
        public Workshop Cancel(int id)
        {
            return (_service as IWorkshopService)!.Cancel(id);
        }

        [HttpPut("{id}/publish")]
        [PermissionAuthorize("Publish")]
        public Workshop Publish(int id)
        {
            return (_service as IWorkshopService)!.Publish(id);
        }

        [HttpPut("{id}/close")]
        [PermissionAuthorize("Close")]
        public Workshop Close(int id)
        {
            return (_service as IWorkshopService)!.Close(id);
        }

        [HttpGet("{id}/allowedActions")]
        [PermissionAuthorize("AllowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IWorkshopService)!.AllowedActions(id);
        }

        [HttpGet("statistics")]
        [PermissionAuthorize("GetStatistics")]
        public WorkshopStatistics GetStatistics()
        {
            return (_service as WorkshopService).GetStatistics();
        }
    }
}
