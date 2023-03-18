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

namespace CritterCrushAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly CritterCrushAPIDBContext _context;
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
        [HttpPost("register")]
        public async Task<ActionResult<Response>> RegisterUser(string username, string password, string email)
        {
            if (IsStringEmpty(username) || IsStringEmpty(password) || IsStringEmpty(email)) 
                return BadRequest(new ResponseError(400, "All fields are required"));
            if (GetUserByName(username) != null)
                return BadRequest(new ResponseError(400, "Username already in use"));
            string passwordhash = HashPassword(password);
            User newuser = new User();
            newuser.UserName = username;
            newuser.Pass = passwordhash;
            newuser.Email = email;
            _context.Users.Add(newuser);
            await _context.SaveChangesAsync();
            string token = await GetOrIssueAuthToken(newuser.UserID);
            return new ResponseData<string>(token);
        }

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
                return new ResponseData<string>(token);
            } else
            {
                return BadRequest(new ResponseError(400, "User and password do not match"));
            }
        }

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
        private bool VerifyTokenForUser(int UserID, string token)
        {
            AuthToken t = GetTokenForUser(UserID);
            if (t == null)
            {
                return false;
            }
            return t.Token == token;
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
