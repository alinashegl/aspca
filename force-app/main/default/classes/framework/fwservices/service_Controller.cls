public with sharing class service_Controller 
{
    public static service_Response process(Services serviceName, service_Request request)
    {
        service_Response response = new service_Response();
        String realServiceName = 'service_' + serviceName;

        try
        {
            service_Base service = (service_Base) Type.forName(realServiceName).newInstance();
            service.process(request, response);
        }
        catch (Exception ex)
        {
            response.Errors.add(ex.getMessage());
            System.debug('@@@ ERROR: ' + ex);
        }
        
        return response;
    }
}