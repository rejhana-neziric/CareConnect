using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class UpdateModelConfig : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Appointments_EmployeeAvailability",
                table: "Appointments");

            migrationBuilder.AddForeignKey(
                name: "FK_Appointments_EmployeeAvailability",
                table: "Appointments",
                column: "EmployeeAvailabilityID",
                principalTable: "EmployeeAvailability",
                principalColumn: "EmployeeAvailabilityID",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Appointments_EmployeeAvailability",
                table: "Appointments");

            migrationBuilder.AddForeignKey(
                name: "FK_Appointments_EmployeeAvailability",
                table: "Appointments",
                column: "EmployeeAvailabilityID",
                principalTable: "EmployeeAvailability",
                principalColumn: "EmployeeAvailabilityID");
        }
    }
}
