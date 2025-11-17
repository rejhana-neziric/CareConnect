using CareConnect.Models.SearchObjects;
using CareConnect.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
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

        public virtual object Delete(int id)
        {
            var entity = GetByIdWithIncludes(id);

            if (entity == null) return new { success = false, message = "Not found."};

            try
            {
                BeforeDelete(entity);

                Context.Set<TDbEntity>().Remove(entity);
                Context.SaveChanges();

                AfterDelete(id);

                return new { success = true, message = "Deleted successfully."};
            }
            catch (DbUpdateException ex)
            {
                if (ex.InnerException != null &&
                   (ex.InnerException.Message.Contains("REFERENCE constraint") ||
                    ex.InnerException.Message.Contains("FOREIGN KEY constraint")))
                {
                    return new { success = false, message = "Sorry, you cannot delete this item because it is referenced by other records." };
                }

                return new { success = false, message = "An error occurred while deleting." };
            }
        }

        public virtual void BeforeDelete(TDbEntity entity) { }

        public virtual void AfterDelete(int id) { }
    }
}
