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
using System.IO;
using System.Diagnostics;

namespace CritterCrushAPI.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class ReportsController : ControllerBase
    {
        private readonly CritterCrushAPIDBContext _context;
        private readonly int MAX_IMAGE_SIZE = 10485760; // 10 MB
        private readonly string IMAGE_PATH = @"C:\crittercrush_images\";

        public ReportsController(CritterCrushAPIDBContext context)
        {
            _context = context;
        }

        // GET: api/Reports
        [HttpGet]
        public async Task<ActionResult<Response>> GetReports(int userid = 0, int speciesid = 0, int recentreports = -1)
        {
            IQueryable<Report> query = (from r in _context.Reports where ((userid == 0 || r.UserID == userid) && (speciesid == 0 || r.SpeciesID == speciesid)) orderby r.ReportDate descending select r);
            List<Report> reports = await query.ToListAsync<Report>();
            if (recentreports > 0)
            {
                List<Report> newreports = new List<Report>();
                for (int i = 0; i < recentreports && i < reports.Count(); i++)
                {
                    newreports.Add(reports.ElementAt(i));
                }
                reports = newreports;
            }
            return new ResponseData<List<Report>>(reports);
        }

        // GET: api/Reports
        [HttpGet("count")]
        public async Task<ActionResult<Response>> GetReportCount(int userid, int speciesid = 0)
        {
            IQueryable<Report> query = (from r in _context.Reports where (r.UserID == userid) && (speciesid == 0 || r.SpeciesID == speciesid) select r);
            List<Report> reports = await query.ToListAsync<Report>();
            return new ResponseData<int>(reports.Count);
        }

        // GET: api/Reports/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Response>> GetReport(int id)
        {
            var report = await _context.Reports.FindAsync(id);

            if (report == null)
            {
                return NotFound();
            }

            return new ResponseData<Report>(report);
        }

        // GET: api/Reports/image/{imagename}
        [HttpGet("image/{imagename}")]
        public IActionResult GetReportImage(string imagename)
        {
            Console.WriteLine(IMAGE_PATH + imagename);
            if (!System.IO.File.Exists(IMAGE_PATH + imagename))
            {
                return NotFound();
            }
            Byte[] b = System.IO.File.ReadAllBytes(IMAGE_PATH + imagename);
            return File(b, "image/jpeg");
        }

        // POST: api/Reports/
        [HttpPost]
        public async Task<ActionResult<Response>> SubmitReport([FromForm] int speciesid, [FromForm] int numspecimens, [FromForm] double latitude, [FromForm] double longitude, [FromForm] long reportdate)
        {
            var h = Request.Headers;
            if (!h.ContainsKey("Authorization"))
            {
                return new ResponseError(401, "Authorization header is required");
            }
            string token = h.Authorization.ToString();
            User u = GetUserFromToken(token);
            if (u == null || !VerifyTokenForUser(u.UserID, token))
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
            string imagename = getRandomImageName();
            string imagepath = IMAGE_PATH + imagename;
            System.IO.File.WriteAllBytes(imagepath, imgFile);
            //Console.WriteLine(Encoding.Default.GetString(imgFile));
            //Console.Write(Request.Form.Files.GetFile("reportImage"));
            Report r = new Report();
            r.UserID = u.UserID;
            r.SpeciesID = speciesid;
            r.NumberSpecimens = numspecimens;
            r.Latitude = latitude;
            r.Longitude = longitude;
            r.ReportDate = DateTimeOffset.FromUnixTimeSeconds(reportdate).DateTime;
            r.Image = imagename;
            _context.Reports.Add(r);
            await _context.SaveChangesAsync();
            return new ResponseData<Report>(r);
        }

        //DELETE /api/reports/{id}
        [HttpDelete("{id}")]
        public async Task<ActionResult<Response>> DeleteReport(int id)
        {
            var h = Request.Headers;
            if (!h.ContainsKey("Authorization"))
            {
                return new ResponseError(401, "Authorization header is required");
            }
            Report r = await _context.Reports.FindAsync(id);
            if (r == null)
            {
                return new ResponseError(404, "Report does not exist");
            }
            if (!VerifyTokenForUser(r.UserID, h.Authorization.ToString()))
            {
                return new ResponseError(401, "Auth token not valid");
            }
            _context.Reports.Remove(r);
            await _context.SaveChangesAsync();
            return new ResponseNoContent();
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
        private string getRandomImageName()
        {
            var random = new Random();
            string s = "";
            for (int i = 0; i < 10; i++)
            {
                s = s + (random.Next(0, 10).ToString());
            }
            s = s + ".jpg";
            if (System.IO.File.Exists(IMAGE_PATH+s)) {
                return getRandomImageName();
            }
            return s;
        }
        private AuthToken GetTokenForUser(int UserID)
        {
            IQueryable<AuthToken> query = (from t in _context.AuthTokens where t.UserID == UserID select t);
            AuthToken token = query.Count() == 0 ? null : query.First<AuthToken>();
            return token;
        }
        private User GetUserFromToken(string token)
        {
            AuthToken tkn = _context.AuthTokens.FirstOrDefault(t => t.Token == token);
            if (tkn == null)
            {
                return null;
            }
            User usr = _context.Users.FirstOrDefault(u => u.UserID == tkn.UserID);
            return usr;
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
