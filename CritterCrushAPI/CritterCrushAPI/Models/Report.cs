namespace CritterCrushAPI.Models
{
    public class Report
    {
        public int ReportId { get; set; }
        public DateTime ReportDate { get; set; }
        public int UserID { get; set; }
        public int SpeciesID { get; set; }
        public int NumberSpecimens { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public int VerifyTrueCount { get; set; }
        public int VerifyFalseCount { get; set; }

    }
}
