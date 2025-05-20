using CareConnect.Models.Requests;
using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IMemberService : ICRUDService<Member, MemberSearchObject, MemberAdditionalData, MemberInsertRequest, MemberUpdateRequest>
    {
    }
}
