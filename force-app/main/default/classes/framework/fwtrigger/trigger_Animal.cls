/*
 * Created by barne on 4/9/2021.
 */

public with sharing class trigger_Animal extends trigger_Domain {

    public override void beforeInsert(List<SObject> newRecords) {
        service_Request request = new service_Request();
        request.Parameters.put('animals' , newRecords);
        request.Parameters.put('action', 'updateAnimal');
        service_Response response = service_Controller.process(Services.Animal, request);
    }

    public override void afterUpdate(List<SObject> newRecords, List<SObject> oldRecords)
    {
        service_Request request = new service_Request();
        request.Parameters.put('newAnimals' , newRecords);
        request.Parameters.put('oldAnimals' , oldRecords);
        request.Parameters.put('action' , 'afterUpdateAnimal');
        service_Response response = service_Controller.process(Services.Animal, request);
    }

}