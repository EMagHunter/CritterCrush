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
    // return datatype for HTTP call returning more than one variable
    struct ReportCountResult
    {
        public int count { get; set; }
        public int score { get; set; }
        public ReportCountResult(int count, int score)
        {
            this.count = count;
            this.score = score;
        }
    }

    [Route("api/[controller]")]
    [ApiController]
    public class ReportsController : ControllerBase
    {
        private readonly CritterCrushAPIDBContext _context;
        public static readonly int MAX_IMAGE_SIZE = 10485760; // 10 MB
        public static readonly string IMAGE_PATH = @"C:\crittercrush_images\";

        public ReportsController(CritterCrushAPIDBContext context)
        {
            _context = context;
        }

        // GET: api/Reports
        // Parameters are optional, used to filter which reports are returned
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

        // GET: api/Reports/count
        // Count number of reports & score per user. Optional param to filter by species
        [HttpGet("count")]
        public async Task<ActionResult<Response>> GetReportCount(int userid, int speciesid = 0)
        {
            IQueryable<Report> query = (from r in _context.Reports where (r.UserID == userid) && (speciesid == 0 || r.SpeciesID == speciesid) select r);
            List<Report> reports = await query.ToListAsync<Report>();
            int score = 0;
            foreach (Report report in reports)
            {
                if (!report.ScoreValid)
                    continue;
                // Cap number of critters to 5; the image detect gets wonky when there's more
                int count = report.NumberSpecimens > 5 ? 5 : report.NumberSpecimens;
                int threat = 0;
                // Pre-set "threat level" used for scoring.
                switch (report.SpeciesID)
                {
                    case 1:
                        threat = 2;
                        break;
                    case 2:
                        threat = 3;
                        break;
                    case 3:
                        threat = 3;
                        break;
                    case 4:
                        threat = 1;
                        break;
                    default:
                        break;
                }
                score += threat * 100 + (count * threat * 10);
            }
            return new ResponseData<ReportCountResult>(new ReportCountResult(reports.Count, score));
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

        // GET: api/Reports/image/4982737424.jpg
        // Pulls images from IMAGEPATH.
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
        // Post a report. Optional "imagerectoken" param is used to verify if a user is actually submitting a report after checking it with image rec. Used for scoring
        [HttpPost]
        public async Task<ActionResult<Response>> SubmitReport([FromForm] int speciesid, [FromForm] int numspecimens, [FromForm] double latitude, [FromForm] double longitude, [FromForm] long reportdate, [FromForm] bool scorevalid = false)
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
            //read image file into variable, then save it to IMAGEPATH
            byte[] imgFile = new byte[MAX_IMAGE_SIZE];
            img.OpenReadStream().Read(imgFile);
            string imagename = getRandomImageName();
            string imagepath = IMAGE_PATH + imagename;
            System.IO.File.WriteAllBytes(imagepath, imgFile);
            //add in the rest of report's details then save
            Report r = new Report();
            r.UserID = u.UserID;
            r.SpeciesID = speciesid;
            r.NumberSpecimens = numspecimens;
            r.Latitude = latitude;
            r.Longitude = longitude;
            r.ReportDate = DateTimeOffset.FromUnixTimeSeconds(reportdate).DateTime;
            r.Image = imagename;
            r.ScoreValid = scorevalid;

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
        // ---------------------- HELPER FUNCTIONS -----------------------------

        // Generate a random image name and make sure it's not conflicting with anything else.
        // Just run the function again if there's a conflict. Would be better to modify the string with a +1, looping back to 0000000001
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
            return  _context.AuthTokens.FirstOrDefault(t => t.UserID == UserID);
            //return token;
        }

        //Pulls the User object from an auth token string.
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
        // Check if image recongition returned the same values the user submitted with their report.
        // Rudimentary anti-cheat. Could be better
        private bool IsImageRecValid(string token, int speciesid, int count)
        {
            return _context.ImageRecTokens.Any(e => e.Token == token && e.SpeciesID == speciesid && e.NumberSpecimens == count);
        }
        private async Task RemoveImageRecToken(string token)
        {
            ImageRecToken t = _context.ImageRecTokens.FirstOrDefault(t => t.Token == token);
            if (t != null)
            {
                _context.ImageRecTokens.Remove(t);
                await _context.SaveChangesAsync();
            }
        }
        private bool ReportExists(int id)
        {
            return _context.Reports.Any(e => e.ReportId == id);
        }
    }
}
