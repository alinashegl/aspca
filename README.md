#Frameworks
Documentation on Frameworks built into this Package
## CQ-Lite

NEW Framework to streamline Request-Response and Trigger handling. Will Deprecate all other Framework files
##FQ Data Access Layer
Provides access to Tooling API

## Services
Allows for Request-Response pattern design in APEX. Create .cls that extends service_Base

EXAMPLE
```apex
public with sharing class service_Contact extends service_Base {
    public override void Process(service_Request request, service_Response response) {
        switch on (String) request.Parameters.get('action') {
            when 'methodOne' {
                methodOne(request, response);
            }
        }
    }
    
    public void methodOne(service_Request request, service_Response response) {
        String id = (String) request.Parameters.get('recordId');
        dao_Contact daoContact = new dao_Contact();
        Contact c = daoContact.findOne(recordId);
        System.debug(c);
        
        //DO LOGIC HERE
        //WHEN LOGIC IS COMPLETE ADD NEW RECORDS TO RESPONSE
        
        response.Parameters.put('item', c);
    }
}
```
##Trigger
Allows for Triggers to be executed by Services class

EXAMPLE
```apex
public with sharing class trigger_Contact extends trigger_Domain {
    public override void beforeInsert(List<SObject> newRecords) {
        service_Request request = new service_Request();
        request.Parameters.put('contacts', newRecords);
        request.Parameters.put('action', 'beforeInsert');
        service_Response response = service_Controller.process(Services.Contact, request);
    }
    
    public override void afterUpdate(List<SObject> newRecords, List<SObject> oldRecords) {
        service_Request request = new service_Request();
        request.Parameters.put('newContacts' , newRecords);
        request.Parameters.put('oldContacts' , oldRecords);
        request.Parameters.put('action' , 'afterUpdate');
        service_Response response = service_Controller.process(Services.Contact, request);
    }
}
```
