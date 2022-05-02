/*
 *
 * Created by barne on 5/20/2021.
 */

public with sharing class trigger_BehaviorEvaluation extends trigger_Domain{

    public override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        service_Request request = new service_Request();
        request.Parameters.put('oldEvaluations' , oldRecords);
        request.Parameters.put('newEvaluations' , newRecords);
        request.Parameters.put('action' , 'beforeUpdate');
        service_Response response = service_Controller.process(Services.BehaviorEvaluation, request);
    }

}