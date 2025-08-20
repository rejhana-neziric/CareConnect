using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class NotNullableEmployeeInReview : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {

            migrationBuilder.DropForeignKey(
                name: "FK_Reviews_Employees",
                table: "Reviews");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_EmployeeID",
                table: "Reviews",
                column: "EmployeeID");

            migrationBuilder.AlterColumn<int>(
                name: "EmployeeID",
                table: "Reviews",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Reviews_Employees",
                table: "Reviews",
                column: "EmployeeID",
                principalTable: "Employees",
                principalColumn: "EmployeeID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
             name: "FK_Reviews_Employees",
             table: "Reviews");

            migrationBuilder.AlterColumn<int>(
                name: "EmployeeID",
                table: "Reviews",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            // Recreate FK
            migrationBuilder.AddForeignKey(
                name: "FK_Reviews_Employees",
                table: "Reviews",
                column: "EmployeeID",
                principalTable: "Employees",
                principalColumn: "EmployeeID");
        }
    }
}
