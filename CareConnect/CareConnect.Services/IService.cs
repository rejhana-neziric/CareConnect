using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IService<TModel, TSearch, TSearchAdditionalData> 
        where TSearch : BaseSearchObject<TSearchAdditionalData>
        where TSearchAdditionalData: BaseAdditionalSearchRequestData
    {
        public PagedResult<TModel> Get(TSearch search);

        public TModel GetById(int id, TSearchAdditionalData additionalData); 
    }
}
