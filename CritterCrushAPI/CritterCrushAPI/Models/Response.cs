namespace CritterCrushAPI.Models
{
    // Classes used for standardization of API output
    // Known bug: HTTP return codes are all 200 regardless of Response type used
    
    public class Response
    {
        public int status {get; set;}
    }

    public class ResponseError : Response
    {
        public string title { get; set; }
        public ResponseError(int code, string msg)
        {
            status = code;
            title = msg;
        }
    }

    public class ResponseData<T> : Response
    {
        public T data { get; set; }
        public ResponseData(T d)
        {
            status = 200;
            data = d;
        }
    }

    public class ResponseNoContent : Response
    {
        public string title { get; set; }
        public ResponseNoContent()
        {
            status = 204;
            title = "No Content";
        }
    }
}
