using Microsoft.EntityFrameworkCore;
using System.Diagnostics.CodeAnalysis;
using CritterCrushAPI.Models;


namespace CritterCrushAPI.Models
{
    public class CritterCrushAPIDBContext : DbContext
    {
        protected readonly IConfiguration Configuration;

        public CritterCrushAPIDBContext(DbContextOptions<CritterCrushAPIDBContext> options, IConfiguration configuration) : base(options)
        {
            Configuration = configuration;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            var connectionString = Configuration.GetConnectionString("CritterCrushDB");
            options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString));
        }

        public DbSet<Report> Reports { get; set; } = null;
        public DbSet<User> Users { get; set; } = null;
        public DbSet<AuthToken> AuthTokens { get; set; } = null;
        public DbSet<ImageRecToken> ImageRecTokens { get; set; } = null;
    }
}
