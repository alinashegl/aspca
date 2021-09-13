/**
 * Created by barne on 5/21/2021.
 */

public with sharing class SObjectFieldMapHelper {

    public static Map<String, Schema.SObjectField> fieldMap(String type) {
        SObjectType sObjectType = Schema.getGlobalDescribe().get(type);
        Map<String, Schema.SObjectField> mFieldsByStrings = sObjectType.getDescribe().fields.getMap();
        return mFieldsByStrings;
    }

    public static Map<String, PicklistEntry> entriesByStrings(DescribeFieldResult result) {
        Map<String, PicklistEntry> entriesByStrings = new Map<String, PicklistEntry>();
        for (PicklistEntry entry : result.getPicklistValues()) {
            entriesByStrings.put(entry.label, entry);
        }
        return entriesByStrings;
    }
}