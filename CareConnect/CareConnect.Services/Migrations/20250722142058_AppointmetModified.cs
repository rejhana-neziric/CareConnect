using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class AppointmetModified : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Appointments_Users",
                table: "Appointments");

            migrationBuilder.RenameColumn(
                name: "UserID",
                table: "Appointments",
                newName: "UserId");

            migrationBuilder.AlterColumn<int>(
                name: "UserId",
                table: "Appointments",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "ChildId",
                table: "Appointments",
                type: "int",
                nullable: false,
                defaultValue: 1);

            migrationBuilder.AddColumn<int>(
                name: "ClientId",
                table: "Appointments",
                type: "int",
                nullable: false,
                defaultValue: 9);

            migrationBuilder.CreateIndex(
                name: "IX_Appointments_ClientId_ChildId",
                table: "Appointments",
                columns: new[] { "ClientId", "ChildId" });

            migrationBuilder.AddForeignKey(
                name: "FK_Appointments_ClientsChildren_ClientId_ChildId",
                table: "Appointments",
                columns: new[] { "ClientId", "ChildId" },
                principalTable: "ClientsChildren",
                principalColumns: new[] { "ClientID", "ChildID" },
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Appointments_Users_UserId",
                table: "Appointments",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "UserID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Appointments_ClientsChildren_ClientId_ChildId",
                table: "Appointments");

            migrationBuilder.DropForeignKey(
                name: "FK_Appointments_Users_UserId",
                table: "Appointments");

            migrationBuilder.DropIndex(
                name: "IX_Appointments_ClientId_ChildId",
                table: "Appointments");

            migrationBuilder.DropColumn(
                name: "ChildId",
                table: "Appointments");

            migrationBuilder.DropColumn(
                name: "ClientId",
                table: "Appointments");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "Appointments",
                newName: "UserID");

            migrationBuilder.AlterColumn<int>(
                name: "UserID",
                table: "Appointments",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Appointments_Users",
                table: "Appointments",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "UserID");
        }
    }
}
