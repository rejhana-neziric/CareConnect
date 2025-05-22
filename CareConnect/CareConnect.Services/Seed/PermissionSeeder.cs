using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.Seed
{
    public static class PermissionSeeder
    {
        public static List<string> GetAllPermissions()
        {
            var permissionList = new List<string>();

            var permissionClasses = typeof(Permissions).GetNestedTypes();

            foreach (var group in permissionClasses)
            {
                var fields = group.GetFields(BindingFlags.Public | BindingFlags.Static | BindingFlags.FlattenHierarchy);

                foreach (var field in fields)
                {
                    var value = field.GetValue(null)?.ToString();

                    if (!string.IsNullOrEmpty(value))
                    {
                        permissionList.Add(value);
                    }
                }
            }

            return permissionList;
        }
    }
}
