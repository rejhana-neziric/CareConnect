using CareConnect.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public interface IService<TModel, TSearch> where TSearch : BaseSearchObject
    {
        public Models.PagedResult<TModel> GetPaged(TSearch search);

        public TModel GetById(int id);
    }
}
