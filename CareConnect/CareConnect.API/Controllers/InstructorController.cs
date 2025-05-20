using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class InstructorController : BaseCRUDController<Instructor, InstructorSearchObject, InstructorAdditionalData, InstructorInsertRequest, InstructorUpdateRequest>
    {
        public InstructorController(IInstructorService service) : base(service) { }
    }
}
