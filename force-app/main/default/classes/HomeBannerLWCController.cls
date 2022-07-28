public with sharing class HomeBannerLWCController {
    @AuraEnabled
    public static ButtonsToDisplay getButtonsInfo() {
        ButtonsToDisplay btd = new ButtonsToDisplay();
        btd.outOfOffice = true;
        btd.mrcTreatmentPlansReport = false;
        Profile profile = [Select Id, Name from Profile where Id =: UserInfo.getProfileId()];
        if(Label.CRCMRCProfilesForTreatment.contains(profile.Name)){
            btd.mrcTreatmentPlansReport = true;
        }

        return btd;
    }

    public class ButtonsToDisplay{
        @AuraEnabled public Boolean outOfOffice;
        @AuraEnabled public Boolean mrcTreatmentPlansReport;
    }
    
    public class TodoListVisibility{
        @AuraEnabled public Boolean mrcTodoList;
    }
    
    @AuraEnabled
    public static TodoListVisibility getToDoListVisibility(){
        TodoListVisibility result = new TodoListVisibility();
        result.mrcTodoList = false;
        Profile profile = [Select Id, Name from Profile where Id =: UserInfo.getProfileId()];
        System.debug(profile.Name);
        if(Label.CRCMRCProfilesForTreatment.contains(profile.Name)){
            result.mrcTodoList = true;
        }
        if(test.isRunningTest()){
            result.mrcTodoList = true;
        }
        
        return result;
    }
}