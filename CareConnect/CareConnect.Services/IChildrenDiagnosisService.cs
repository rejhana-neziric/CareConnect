using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IChildrenDiagnosisService : ICRUDService<ChildrenDiagnosis, ChildrenDiagnosisSearchObject, ChildrenDiagnosisAdditionalData, ChildrenDiagnosisInsertRequest, ChildrenDiagnosisUpdateRequest>
    {
    }
}
