/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class RecordIDCmpController {


    @AuraEnabled
    public static ServiceResponse renderView(String recordId) {
        Treatment_Session__c session = [SELECT Id FROM Treatment_Session__c WHERE Id =: recordId];
        ServiceRequest request = new ServiceRequest();
        if(session != null) {
            request.Name = 'View';
            request.Action = 'handleSession';
            request.withParams('record', recordId);
        }
        ServiceResponse response = SessionProtocolService.processReq(request);
        return response;
    }
}