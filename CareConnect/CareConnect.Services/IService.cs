using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public interface IService<TModel, TSearch, TSearchAdditionalData>
        where TSearch : BaseSearchObject<TSearchAdditionalData>
        where TSearchAdditionalData : BaseAdditionalSearchRequestData
    {
        public PagedResult<TModel> Get(TSearch search);

        public TModel GetById(int id, TSearchAdditionalData additionalData);
    }
}
