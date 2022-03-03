/**
 * Created by barne on 4/9/2021.
 */

public with sharing class service_Animal extends service_Base {
    public override void process(service_Request request, service_Response response) {
        switch on (String) request.Parameters.get('action') {
            when 'updateAnimal' {
                updateAnimal(request, response);
            }
            when 'afterUpdate' {
                afterUpdate(request, response);
            }
        }
    }

    public void updateAnimal(service_Request request, service_Response response) {
        List<Animal__c> animals = (List<Animal__c>) request.Parameters.get('animals');
        List<Animal__c> animalToUpdate = new List<Animal__c>();
    }

    public void afterUpdate(service_Request request, service_Response response) {
        List<Animal__c> oldAnimals = (List<Animal__c>) request.Parameters.get('oldAnimals');
        List<Animal__c> newAnimals = (List<Animal__c>) request.Parameters.get('newAnimals');

    }
}