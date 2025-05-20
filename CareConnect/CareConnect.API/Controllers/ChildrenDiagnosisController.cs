using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services;
using Microsoft.AspNetCore.Mvc;

namespace CareConnect.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ChildrenDiagnosisController : BaseCRUDController<ChildrenDiagnosis, ChildrenDiagnosisSearchObject, ChildrenDiagnosisAdditionalData, ChildrenDiagnosisInsertRequest, ChildrenDiagnosisUpdateRequest>
    {
        public ChildrenDiagnosisController(IChildrenDiagnosisService service) : base(service) { }
    }
}