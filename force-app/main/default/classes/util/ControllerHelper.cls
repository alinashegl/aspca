/**
 * Created by barne on 4/9/2021.
 */

global with sharing class ControllerHelper {


    global List<SelectOption> getPicklist (List<Schema.PicklistEntry> picklistEntries) {
        List<SelectOption> selectOptions = new List<SelectOption>();
        for (PicklistEntry entry : picklistEntries) {
            selectOptions.add(new SelectOption( entry.getLabel(), entry.getValue()));
        }

        return selectOptions;
    }

    global List<String> getOptions(List<Schema.PicklistEntry> picklistEntries) {
        List<String> options = new List<String>();
        for (PicklistEntry entry : picklistEntries) {
            options.add(entry.getLabel());
        }

        return options;
    }

}