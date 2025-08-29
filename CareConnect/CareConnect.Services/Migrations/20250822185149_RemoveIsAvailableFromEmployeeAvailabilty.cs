using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class RemoveIsAvailableFromEmployeeAvailabilty : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsAvailable",
                table: "EmployeeAvailability");

            migrationBuilder.DropColumn(
                name: "ReasonOfUnavailability",
                table: "EmployeeAvailability");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsAvailable",
                table: "EmployeeAvailability",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "ReasonOfUnavailability",
                table: "EmployeeAvailability",
                type: "nvarchar(500)",
                maxLength: 500,
                nullable: true);
        }
    }
}
