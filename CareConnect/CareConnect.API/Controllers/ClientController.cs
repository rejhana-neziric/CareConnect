using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ClientController : BaseCRUDController<Client, ClientSearchObject, ClientAdditionalData, ClientInsertRequest, ClientUpdateRequest>
    {
        private readonly IChildService _childService; 
        private readonly IClientsChildService _clientsChildService; 


        public ClientController(IClientService service, IChildService childService, IClientsChildService clientsChildService) : base(service) 
        {   
            _childService = childService; 
            _clientsChildService = clientsChildService; 
        }

        [HttpGet("{id}/children")]
        public List<Child> AddChildToClient(int id)
        {
            return _clientsChildService.GetChildren(id);
        }   
        
        [HttpPost("{id}/children")]
        public ClientsChild AddChildToClient(int id, [FromBody] ChildInsertRequest childInsertRequest)
        {
            var childId = _childService.InsertAndReturnId(childInsertRequest);

            var clientsChild = _clientsChildService.AddChildToClient(id, childId); 

            return clientsChild; 
        }   
    }
}
