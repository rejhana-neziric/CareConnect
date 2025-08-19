using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CareConnect.Services.Migrations
{
    /// <inheritdoc />
    public partial class AddChildIdToParticipant : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ChildId",
                table: "Participants",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Participants_ChildId",
                table: "Participants",
                column: "ChildId");

            migrationBuilder.AddForeignKey(
                name: "FK_Participants_Children_ChildId",
                table: "Participants",
                column: "ChildId",
                principalTable: "Children",
                principalColumn: "ChildID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Participants_Children_ChildId",
                table: "Participants");

            migrationBuilder.DropIndex(
                name: "IX_Participants_ChildId",
                table: "Participants");

            migrationBuilder.DropColumn(
                name: "ChildId",
                table: "Participants");
        }
    }
}
