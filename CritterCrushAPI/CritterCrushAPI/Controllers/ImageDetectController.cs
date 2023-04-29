using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CritterCrushAPI.Models;
using System.Diagnostics;

struct ImageDetectResult
{
    public int speciesid { get; set; }
    public int count { get; set; }
    public ImageDetectResult(int speciesid, int count)
    {
        this.speciesid = speciesid;
        this.count = count;
    }
}

namespace CritterCrushAPI.Controllers
{
    [Route("api/critterdetect")]
    [ApiController]
    public class ImageDetectController : ControllerBase
    {
        private readonly CritterCrushAPIDBContext _context;
        private readonly int MAX_IMAGE_SIZE = 10485760; // 10 MB
        private readonly string IMAGE_PATH = @"C:\crittercrush_images\";
        private readonly Regex rx = new Regex("\\s(?<count>\\d)\\s(?<species>[^,]*)", RegexOptions.Compiled);
        public ImageDetectController(CritterCrushAPIDBContext context)
        {
            _context = context;
        }
        [HttpPost]
        public async Task<ActionResult<Response>> GetImageResult()
        {
            if (!Request.HasFormContentType)
            {
                return new ResponseError(400, "Invalid content type");
            }

            IFormFile img = Request.Form.Files.GetFile("reportImage");
            if (img == null)
            {
                return new ResponseError(400, "Image must be attached");
            }
            else if (img.Length > MAX_IMAGE_SIZE)
            {
                return new ResponseError(400, "Image too large");
            }

            byte[] imgFile = new byte[MAX_IMAGE_SIZE];
            img.OpenReadStream().Read(imgFile);
            string imagepath = IMAGE_PATH + "temp.jpg";
            System.IO.File.WriteAllBytes(imagepath, imgFile);
            ImageDetectResult? result = await runimagedetect();
            if (result == null)
            {
                return new ResponseNoContent();
            } 
            else
            {
                return new ResponseData<ImageDetectResult>( (ImageDetectResult) result);
            }
 
        }

        private async Task<ImageDetectResult?> runimagedetect()
        {
            ProcessStartInfo start = new ProcessStartInfo();
            start.FileName = "python\\python.exe";
            start.Arguments = "detect.py --weights runs\\train\\results_3\\weights\\best.pt --source "+IMAGE_PATH+"temp.jpg";
            start.WorkingDirectory = "ComputerVision\\";
            start.UseShellExecute = false;
            start.CreateNoWindow = true;
            start.RedirectStandardOutput = true;
            start.RedirectStandardError = true;
            using (Process process = Process.Start(start))
            {
                using (StreamReader reader = process.StandardOutput)
                {
                    string result = reader.ReadToEnd();
                    Console.WriteLine(process.StandardError.ReadToEnd());
                    Console.WriteLine(result);
                    if (result.Length > 45)
                    {

                        string resultstring = result.Substring(45, result.Length-45-4);
                        Console.WriteLine(resultstring);
                        MatchCollection matches = rx.Matches(resultstring);
                        if (matches.Count > 0)
                        {
                            Match m = matches.First();
                            int speciesid = 0;
                            switch (m.Groups["species"].Value)
                            {
                                case "spotted lanternfly":
                                    speciesid = 1;
                                    break;
                                case "spotted lanternflys":
                                    speciesid = 1;
                                    break;
                                case "Asian Longhorned beetle":
                                    speciesid = 2;
                                    break;
                                case "Asian Longhorned beetles":
                                    speciesid = 2;
                                    break;
                                case "emerald ash borer":
                                    speciesid = 3;
                                    break;
                                case "emerald ash borers":
                                    speciesid = 3;
                                    break;
                                case "spongy moth":
                                    speciesid = 4;
                                    break;
                                case "spongy moths":
                                    speciesid = 4;
                                    break;
                                default:
                                    break;
                            }
                            if (speciesid == 0)
                            {
                                return null;
                            }
                            return new ImageDetectResult(speciesid, Int32.Parse(m.Groups["count"].Value));
                        } 
                        else
                        {
                            return null;
                        }
                    } else
                    {
                        return null;
                    }
                }
            }
        }
    }
}
