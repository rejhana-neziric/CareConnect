using CareConnect.Services.Seed;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class SeedPermissions : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            var permissions = PermissionSeeder.GetAllPermissions();

            foreach (var permission in permissions)
            {
                migrationBuilder.InsertData(
                    table: "Permissions",
                    columns: new[] { "Name" },
                    values: new object[] { permission }
                );
            }
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
