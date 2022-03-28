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
        ListUtils.sort(testConfig, new SObjectStringFieldComparator('Test_Display_Order__c'));

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


    public static Map<String, String[]> getSummaryTemplateMap() {
        Set<String> puppySet = new Set<String>();
        Set<String> adultSet = new Set<String>();
        Set<String> fightingSet = new Set<String>();
        Set<String> dogOnlySet = new Set<String>();

        Map<String, String[]> result = new Map<String, String[]>();

        List<Test_Config__mdt> testConfig = Test_Config__mdt.getAll().values();
        ListUtils.sort(testConfig, new SObjectStringFieldComparator('Test_Display_Order__c'));

        for (Test_Config__mdt t : testConfig) {
            String testName = t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
            if (testName != null) {
                testName = testName.replace(' P1', '').replace(' P2', '').replace(' P3', '');
                if (t.IsPuppy__c) {
                    puppySet.add(testName);
                }

                if (t.IsAdult__c) {
                    adultSet.add(testName);
                }

                if (t.IsDogFighting__c) {
                    fightingSet.add(testName);
                }

                if (t.IsDogOnly__c) {
                    dogOnlySet.add(testName);
                }
            }
        }

        result.put('Puppy', new List<String>(puppySet));
        result.put('Adult Animal', new List<String>(adultSet));
        result.put('Dog Fighting', new List<String>(fightingSet));
        result.put('Dog/Dog Only', new List<String>(dogOnlySet));
        return result;
    }

    public static Map<String, Map<String, Test_Config__mdt[]>> getCommentSkipFieldsMap() {
        Map<String, Map<String, Test_Config__mdt[]>> commentFieldsMap = new Map<String, Map<String, Test_Config__mdt[]>>();
        List<Test_Config__mdt> testConfig = Test_Config__mdt.getAll().values();

        ListUtils.sort(testConfig, new SObjectStringFieldComparator('Test_Display_Order__c'));

        Map<String, Test_Config__mdt[]> puppyConfigMap = new Map<String, Test_Config__mdt[]>();
        Map<String, Test_Config__mdt[]> adultConfigMap = new Map<String, Test_Config__mdt[]>();
        Map<String, Test_Config__mdt[]> fightingConfigMap = new Map<String, Test_Config__mdt[]>();
        Map<String, Test_Config__mdt[]> dogOnlyConfigMap = new Map<String, Test_Config__mdt[]>();

        for (Test_Config__mdt t : testConfig) {
            String testName = t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
            if (testName != null) {
                testName = testName.replace(' P1', '').replace(' P2', '').replace(' P3', '');

                if (t.IsPuppy__c) {
                    if(puppyConfigMap.containsKey(testName)){
                        puppyConfigMap.get(testName).add(t);
                    } else {
                        puppyConfigMap.put(testName, new Test_Config__mdt[]{t});
                    }
                }
                if (t.IsAdult__c) {
                    if(adultConfigMap.containsKey(testName)){
                        adultConfigMap.get(testName).add(t);
                    } else {
                        adultConfigMap.put(testName, new Test_Config__mdt[]{t});
                    }
                }
                if (t.IsDogFighting__c) {
                    if(fightingConfigMap.containsKey(testName)){
                        fightingConfigMap.get(testName).add(t);
                    } else {
                        fightingConfigMap.put(testName, new Test_Config__mdt[]{t});
                    }
                }
                if (t.IsDogOnly__c) {
                    if(dogOnlyConfigMap.containsKey(testName)){
                        dogOnlyConfigMap.get(testName).add(t);
                    } else {
                        dogOnlyConfigMap.put(testName, new Test_Config__mdt[]{t});
                    }
                }
            }
        }

        commentFieldsMap.put('Puppy', puppyConfigMap);
        commentFieldsMap.put('Adult Animal', adultConfigMap);
        commentFieldsMap.put('Dog Fighting', fightingConfigMap);
        commentFieldsMap.put('Dog/Dog Only', dogOnlyConfigMap);

        return commentFieldsMap;
    }

    public static Map<String, String[]> getHighValueCategoryMap() {
        Map<String, String[]> highValueMap = new Map<String, String[]>();
        List<Picklist_Description_Config__mdt> picklistConfigList = Picklist_Description_Config__mdt.getAll().values();
        for (Picklist_Description_Config__mdt p : picklistConfigList) {
            if (p.Value_Category__c == '4') {
                Test_Config__mdt t = Test_Config__mdt.getInstance(p.Test_Config__c);
                String testName = t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
                testName = testName.replace(' P1', '').replace(' P2', '').replace(' P3', '');
                if (!testName.startsWith('Resource Guarding')) {
                    if(highValueMap.containsKey(p.Field_API_Name__c)){
                        highValueMap.get(p.Field_API_Name__c).add(p.Field_Value__c);
                    }else {
                        highValueMap.put(p.Field_API_Name__c, new String[]{p.Field_Value__c});
                    }
                }
            }
        }
        return highValueMap;
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
        Map<String, Map<String, Test_Config__mdt[]>> commentFieldsMapMap = getCommentSkipFieldsMap();

        //List of picklist fields/values that have a value category of 4
        Map<String, String[]> highValueMap = getHighValueCategoryMap();

        Map<String, String[]> summaryListMap = getSummaryTemplateMap();

        for (Behavior_Evaluation__c b : triggerNew) {
            Map<String, Test_Config__mdt[]> commentFieldsMap = commentFieldsMapMap.get(b.Evaluation_Subtype__c);

            Boolean skipDogTests = false;
            Behavior_Evaluation__c oldRecord = triggerOldMap.get(b.Id);
            if (oldRecord.Overall_Evaluation_Grade__c == null && b.Overall_Evaluation_Grade__c == 'D - Dog Aggression') {
                //Automates skipping dog tests
                skipDogTests = true;
            }

            String[] summaryList = summaryListMap.get(b.Evaluation_Subtype__c);
            Map<String, CommentSkipWrapper[]> commentMap = new Map<String, CommentSkipWrapper[]>();

            for(String summaryTitle : summaryList){
                System.debug('summaryTitle: ' + summaryTitle);
                CommentSkipWrapper[] commentList = new CommentSkipWrapper[0];

                Boolean skipSubsequentParts = false;
                String skipReason = null;
                Test_Config__mdt p1Config = commentFieldsMap.get(summaryTitle)[0];
                String currentFieldApi = p1Config.Test_Skip_Reason_Field__c;

                //if skipping p1, skip the others for the same reason
                if(currentFieldApi.contains('P1')){
                    if(oldRecord.get(currentFieldApi) == null && b.get(currentFieldApi) != null){
                        skipSubsequentParts = true;
                        skipReason = (String) b.get(currentFieldApi);
                    }                    
                }

                if(commentFieldsMap.containsKey(summaryTitle)){
                    for(Test_Config__mdt config : commentFieldsMap.get(summaryTitle)){
                        if (skipDogTests) {
                            if (summaryTitle.startsWith('Same Sex') || summaryTitle.startsWith('Opposite Sex')) {
                                b.put(config.Test_Skip_Reason_Field__c, 'Skipped due to risk to the helper dog');
                            }
                        }
                        else if(skipSubsequentParts && b.get(config.Test_Skip_Reason_Field__c) == null){
                            b.put(config.Test_Skip_Reason_Field__c, skipReason);
                        }

                        String picklistString = (string) b.get(config.Picklist_API_Name__c);
                        String[] highValueSelections = new String[0];
                        if(picklistString != null){
                            String[] picklistSelections = picklistString.split(';');
                            String[] highValueList = highValueMap.containsKey(config.Picklist_API_Name__c) ? highValueMap.get(config.Picklist_API_Name__c) : null;
                            if(highValueList != null){
                                for(String selection : picklistSelections){
                                    if(highValueList.contains(selection)){
                                        highValueSelections.add(selection);
                                    }
                                }
                            }
                        }

                        commentList.add(new CommentSkipWrapper(
                            config.Test_Name__c,
                            (string) b.get(config.Test_Comment_Field_Name__c), 
                            (string) b.get(config.Test_Skip_Reason_Field__c),
                            !highValueSelections.isEmpty() ? string.join(highValueSelections, ';') : null
                        ));
                    }
                    commentMap.put(summaryTitle, commentList);
                }
            }

            String summary = '';
            
            for(String testName: summaryList){
                summary += '<p><b>' + testName + ': </b>';
                if(commentMap.containsKey(testName)){
                    String[] tempCommentList = new String[0];
                    for(CommentSkipWrapper comments : commentMap.get(testName)){
                        if(comments.commentField != null) {
                            tempCommentList.add(comments.commentField);
                        }

                        if(comments.skipField != null) {
                            tempCommentList.add(comments.skipField);
                        }

                        if(comments.highValueField != null) {
                            tempCommentList.add(comments.highValueField);
                        }                        
                    }
                    if(!tempCommentList.isEmpty()){
                        summary += string.join(tempCommentList, ',');
                    }
                }
                summary += '<p>';
            }

            b.Behavior_Evaluation_Summary__c = summary;
        }
    }

    public static void handleAfterUpdate(List<Behavior_Evaluation__c> triggerNew, Map<Id, Behavior_Evaluation__c> triggerOldMap) {
        LogHistory.LogHistory(triggerOldMap, triggerNew);
    }
}