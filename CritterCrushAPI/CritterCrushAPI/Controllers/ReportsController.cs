using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CritterCrushAPI.Models;
using System.Composition;
using System.Text;
using System.Drawing;
using NuGet.Protocol;

namespace CritterCrushAPI.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class ReportsController : ControllerBase
    {
        private readonly CritterCrushAPIDBContext _context;
        private readonly int MAX_IMAGE_SIZE = 10485760; // 10 MB

        public ReportsController(CritterCrushAPIDBContext context)
        {
            _context = context;
        }

        // GET: api/Reports
        [HttpGet]
        public async Task<ActionResult<Response>> GetReports()
        {
            return new ResponseData<List<Report>>(await _context.Reports.ToListAsync());
        }

        // GET: api/Reports/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Report>> GetReport(int id)
        {
            var report = await _context.Reports.FindAsync(id);

            if (report == null)
            {
                return NotFound();
            }

            return report;
        }

        [HttpPost]
        public async Task<ActionResult<Response>> SubmitReport(int userid, int speciesid, int numspecimens, double latitude, double longitude, long reportdate)
        {
            var h = Request.Headers;
            if (!h.ContainsKey("Authorization"))
            {
                return new ResponseError(401, "Authorization header is required");
            }
            if (!VerifyTokenForUser(userid, h.Authorization.ToString()))
            {
                return new ResponseError(401, "Auth token not valid");
            }
            IFormFile img = Request.Form.Files.GetFile("reportImage");
            if (img == null)
            {
                return new ResponseError(400, "Image must be attached");
            } else if (img.Length > MAX_IMAGE_SIZE)
            {
                return new ResponseError(400, "Image too large");
            }
            byte[] imgFile = new byte[MAX_IMAGE_SIZE];
            img.OpenReadStream().Read(imgFile);
            Console.WriteLine(Encoding.Default.GetString(imgFile));
            //Console.Write(Request.Form.Files.GetFile("reportImage"));
            Report r = new Report();
            r.UserID = userid;
            r.SpeciesID = speciesid;
            r.NumberSpecimens = numspecimens;
            r.Latitude = latitude;
            r.Longitude = longitude;
            r.ReportDate = DateTimeOffset.FromUnixTimeSeconds(reportdate).DateTime;
            _context.Reports.Add(r);
            await _context.SaveChangesAsync();
            return new ResponseData<Report>(r);
        }

        // PUT: api/Reports/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
/*
        [HttpPut("{id}")]
        public async Task<IActionResult> PutReport(int id, Report report)
        {
            if (id != report.ReportId)
            {
                return BadRequest();
            }

            _context.Entry(report).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ReportExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // DELETE: api/Reports/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReport(int id)
        {
            var report = await _context.Reports.FindAsync(id);
            if (report == null)
            {
                return NotFound();
            }

            _context.Reports.Remove(report);
            await _context.SaveChangesAsync();

            return NoContent();
        }*/

        private AuthToken GetTokenForUser(int UserID)
        {
            IQueryable<AuthToken> query = (from t in _context.AuthTokens where t.UserID == UserID select t);
            AuthToken token = query.Count() == 0 ? null : query.First<AuthToken>();
            return token;
        }
        private bool VerifyTokenForUser(int UserID, string token)
        {
            AuthToken t = GetTokenForUser(UserID);
            if (t == null)
            {
                return false;
            }
            return t.Token == token;
        }
        private bool ReportExists(int id)
        {
            return _context.Reports.Any(e => e.ReportId == id);
        }
    }
}
