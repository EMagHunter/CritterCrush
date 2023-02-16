namespace CritterCrushAPI.Models
{
    public class Report
    {
        public int ReportId { get; set; }
        public DateTime ReportDate { get; set; }
        public int UserID { get; set; }
        public int SpeciesID { get; set; }
    }
}
