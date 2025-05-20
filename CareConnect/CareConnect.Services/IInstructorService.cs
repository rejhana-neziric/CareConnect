using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IInstructorService : ICRUDService<Instructor, InstructorSearchObject, InstructorAdditionalData, InstructorInsertRequest, InstructorUpdateRequest>
    {
    }
}
