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
        public async Task<ActionResult<string>> RegisterUser(string username, string password, string email)
        {
            if (IsStringEmpty(username) || IsStringEmpty(password) || IsStringEmpty(email)) 
                return BadRequest("Fields cannot be empty");
            string passwordhash = HashPassword(password);
            User newuser = new User();
            newuser.UserName = username;
            newuser.Pass = passwordhash;
            newuser.Email = email;
            _context.Users.Add(newuser);
            await _context.SaveChangesAsync();
            return "Success";
        }

        [HttpGet("login")]
        public async Task<ActionResult<string>> TryLogin(string username, string password)
        {
            if (IsStringEmpty(username) || IsStringEmpty(password)) {
                return BadRequest("Fields cannot be empty");
            }
            IQueryable<User> query = (from u in _context.Users where u.UserName == username select u);
            User user = query.Count() == 0 ? null : query.First<User>();
            if (user == null)
            {
                return BadRequest("DEBUG - User not found");
            }
            string passwordhash = HashPassword(password);
            if (passwordhash == user.Pass)
            {
                return "Success"; //TODO
            } else
            {
                return BadRequest("DEBUG - Password does not match");
            }

        }

        // GET: api/Users
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }

        // GET: api/Users/5
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

        // PUT: api/Users/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(int id, User user)
        {
            if (id != user.UserID)
            {
                return BadRequest();
            }

            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
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

        // POST: api/Users
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<User>> PostUser(User user)
        {
            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUser", new { id = user.UserID }, user);
        }

        // DELETE: api/Users/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UserExists(int id)
        {
            return _context.Users.Any(e => e.UserID == id);
        }
        private bool UserNameExists(string name)
        {
            return _context.Users.Any(e => e.UserName == name);
        }
        private bool IsStringEmpty(string value)
        {
            return string.IsNullOrWhiteSpace(value);
        }
    }
}
