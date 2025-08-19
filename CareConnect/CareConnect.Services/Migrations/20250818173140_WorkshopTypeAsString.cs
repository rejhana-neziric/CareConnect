using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class WorkshopTypeAsString : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // 1. Add new column
            migrationBuilder.AddColumn<string>(
                name: "WorkshopType",
                table: "Workshops",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            // 2. Copy data from old column
            migrationBuilder.Sql(@"
        UPDATE Workshops
        SET WorkshopType = CASE WorkshopTypeID
            WHEN 1 THEN 'Workshop for Parents'
            WHEN 2 THEN 'Workshop for Children'
            ELSE 'Unknown'
        END
    ");

            // 3. Drop foreign key
            migrationBuilder.DropForeignKey(
                name: "FK_Workshops_WorkshopTypes",
                table: "Workshops");

            // 4. Drop old column
            migrationBuilder.DropColumn(
                name: "WorkshopTypeID",
                table: "Workshops");

            // 5. Drop old table if desired
            migrationBuilder.DropTable(
                name: "WorkshopTypes");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                           name: "WorkshopTypeID",
                           table: "Workshops",
                           type: "int",
                           nullable: false,
                           defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "WorkshopTypes",
                columns: table => new
                {
                    WorkshopTypeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "text", nullable: true),
                    ModifiedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WorkshopTypes", x => x.WorkshopTypeID);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Workshops_WorkshopTypeID",
                table: "Workshops",
                column: "WorkshopTypeID");

            migrationBuilder.AddForeignKey(
                name: "FK_Workshops_WorkshopTypes",
                table: "Workshops",
                column: "WorkshopTypeID",
                principalTable: "WorkshopTypes",
                principalColumn: "WorkshopTypeID");
        }
    
    }
}
