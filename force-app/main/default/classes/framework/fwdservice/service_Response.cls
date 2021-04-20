public with sharing class service_Response 
{
    public Map<String, Object> Parameters { get; set; }
    public Set<String> Errors { get; set; }
    
    public service_Response() 
    {
        Parameters = new Map<String, Object>();
        Errors = new Set<String>();
    }
}