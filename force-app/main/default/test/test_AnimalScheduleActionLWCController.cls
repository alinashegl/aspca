@isTest
private class test_AnimalScheduleActionLWCController {
    @isTest 
    static void recreateTasks(){
        Animal__c anim = TestDataFactory.createAnimal();
        test.startTest();
            //no need to test functionality here becuase it's all tested through other classes
            String response = AnimalScheduleQuickActionLWCController.recreateTasks(anim.Id, null, null);
        test.stopTest();

        System.assertEquals('success', response);
    }

    @isTest 
    static void recreateTasksNoAnimalId(){
        String message;
        test.startTest();
            try{
                String response = AnimalScheduleQuickActionLWCController.recreateTasks(null, null, null);
            } catch (AuraHandledException e){
                message = e.getMessage();
            }

        test.stopTest();
        System.debug('message: ' + message);
        System.assert(message.contains('Animal Id not found'));
    }
}
