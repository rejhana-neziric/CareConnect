using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using System;
using System.Linq;

namespace CareConnect.Services
{
    public abstract class BaseCRUDService<TModel, TSearch, TSearchAdditionalData, TDbEntity, TInsert, TUpdate> : BaseService<TModel, TSearch, TSearchAdditionalData, TDbEntity>
        where TModel : class
        where TSearch : BaseSearchObject<TSearchAdditionalData>
        where TDbEntity : class
        where TSearchAdditionalData : BaseAdditionalSearchRequestData
    {
        public BaseCRUDService(CareConnectContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual TModel Insert(TInsert request)
        {
            TDbEntity entity = Mapper.Map<TDbEntity>(request);

            BeforeInsert(request, entity);

            Context.Add(entity);
            Context.SaveChanges();

            AfterInsert(entity); 

            return Mapper.Map<TModel>(entity);
        }

        public virtual void BeforeInsert(TInsert request, TDbEntity entity) { }

        public virtual void AfterInsert(TDbEntity entity) { }

        public virtual TModel Update(int id, TUpdate request)
        {
            var entity = GetByIdWithIncludes(id);

            if (entity == null) return null;

            Mapper.Map(request, entity);

            BeforeUpdate(request, ref entity);

            Context.SaveChanges();

            return Mapper.Map<TModel>(entity);
        }

        public virtual void BeforeUpdate(TUpdate request, ref TDbEntity entity) { }

        public virtual TDbEntity? GetByIdWithIncludes(int id)
        {
            return Context.Set<TDbEntity>().Find(id);
        }

        public virtual bool Delete(int id)
        {
            var entity = GetByIdWithIncludes(id);

            if (entity == null) return false;

            BeforeDelete(entity);

            Context.Set<TDbEntity>().Remove(entity);
            Context.SaveChanges();

            AfterDelete(id);

            return true;
        }

        public virtual void BeforeDelete(TDbEntity entity) { }

        public virtual void AfterDelete(int id) { }
    }
}
