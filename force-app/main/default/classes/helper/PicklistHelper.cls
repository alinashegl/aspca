/*
 * Created by barne on 4/15/2021.
 */

global with sharing class PicklistHelper {

    public class PicklistWrapper {
        public String value {get;set;}
        public Boolean isSelected {get;set;}

        public PicklistWrapper(String value, Boolean isSelected) {
            this.value = value;
            this.isSelected = isSelected;
        }
    }

    List<PicklistWrapper> picklistValues{get;set;}

    public List<PicklistWrapper> getPicklistValues(List<PicklistEntry> picklistEntries) {
        picklistValues = new List<PicklistWrapper>();
        List<PicklistEntry> entries = picklistEntries;

        for( Schema.PicklistEntry f : entries)
        {
            picklistValues.add(new PicklistWrapper(f.getLabel(), false));
        }
        return picklistValues;
    }

}