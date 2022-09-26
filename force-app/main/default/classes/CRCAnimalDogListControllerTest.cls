@isTest
public class CRCAnimalDogListControllerTest {

    @testSetup
    static void setupData(){
        List<Animal__c> animals = new List<Animal__c>();
        List<Play_Pause__c> playPauses = new List<Play_Pause__c>();
        List<Treatment_Plan__c> planList = new List<Treatment_Plan__c>();
        for(Integer i = 1; i <= 5; i++){
            Animal__c a = TestDataFactory.createAnimalWithName('anm' + i);
            animals.add(a);
            playPauses.addAll(TestDataFactory.createPlayPauses(a));
            
            Treatment_Plan__c plan = new Treatment_Plan__c(
                IsActive__c = true, 
                Description__c = 'Test', 
                Animal__c = a.Id, 
                Problem_Behavior__c = 'Fear of People - Mild'
            );
            planList.add(plan);
        }
        
        for(Play_Pause__c play : playPauses){
            play.End_Play_Pause__c = false;
        }
        update playPauses;
        
        insert planList;
    }
    
    @isTest
    static void testRecords(){
        List<Treatment_Plan__c> objs = CRCAnimalDogListController.getRecords();
        System.assertNotEquals(objs, null);
        String result = CRCAnimalDogListController.saveRecords(JSON.serialize(objs));
        System.assertEquals('success', result);
        
    }
}