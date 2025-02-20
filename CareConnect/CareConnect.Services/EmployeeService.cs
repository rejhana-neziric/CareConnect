using CareConnect.Models;
using CareConnect.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MapsterMapper;
using System.Security.Cryptography;
using CareConnect.Models.Requests;
using CareConnect.Models.SearchObjects;

namespace CareConnect.Services
{
    public class EmployeeService : BaseCRUDService<Models.Employee, EmployeeSearchObject, Database.Employee, EmployeeInsertRequest, EmployeeUpdateRequest>, IEmployeeService
    {
        public EmployeeService(_210024Context context, IMapper mapper) : base(context, mapper) { }


        public override IQueryable<Database.Employee> AddFilter(EmployeeSearchObject search, IQueryable<Database.Employee> query)
        {

            query = base.AddFilter(search, query);

            query = query.Include(x => x.EmployeeNavigation); 

            if (!string.IsNullOrWhiteSpace(search?.JobTitle))
            {
                query = query.Where(x => x.JobTitle == search.JobTitle);
            }

            return query;
        }

        public override void BeforeInsert(EmployeeInsertRequest request, Database.Employee entity)
        {
            if (request.Password != request.ConfirmationPassword)
                throw new Exception("Password and confirmation password must be same.");

            entity.EmployeeNavigation.PasswordSalt = GenerateSalt();
            entity.EmployeeNavigation.PasswordHash = GenerateHash(entity.EmployeeNavigation.PasswordSalt, request.Password);

            base.BeforeInsert(request, entity);
        }

        public static string GenerateSalt()
        {
            var byteArray = RNGCryptoServiceProvider.GetBytes(16);


            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public Models.Employee Update(int id, EmployeeUpdateRequest request)
        {
            var entity = Context.Employees.Find(id);

            Mapper.Map(request, entity);

            if (request.ConfirmationPassword != null)
            {
                if (request.Password != request.ConfirmationPassword)
                    throw new Exception("Password and confirmation password must be same.");

                entity.EmployeeNavigation.PasswordSalt = GenerateSalt();
                entity.EmployeeNavigation.PasswordSalt = GenerateHash(entity.EmployeeNavigation.PasswordSalt, request.Password);
            }

            Context.SaveChanges();

            return Mapper.Map<Models.Employee>(entity);
        }

        public override void BeforeUpdate(EmployeeUpdateRequest request, Database.Employee entity)
        {
            if (request.ConfirmationPassword != null)
            {
                if (request.Password != request.ConfirmationPassword)
                    throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");

                entity.EmployeeNavigation.PasswordSalt = GenerateSalt();
                entity.EmployeeNavigation.PasswordSalt = GenerateHash(entity.EmployeeNavigation.PasswordSalt, request.Password);
            }

            base.BeforeUpdate(request, entity);
        }
    }
}
