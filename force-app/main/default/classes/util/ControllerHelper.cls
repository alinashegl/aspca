/**
 * Created by barne on 4/9/2021.
 */

public with sharing class ControllerHelper {

    public class Properties{
        public String id;
        public String label;
        public List<PicklistEntry> entries;
        public DescribeFieldResult fieldResult;

        public Properties(String id, String label, List<PicklistEntry> entries, DescribeFieldResult fieldResult){
            this.id = id;
            this.label = label;
            this.entries = entries;
            this.fieldResult = fieldResult;
        }

        public Properties(){ }
    }

    public static Properties getFieldProperties(SObjectField field) {
        Properties prop = new Properties();
        prop.fieldResult = field.getDescribe();
        prop.entries = prop.fieldResult.getPicklistValues();
        prop.id = prop.fieldResult.name;
        prop.label = prop.fieldResult.label;

        return prop;
    }
}