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

    public void afterUpdate (service_Request request, service_Response response) {
        List<Animal__c> oldAnimals = (List<Animal__c>) request.Parameters.get('oldAnimals');
        List<Animal__c> newAnimals = (List<Animal__c>) request.Parameters.get('newAnimals');

        List<Animal__c> toUpdate = new List<Animal__c>();

        dao_Animal daoAnimal = new dao_Animal();
        dao_EmailTemplate daoEmailTemplate = new dao_EmailTemplate();
        dao_Contact daoContact = new dao_Contact();
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

        for (Animal__c oAnimal : oldAnimals) {
            Contact oCaseWorker = daoContact.findOne(oAnimal.Behavior_Case_Worker__c);

            for (Animal__c nAnimal : newAnimals) {
                Contact nCaseWorker = daoContact.findOne(oAnimal.Behavior_Case_Worker__c);

                    if (oCaseWorker != nCaseWorker) {
                        EmailTemplate emailTemplate = daoEmailTemplate.findOneByDeveloperName('Behavior_CaseWorker_Assignmen_Email');

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                        mail.setTemplateId(emailTemplate.Id);
                        mail.setSubject(emailTemplate.Subject);
                        mail.setTargetObjectId(nCaseWorker.Id);
                        mail.setWhatId(oAnimal.Id);
                        mail.setSaveAsActivity(false);
                        mail.setUseSignature(false);

                        messages.add(mail);
                    }
            }
            toUpdate.add(newAnimals);
        }
        response.Parameters.put('list', toUpdate);

        afterUpdate(
                request,
                response
        );
    }