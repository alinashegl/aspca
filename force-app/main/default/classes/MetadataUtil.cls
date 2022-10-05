/**
 * Created by barne on 5/24/2021.
 */

public with sharing class MetadataUtil {

    public static Map<String, Test_Config__mdt> mapOfPicklistAndMetadata() {
        Map<String, Test_Config__mdt> configMap = Test_Config__mdt.getAll();
        Map<String, Test_Config__mdt> nStrings = new Map<String, Test_Config__mdt>();

        for (Test_Config__mdt mConfig : configMap.values()) {
            nStrings.put(mConfig.Picklist_API_Name__c , mConfig);
        }
        //System.debug('$$$ Map of Test Config Metadata ===> ' + nStrings.size());
        return nStrings;
    }

    public static Map<String, Picklist_Description_Config__mdt> mapOfPicklistDescriptions() {
        Map<String, Picklist_Description_Config__mdt> configMap = Picklist_Description_Config__mdt.getAll();
        return configMap;
    }

    public static String commentField(String field) {
        //System.debug('@@@@@@@@@@@@@@@@@@@@Executing Comment Field Method');
        Map<String, Test_Config__mdt> configMap = mapOfPicklistAndMetadata();

        String commentField = '';

        if (configMap.containsKey(field)) {
            Test_Config__mdt testConfig = configMap.get(field);
            //System.debug('@@@ Test Config Found ===> ' + testConfig);
            if (String.isNotEmpty(testConfig.Test_Comment_Field_Name__c)) {
                //System.debug('IS NOT EMPTY');
                commentField = testConfig.Test_Comment_Field_Name__c;
                //System.debug('#### this is a comment field ===> ' + commentField);
            }else {
                //System.debug('NONE FOUND');
            }
        }

        return commentField;
    }


    public static String skipField(String field) {
       // System.debug('Executing Skip Field Method');
        Map<String, Test_Config__mdt> configMap = mapOfPicklistAndMetadata();

        String skipField = '';

        if (configMap.containsKey(field)) {
            Test_Config__mdt testConfig = configMap.get(field);
            //System.debug('@@@ Test Config Found ===> ' + testConfig);
            if (String.isNotEmpty(testConfig.Test_Skip_Reason_Field__c)) {
                //System.debug('IS NOT EMPTY');
                skipField = testConfig.Test_Skip_Reason_Field__c;
                System.debug('SKIP FIELD VALUE ===> ' + skipField);

            }
        }else {
            System.debug('NOT FOUND =====> ' + field);
            return null;
        }

        return skipField;
    }

    public static List<Picklist_Description_Config__mdt> getFieldValues(String field) {
        Map<String, Picklist_Description_Config__mdt> configMap = mapOfPicklistDescriptions();
        List<Picklist_Description_Config__mdt> configs = new List<Picklist_Description_Config__mdt>();
        List<Picklist_Description_Config__mdt> nfound = new List<Picklist_Description_Config__mdt>();
        //System.debug('Config Map Values: ' +  configMap.values());
        //System.debug('Config Map Size: ' +  configMap.size());
        //System.debug(field);

        for (Picklist_Description_Config__mdt config : configMap.values()) {
            if (config.Field_API_Name__c.startsWith(field)) {
                configs.add(config);
            }else {
                nfound.add(config);
            }
        }
        //System.debug(nfound.size());
        //System.debug(configs.size());
        return configs;
    }

}