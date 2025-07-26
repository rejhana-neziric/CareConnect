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
    public class ClientsChildController : BaseCRUDController<ClientsChild, ClientsChildSearchObject, ClientsChildAdditionalData, ClientsChildInsertRequest, NoRequest>
    {
        public ClientsChildController(IClientsChildService service) : base(service)
        {
        }

        public override ClientsChild Update(int id, NoRequest request)
        {
            throw new NotImplementedException();    
        }

        [HttpGet("statistics")]
        [PermissionAuthorize("GetStatistics")]
        public ClientsChildStatistics GetStatistics()
        {
            return (_service as ClientsChildService).GetStatistics();
        }
    }
}
