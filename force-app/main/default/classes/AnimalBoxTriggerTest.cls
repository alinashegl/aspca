@isTest
public class AnimalBoxTriggerTest {
    @isTest static void animalTest() {
        Case testCase = new Case();
        insert testCase;
        
        Animal__c animal = new Animal__c();
        animal.Animal_Name__c = 'Train';
        animal.Type_of_Animal__c = 'Cat';
        animal.Color__c = 'Black';
        animal.Case__c = testCase.ID;
        insert animal;
    }
}