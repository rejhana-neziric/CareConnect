using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services
{
    public abstract class BaseService<TModel, TSearch, TDbEntity> : IService<TModel, TSearch> 
        where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        public _210024Context Context { get; set; }

        public IMapper Mapper { get; }

        public BaseService(_210024Context context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public Models.PagedResult<TModel> GetPaged(TSearch search)
        {
            List<TModel> result = new List<TModel>();

            var query = Context.Set<TDbEntity>().AsQueryable();

            query = AddFilter(search, query);

            int count = query.Count();

            if (search.PageSize.HasValue && search.Page.HasValue)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = query.ToList();

            result = Mapper.Map(list, result);

            Models.PagedResult<TModel> pagedResult = new Models.PagedResult<TModel>();

            pagedResult.ResultList = result;
            pagedResult.Count = count;

            return pagedResult;
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }

        public TModel GetById(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);

            if (entity != null)
            {
                return Mapper.Map<TModel>(entity);
            }

            else
            {
                return null;
            }
        }
    }
}
