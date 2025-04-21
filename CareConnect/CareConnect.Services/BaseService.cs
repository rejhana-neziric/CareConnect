using CareConnect.Models.Responses;
using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace CareConnect.Services
{
    public abstract class BaseService<TModel, TSearch, TSearchAdditionalData, TDbEntity> : IService<TModel, TSearch, TSearchAdditionalData> 
        where TSearch : BaseSearchObject<TSearchAdditionalData>
        where TDbEntity : class 
        where TModel : class
        where TSearchAdditionalData : BaseAdditionalSearchRequestData
    {
        public _210024Context Context { get; set; }

        public IMapper Mapper { get; }

        //private readonly _210024Context _context;

        //protected readonly IMapper _mapper;

        public BaseService(_210024Context context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public PagedResult<TModel> Get(TSearch search)
        {
            List<TModel> result = new List<TModel>();

            var query = Context.Set<TDbEntity>().AsQueryable();

            if(search.AdditionalData != null) 
            {
                AddInclude(search.AdditionalData, ref query);
            }

            query = AddFilter(search, query);

            int? totalCount = null;

            if (search.IncludeTotalCount)
            {
                totalCount = query.Count();
            }

            if (!search.RetrieveAll && search.Page.HasValue && search.PageSize.HasValue)
            {
                query = query
                    .Skip(search.Page.Value * search.PageSize.Value)
                    .Take(search.PageSize.Value);
            }

            var list = query.ToList();

            result = Mapper.Map(list, result);

            PagedResult<TModel> pagedResult = new PagedResult<TModel>();

            pagedResult.ResultList = result;
            pagedResult.TotalCount = totalCount;

            return pagedResult;
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }

        protected virtual void AddInclude(TSearchAdditionalData additionalData, ref IQueryable<TDbEntity> query)
        {
            if (additionalData != null)
            {
                query = additionalData.IncludeList.Aggregate(query, (current, include) => current.Include(include));
            }
        }

        public virtual TModel GetById(int id, TSearchAdditionalData additionalData = null)
        {
            var query = Context.Set<TDbEntity>().AsQueryable();

            if (additionalData != null)
            {
                AddInclude(additionalData, ref query);
            }
            
            var entityType = typeof(TDbEntity);
            var pkName = entityType.Name + "Id";

            var parameter = Expression.Parameter(entityType, "x");
            var property = Expression.Property(parameter, pkName);
            var constant = Expression.Constant(id);
            var equality = Expression.Equal(property, constant);
            var lambda = Expression.Lambda<Func<TDbEntity, bool>>(equality, parameter);

            var entity = query.FirstOrDefault(lambda);

            if (entity == null) return null; 

            return Mapper.Map<TModel>(entity);
        }
    }
}
