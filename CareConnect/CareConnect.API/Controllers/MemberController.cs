using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MemberController : BaseCRUDController<Member, MemberSearchObject, MemberAdditionalData, MemberInsertRequest, MemberUpdateRequest>
    {
        public MemberController(IMemberService service) : base(service) { }
    }
}
