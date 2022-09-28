public with sharing class service_Request 
{
    public Map<String, Object> Parameters { get; set; }
    
    public service_Request() 
    {
        Parameters = new Map<String, Object>();
    }
}