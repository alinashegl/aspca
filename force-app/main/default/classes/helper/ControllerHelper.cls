/*
 * Created by barne on 4/9/2021.
 */

global with sharing class ControllerHelper {
    dao_Animal daoAnimal = new dao_Animal();


    global List<SelectOption> getPicklist (List<Schema.PicklistEntry> picklistEntries) {
        List<SelectOption> selectOptions = new List<SelectOption>();
        for (PicklistEntry entry : picklistEntries) {
            selectOptions.add(new SelectOption (entry.getValue(), entry.getLabel(), true));
            System.debug('#### Picklist Value' + entry.value);
            System.debug('#### Picklist Label ' + entry.getLabel());
            System.debug('#### Picklist isActive ' + entry.isActive());

        }
        return selectOptions;
    }

    global List<String> getOptions(List<Schema.PicklistEntry> picklistEntries) {
        List<String> options = new List<String>();
        for (PicklistEntry entry : picklistEntries) {
            options.add(entry.getValue());
        }

        return options;
    }

    global List<PicklistEntry> getEntries(DescribeFieldResult fieldResult) {
        List<PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

        return picklistEntries;
    }

}