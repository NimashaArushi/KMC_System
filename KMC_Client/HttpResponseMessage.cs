namespace KMC_Client
{
    internal class HttpResponseMessage
    {
        public bool IsSuccessStatusCode { get; internal set; }
        public object Content { get; internal set; }
    }
}