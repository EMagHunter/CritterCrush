using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CritterCrushAPI.Models;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using System.Text;
using System.Xml.Linq;
using System.Numerics;
using Microsoft.AspNetCore.Identity;
using MessagePack;

// return datatypes for HTTP calls returning more than one variable
struct UserProfileObj
{
    public int userid { get; set; }
    public string username { get; set; }
    public string email { get; set; }
    public UserProfileObj(int userid, string username, string email)
    {
        this.userid = userid;
        this.username = username;
        this.email = email;
    }
}
struct UserProfileOtherObj
{
    public int userid { get; set; }
    public string username { get; set; }
    public UserProfileOtherObj(int userid, string username)
    {
        this.userid = userid;
        this.username = username;
    }
}
struct UserTokenIDPair
{
    public string token { get; set; }
    public int userid { get; set; }
    public UserTokenIDPair(int userid, string token)
    {
        this.userid = userid;
        this.token = token;
    }
}

namespace CritterCrushAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly CritterCrushAPIDBContext _context;

        // one-way hashing function with hardcoded salt
        private static string HashPassword(string password)
        {
            byte[] salt = Encoding.Default.GetBytes("as8d72nd9g8n2b");
            byte[] hash = KeyDerivation.Pbkdf2(password, salt, KeyDerivationPrf.HMACSHA256, 100, 256);
            return Encoding.Default.GetString(hash);
        }

        public UsersController(CritterCrushAPIDBContext context)
        {
            _context = context;
        }

        // POST: api/users/register
        // username, email, password
        // Registers new user to database. Returns auth token
        [HttpPost("register")]
        public async Task<ActionResult<Response>> RegisterUser(string username, string password, string email)
        {
            if (IsStringEmpty(username) || IsStringEmpty(password) || IsStringEmpty(email)) 
                return BadRequest(new ResponseError(400, "All fields are required"));
            if (GetUserByName(username) != null)
                return BadRequest(new ResponseError(400, "Username already in use"));
            if (EmailInUse(email))
                return BadRequest(new ResponseError(400, "Email already in use"));
            string passwordhash = HashPassword(password);
            User newuser = new User();
            newuser.UserName = username;
            newuser.Pass = passwordhash;
            newuser.Email = email;
            _context.Users.Add(newuser);
            await _context.SaveChangesAsync();
            string token = await GetOrIssueAuthToken(newuser.UserID);

            return new ResponseData<UserTokenIDPair>(new UserTokenIDPair(newuser.UserID, token));
        }

        // GET: api/users/login
        // username, password
        // Returns auth token and userID for user
        [HttpGet("login")]
        public async Task<ActionResult<Response>> TryLogin(string username, string password)
        {
            if (IsStringEmpty(username) || IsStringEmpty(password)) {
                return BadRequest(new ResponseError(400, "All fields are required"));
            }

            User user = GetUserByName(username);

            if (user == null)
            {
                return BadRequest(new ResponseError(400, "User and password do not match"));
            }
            string passwordhash = HashPassword(password);
            if (passwordhash == user.Pass)
            {
                string token = await GetOrIssueAuthToken(user.UserID);
                return new ResponseData<UserTokenIDPair>(new UserTokenIDPair(user.UserID, token));
            } else
            {
                return BadRequest(new ResponseError(400, "User and password do not match"));
            }
        }
        // deprecated: GET /api/users/verifylogin
        // Return whether or not the auth token matches the username supplied
        [HttpGet("verifylogin")]
        public ActionResult<Response> VerifyToken(string username)
        {
            var h = Request.Headers;
            if (!h.ContainsKey("Authorization"))
            {
                return new ResponseError(400, "Authorization header is required");
            }
            string token = h.Authorization.ToString();
            if (IsStringEmpty(username) || IsStringEmpty(token)) {
                return new ResponseError(400, "All fields are required");
            }
            User u = GetUserByName(username);
            if (u == null) {
                return new ResponseError(400, "User not found");
            }
            AuthToken t = GetTokenForUser(u.UserID);
            if (t == null)
            {
                return new ResponseError(400, "User has no auth token");
            }
            return new ResponseData<bool>(VerifyTokenForUser(u.UserID, token));
        }

        // GET /api/users/userprofile
        // optional: userid
        // returns username and userID. If auth token is supplied and matches userid, also returns email
        [HttpGet("userprofile")]
        public ActionResult<Response> GetUserData(int userid = -1)
        {
            var h = Request.Headers;
            string token = null;
            if (h.ContainsKey("Authorization"))
            {
                token = h.Authorization.ToString();
            }
            User u = (userid == -1 && token != null) ? GetUserFromToken(token) : GetUserByID(userid);
            if (u == null)
            {
                return new ResponseError(404, "User not found");
            }
            if (VerifyTokenForUser(u.UserID, token))
            {
                return new ResponseData<UserProfileObj>(new UserProfileObj(u.UserID, u.UserName, u.Email));
            }
            return new ResponseData<UserProfileOtherObj>(new UserProfileOtherObj(u.UserID, u.UserName));

        }

        // PATCH /api/users/userprofile
        // optional: email, password
        // modified email or password for user. Returns new auth token if password is changed.
        [HttpPatch("userprofile")]
        public async Task<ActionResult<Response>> EditUserData(string? email = null, string? password = null)
        {
            var h = Request.Headers;
            if (!h.ContainsKey("Authorization"))
            {
                return new ResponseError(400, "Authorization header is required");
            }
            string token = h.Authorization.ToString();
            if (IsStringEmpty(token))
            {
                return new ResponseError(400, "Authorization header is empty");
            }
            User u = GetUserFromToken(token);
            if (u == null || !VerifyTokenForUser(u.UserID, token))
            {
                return new ResponseError(400, "Auth token not valid");
            }

            if (email != null)
            {
                if (EmailInUse(email))
                    return BadRequest(new ResponseError(400, "Email already in use"));
                u.Email = email;
            }
            if (password != null)
            {
                string passwordhash = HashPassword(password);
                u.Pass = passwordhash;
                await DeleteTokenForUser(u.UserID);
                token = await GetOrIssueAuthToken(u.UserID);
            }
            await _context.SaveChangesAsync();

            
            return password != null ? new ResponseData<string>(token) : new ResponseNoContent();
        }

        // DELETE /api/users/userprofile
        // Delete a user from the database.
        // Does not delete reports. All reports for user are changed to userid 0 (invalid user)
        [HttpDelete("userprofile")]
        public async Task<ActionResult<Response>> DeleteUserData()
        {
            var h = Request.Headers;
            if (!h.ContainsKey("Authorization"))
            {
                return new ResponseError(400, "Authorization header is required");
            }
            string token = h.Authorization.ToString();
            if (IsStringEmpty(token))
            {
                return new ResponseError(400, "Authorization header is empty");
            }
            User u = GetUserFromToken(token);
            if (u == null || !VerifyTokenForUser(u.UserID, token))
            {
                return new ResponseError(400, "Auth token not valid");
            }
            IQueryable<Report> query = (from r in _context.Reports where r.UserID == u.UserID select r);
            List<Report> reports = await query.ToListAsync<Report>();
            foreach (Report r in  reports)
            {
                r.UserID = 0;
            }
            await DeleteTokenForUser(u.UserID);
            _context.Users.Remove(u);
            await _context.SaveChangesAsync();
            return new ResponseNoContent();
        }

        // ------------------------------------------ HELPER FUNCTIONS ------------------------------------

        // Generate an auth token if one doesn't exist. Return existing token otherwise
        private async Task<string> GetOrIssueAuthToken(int UserID)
        {
            AuthToken t = GetTokenForUser(UserID);
            if (t == null)
            {
                return await IssueAuthToken(UserID);
            }
            else
            {
                return t.Token;
            }
        }
        // Generate an auth token for a user
        private async Task<string> IssueAuthToken(int UserID)
        {
            AuthToken newtoken = new AuthToken();
            newtoken.UserID = UserID;
            newtoken.IssuedOn = DateTime.UtcNow;
            newtoken.Token = GenerateRandomToken();
            newtoken.IsValid = true;

            _context.AuthTokens.Add(newtoken);
            await _context.SaveChangesAsync();
            return newtoken.Token;
        }
        // returns a 256-character long randomized string
        // runs again if it matches an existing token
        private string GenerateRandomToken()
        {
            var random = new Random();
            string t = "";
            for (int i = 0; i < 256; i++)
            {
                t = t + (char)((random.Next(0, 2)*32) + random.Next(65, 91));
            }
            if (TokenInUse(t))
            {
                return GenerateRandomToken();
            } else
            {
                return t;
            }
        }

        private bool UserExists(int id)
        {
            return _context.Users.Any(e => e.UserID == id);
        }
        private bool UserNameExists(string name)
        {
            return _context.Users.Any(e => e.UserName == name);
        }
        private bool EmailInUse(string email)
        {
            return _context.Users.Any(e => e.Email == email);
        }
        private User GetUserByID(int id)
        {
            return _context.Users.Find(id);
        }
        private bool TokenInUse(string token)
        {
            return _context.AuthTokens.Any(e => e.Token == token);
        }
        private AuthToken GetTokenForUser(int UserID)
        {
            IQueryable<AuthToken> query = (from t in _context.AuthTokens where t.UserID == UserID select t);
            AuthToken token = query.Count() == 0 ? null : query.First<AuthToken>();
            return token;
        }
        // verify if a token matches a user ID
        private bool VerifyTokenForUser(int UserID, string token)
        {
            AuthToken t = GetTokenForUser(UserID);
            if (t == null)
            {
                return false;
            }
            return t.Token == token;
        }
        private async Task DeleteTokenForUser(int UserID)
        {
            IQueryable<AuthToken> query = (from t in _context.AuthTokens where t.UserID == UserID select t);
            AuthToken token = query.Count() == 0 ? null : query.First<AuthToken>();
            _context.AuthTokens.Remove(token);
            await _context.SaveChangesAsync();
        }
        // retrieves User object from auth token
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
        private User GetUserByName(string username)
        {
            IQueryable<User> query = (from u in _context.Users where u.UserName == username select u);
            User user = query.Count() == 0 ? null : query.First<User>();
            return user;
        }
        private bool IsStringEmpty(string value)
        {
            return string.IsNullOrWhiteSpace(value);
        }
    }
}
