namespace CritterCrushAPI.Models
{
    public class AuthToken
    {
        public int AuthTokenId { get; set; }
        public int UserID { get; set; }
        public string Token { get; set; }
        public DateTime IssuedOn { get; set; }
        public bool IsValid { get; set; }

    }
}
