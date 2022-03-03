public with sharing class MultiPickToCheckboxGroupController {
    @AuraEnabled
    public static List<PicklistOption> getPicklistValues(String objectName, String fieldName) {
        Map<String,SObjectType> gd = Schema.getGlobalDescribe();
        SObjectType sobjType = gd.get(objectName);
        List<PicklistOption> picklistOptions = new List<PicklistOption>();
        List<PicklistEntry> picklistValues = sobjType.getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues();
        for (PicklistEntry p : picklistValues) {
            picklistOptions.add(new PicklistOption(p.getLabel(), p.getValue()));
        }
        return picklistOptions;
    }

    public class PicklistOption {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }
        public PicklistOption() {}
        public PicklistOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}