public with sharing class AnimalPictureUploaderController {
    private Id animalId;
 
    public AnimalPictureUploaderController(){
        animalId = ApexPages.currentPage().getParameters().get('cid');
        system.debug('animalId ----'+animalId);
    }
 
    public PageReference initialise(){
        List<Attachment> listA = [select a.Id from Attachment a
                                    where // a.createdById =:UserInfo.getUserId() and
                                    a.parentId=:animalId order by a.createdDate desc limit 1];                                                    
        if (listA.size()>0){
            Id attachmentId = listA[0].Id;
             
            Animal__c animalObj = [select Id from Animal__c where Id=:animalId];
            animalObj.Photo_Document_Id__c = attachmentId;
            update animalObj;
        }
        return new PageReference('/'+animalId);       
    }
}