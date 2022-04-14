public with sharing class HomeBannerLWCController {
    @AuraEnabled
    public static ButtonsToDisplay getButtonsInfo() {
        ButtonsToDisplay btd = new ButtonsToDisplay();

        btd.outOfOffice = true;
        btd.mrcTreatmentPlansReport = true;

        return btd;
    }

    public class ButtonsToDisplay{
        @AuraEnabled public Boolean outOfOffice;
        @AuraEnabled public Boolean mrcTreatmentPlansReport;
    }
}
