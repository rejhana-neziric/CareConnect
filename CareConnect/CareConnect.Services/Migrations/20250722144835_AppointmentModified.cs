using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class AppointmentModified : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Appointments_ClientsChildren_ClientId_ChildId",
                table: "Appointments");

            migrationBuilder.AddForeignKey(
                name: "FK_Appointments_ClientsChildren",
                table: "Appointments",
                columns: new[] { "ClientId", "ChildId" },
                principalTable: "ClientsChildren",
                principalColumns: new[] { "ClientID", "ChildID" },
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Appointments_ClientsChildren",
                table: "Appointments");

            migrationBuilder.AddForeignKey(
                name: "FK_Appointments_ClientsChildren_ClientId_ChildId",
                table: "Appointments",
                columns: new[] { "ClientId", "ChildId" },
                principalTable: "ClientsChildren",
                principalColumns: new[] { "ClientID", "ChildID" },
                onDelete: ReferentialAction.Cascade);
        }
    }
}
