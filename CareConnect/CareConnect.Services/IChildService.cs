using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IChildService : ICRUDService<Child, ChildSearchObject, ChildAdditionalData, ChildInsertRequest, ChildUpdateRequest>
    {
        public int InsertAndReturnId(ChildInsertRequest request);
    }
}
