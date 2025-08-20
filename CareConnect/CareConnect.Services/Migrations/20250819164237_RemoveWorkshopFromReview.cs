using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class RemoveWorkshopFromReview : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
       
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "WorkshopID",
                table: "Reviews",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_WorkshopID",
                table: "Reviews",
                column: "WorkshopID");

            migrationBuilder.AddForeignKey(
                name: "FK_Reviews_Workshops",
                table: "Reviews",
                column: "WorkshopID",
                principalTable: "Workshops",
                principalColumn: "WorkshopID");
        }
    }
}
