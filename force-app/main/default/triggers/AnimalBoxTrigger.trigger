trigger AnimalBoxTrigger on Animal__c (after insert) {
    Animal__c animal = Trigger.new[0];
    ID animalID = animal.ID;
    BoxHandler.createFolderFuture(animalID);
}