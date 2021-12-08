public with sharing class Util {
    public static id getRecordTypeId(String objAPIName, string developerName){
        Id recTypeId = Schema.getGlobalDescribe().get(objAPIName).getDescribe().getRecordTypeInfosByDeveloperName().get(developerName).getRecordTypeId();

        return recTypeId;
    }
}
