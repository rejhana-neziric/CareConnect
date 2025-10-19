using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class RemovedUnusedPropertiesFromWorkshop : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Sessions_Workshops",
                table: "Sessions");

            migrationBuilder.DropColumn(
                name: "EndDate",
                table: "Workshops");

            migrationBuilder.DropColumn(
                name: "MemberPrice",
                table: "Workshops");

            migrationBuilder.RenameColumn(
                name: "StartDate",
                table: "Workshops",
                newName: "Date");

            migrationBuilder.AddForeignKey(
                name: "FK_Sessions_Workshops_WorkshopID",
                table: "Sessions",
                column: "WorkshopID",
                principalTable: "Workshops",
                principalColumn: "WorkshopID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Sessions_Workshops_WorkshopID",
                table: "Sessions");

            migrationBuilder.RenameColumn(
                name: "Date",
                table: "Workshops",
                newName: "StartDate");

            migrationBuilder.AddColumn<DateTime>(
                name: "EndDate",
                table: "Workshops",
                type: "datetime",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "MemberPrice",
                table: "Workshops",
                type: "decimal(18,2)",
                nullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Sessions_Workshops",
                table: "Sessions",
                column: "WorkshopID",
                principalTable: "Workshops",
                principalColumn: "WorkshopID");
        }
    }
}
