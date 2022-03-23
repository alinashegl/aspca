public class BehaviorEvaluationSummaryUtil {
    public static Map<String, String> getSummaryTemplate() {
        Set<String> puppySet = new Set<String>();
        Set<String> adultSet = new Set<String>();
        Set<String> fightingSet = new Set<String>();
        Set<String> dogOnlySet = new Set<String>();
        List<SummaryWrapper> puppySummary = new List<SummaryWrapper>();
        List<SummaryWrapper> adultSummary = new List<SummaryWrapper>();
        List<SummaryWrapper> fightingSummary = new List<SummaryWrapper>();
        List<SummaryWrapper> dogOnlySummary = new List<SummaryWrapper>();
        String puppyString = '';
        String adultString = '';
        String fightingString = '';
        String dogOnlyString = '';
        Map<String, String> result = new Map<String, String>();
        List<Test_Config__mdt> testConfig = Test_Config__mdt.getAll().values();
        for (Test_Config__mdt t : testConfig) {
            String testName = t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
            if (testName != null) {
                testName = testName.replace(' P1', '').replace(' P2', '').replace(' P3', '');
                if (t.IsPuppy__c) {
                    if (!puppySet.contains(testName)) {
                        puppySet.add(testName);
                        puppySummary.add(new SummaryWrapper(Integer.valueOf(t.Test_Display_Order__c), '<p><b>' + testName + ':</b> </p>'));
                    }
                }
                if (t.IsAdult__c) {
                    if (!adultSet.contains(testName)) {
                        adultSet.add(testName);
                        adultSummary.add(new SummaryWrapper(Integer.valueOf(t.Test_Display_Order__c), '<p><b>' + testName + ':</b> </p>'));
                    }
                }
                if (t.IsDogFighting__c) {
                    if (!fightingSet.contains(testName)) {
                        fightingSet.add(testName);
                        fightingSummary.add(new SummaryWrapper(Integer.valueOf(t.Test_Display_Order__c), '<p><b>' + testName + ':</b> </p>'));
                    }
                }
                if (t.IsDogOnly__c) {
                    if (!dogOnlySet.contains(testName)) {
                        dogOnlySet.add(testName);
                        dogOnlySummary.add(new SummaryWrapper(Integer.valueOf(t.Test_Display_Order__c), '<p><b>' + testName + ':</b> </p>'));
                    }
                }
            }
        }
        puppySummary.sort();
        adultSummary.sort();
        fightingSummary.sort();
        dogOnlySummary.sort();
        for (SummaryWrapper s : puppySummary) {
            puppyString += s.labelValue;
        }
        for (SummaryWrapper s : adultSummary) {
            adultString += s.labelValue;
        }
        for (SummaryWrapper s : fightingSummary) {
            fightingString += s.labelValue;
        }
        for (SummaryWrapper s : dogOnlySummary) {
            dogOnlyString += s.labelValue;
        }
        result.put('Puppy', puppyString);
        result.put('Adult Animal', adultString);
        result.put('Dog Fighting', fightingString);
        result.put('Dog/Dog Only', dogOnlyString);
        return result;
    }

    public static List<CommentSkipWrapper> getCommentSkipFields() {
        Set<String> distinctComment = new Set<String>();
        List<CommentSkipWrapper> commentSkipList = new List<CommentSkipWrapper>();
        List<Test_Config__mdt> testConfig = Test_Config__mdt.getAll().values();
        for (Test_Config__mdt t : testConfig) {
            String testName = t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
            if (testName != null) {
                testName = testName.replace(' P1', '').replace(' P2', '').replace(' P3', '');
                if (!distinctComment.contains(t.Test_Comment_Field_Name__c)) {
                    distinctComment.add(t.Test_Comment_Field_Name__c);
                    commentSkipList.add(new CommentSkipWrapper(testName, t.Test_Comment_Field_Name__c, t.Test_Skip_Reason_Field__c));
                }
            }
        }
        return commentSkipList;
    }

    public static List<HighValueCategoryWrapper> getHighValueCategoryValues() {
        List<HighValueCategoryWrapper> highValueList = new List<HighValueCategoryWrapper>();
        List<Picklist_Description_Config__mdt> picklistConfigList = Picklist_Description_Config__mdt.getAll().values();
        for (Picklist_Description_Config__mdt p : picklistConfigList) {
            if (p.Value_Category__c == '4') {
                Test_Config__mdt t = Test_Config__mdt.getInstance(p.Test_Config__c);
                String testName = t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
                testName = testName.replace(' P1', '').replace(' P2', '').replace(' P3', '');
                if (!testName.startsWith('Resource Guarding')) {
                    highValueList.add(new HighValueCategoryWrapper(p.Field_API_Name__c, p.Field_Value__c, testName));
                }
            }
        }
        return highValueList;
    }

    public static String formatComment(String newValue, String fieldValue, String testName) {
        return formatComment(newValue, fieldValue, testName, false);
    }

    public static String formatComment(String newValue, String fieldValue, String testName, Boolean dupeCheck) {
        String result = fieldValue;
        Integer startSection = fieldValue.indexOf('<b>' + testName);
        if (startSection != -1) {
            Integer endSection = fieldValue.indexOf('</p>', startSection);
            Integer endSectionSpace = fieldValue.indexOf(' </p>', startSection);
            if (dupeCheck) {
                String testContent = fieldValue.substring(startSection, endSection);
                if (testContent.contains(newValue)) {
                    return result;
                }
            }
            result = fieldValue.substring(0, endSection) + (endSection - endSectionSpace == 1 ? '' : ' ') + newValue + fieldValue.substring(endSection);
        }
        return result;
    }

    public static void handleInsert(List<Behavior_Evaluation__c> triggerNew) {
        //Prepopulate sections in summary field
        //Since this could have multiple types per insert and there might need to be more
        //than one type per set, get all values and split out into map by type
        Map<String, String> summary = getSummaryTemplate();
        for (Behavior_Evaluation__c b : triggerNew) {
            if (b.Evaluation_Subtype__c != null) {
                //Assign default set of summary items for the current type
                b.Behavior_Evaluation_Summary__c = summary.get(b.Evaluation_Subtype__c);
            }
        }
    }

    public static void handleUpdate(List<Behavior_Evaluation__c> triggerNew, Map<Id, Behavior_Evaluation__c> triggerOldMap) {
        //List of comment and skip field names per test config
        List<CommentSkipWrapper> commentSkipList = getCommentSkipFields();
        //List of picklist fields/values that have a value category of 4
        List<HighValueCategoryWrapper> highValueList = getHighValueCategoryValues();
        //In case summary values are cleared, pull template to re-populate summary field
        Map<String, String> summary = getSummaryTemplate();
        for (Behavior_Evaluation__c b : triggerNew) {
            Boolean skipDogTests = false;
            Behavior_Evaluation__c oldRecord = triggerOldMap.get(b.Id);
            if (oldRecord.Overall_Evaluation_Grade__c == null && b.Overall_Evaluation_Grade__c == 'D - Dog Aggression') {
                //Automates skipping dog tests
                skipDogTests = true;
            }
            if (String.isBlank(b.Behavior_Evaluation_Summary__c)) {
                if (b.Evaluation_Subtype__c != null) {
                    b.Behavior_Evaluation_Summary__c = summary.get(b.Evaluation_Subtype__c);
                }
            }
            
            for (CommentSkipWrapper c : commentSkipList) {
                if ((String)oldRecord.get(c.commentField) == null && (String)b.get(c.commentField) != null) {
                    //Insert new comment value into summary field for the specified test name
                    String commentValue = (String)b.get(c.commentField);
                    b.Behavior_Evaluation_Summary__c = formatComment(commentValue, b.Behavior_Evaluation_Summary__c, c.testName);
                }
                //Set dog aggression skip values for the Same Sex/Opposite Sex tests if applicable
                //Checking skip field values after this step will automatically add the skip values to the summary
                if (skipDogTests) {
                    if (c.testName.startsWith('Same Sex') || c.testName.startsWith('Opposite Sex')) {
                        b.put(c.skipField, 'Skipped due to risk to the helper dog');
                    }
                }
                if ((String)oldRecord.get(c.skipField) == null && (String)b.get(c.skipField) != null) {
                    //Insert new skip value into summary field for the specified test name
                    String skipValue = (String)b.get(c.skipField);
                    b.Behavior_Evaluation_Summary__c = formatComment(skipValue, b.Behavior_Evaluation_Summary__c, c.testName);
                }
               // if(String.valueof(b.get(c.skipField)) == '@@'){
                 //  b.Behavior_Evaluation_Summary__c = ' ';
               // }
            }
            
            for (HighValueCategoryWrapper h : highValueList) {
                //Check high value items when picklist field updated, but ignore edits that remove all picklist values
                if ((String)oldRecord.get(h.fieldApiName) != (String)b.get(h.fieldApiName) && (String)b.get(h.fieldApiName) != null) {
                    String oldString = (String)oldRecord.get(h.fieldApiName);
                    String newString = (String)b.get(h.fieldApiName);
                    //Check to see if the new picklist value contains the high value selection and didn't previously contain that value
                    if (newString.contains(h.fieldValue) && (oldString == null || !oldString.contains(h.fieldvalue))) {
                        b.Behavior_Evaluation_Summary__c = formatComment(h.fieldvalue, b.Behavior_Evaluation_Summary__c, h.testName, true);
                    }
                }
                //if(String.valueof(b.get(h.fieldApiName)) == '@@'){
                    //b.Behavior_Evaluation_Summary__c = ' ';
                //}
            }
             
        }
    }

    public static void handleAfterUpdate(List<Behavior_Evaluation__c> triggerNew, Map<Id, Behavior_Evaluation__c> triggerOldMap) {
        LogHistory.LogHistory(triggerOldMap, triggerNew);
    }
}