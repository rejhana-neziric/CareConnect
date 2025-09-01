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
    public class ClientsChildController : BaseCRUDController<ClientsChild, ClientsChildSearchObject, ClientsChildAdditionalData, ClientsChildInsertRequest, ClientsChildUpdateRequest>
    {
        public ClientsChildController(IClientsChildService service) : base(service)
        {
        }

        [HttpGet("statistics")]
        [PermissionAuthorize("GetStatistics")]
        public ClientsChildStatistics GetStatistics()
        {
            return (_service as ClientsChildService).GetStatistics();
        }

        [HttpGet("{clientId}/{childId}")]
        [PermissionAuthorize("GetClientAndChildByIds")]
        public Models.Responses.ClientsChild GetById(int clientId, int childId)
        {
            return (_service as ClientsChildService).GetClientAndChildByIds(clientId, childId);
        }

        [HttpGet("{clientId}/{childId}/appointment")]
        [PermissionAuthorize("GetAppointment")]
        public List<Appointment> GetAppointment(int clientId, int childId)
        {
            return (_service as ClientsChildService).GetAppointment(clientId, childId);
        }
    }
}
