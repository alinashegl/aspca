public class BehaviorEvaluationSummaryUtil {
    private static final Boolean COMPARE_NUMBERS = true;
    private static final String PUPPY_TYPE = 'puppy';
    private static final String ADULT_TYPE = 'Adult Animal';
    private static final String FIGIHTING_TYPE = 'Dog Fighting';
    private static final String DOG_ONLY_TYPE = 'Dog/Dog Only';

    public static Map<String, Test_Config__mdt[]> testConfigMap{
        get{
            if(testConfigMap == null || testConfigMap.isEmpty()){
                Test_Config__mdt[] puppyList = new Test_Config__mdt[0];
                Test_Config__mdt[] adultList = new Test_Config__mdt[0];
                Test_Config__mdt[] fightingList = new Test_Config__mdt[0];
                Test_Config__mdt[] dogOnlyList = new Test_Config__mdt[0];

                Test_Config__mdt[] testConfigList = Test_Config__mdt.getAll().values();
                for(Test_Config__mdt config : testConfigList){
                    if(config.IsPuppy__c){
                        puppyList.add(config);
                    }
                    if(config.IsAdult__c){
                        adultList.add(config);
                    }
                    if(config.IsDogFighting__c){
                        fightingList.add(config);
                    }
                    if(config.IsDogOnly__c){
                        dogOnlyList.add(config);
                    }
                }

                testConfigMap = new Map<String, Test_Config__mdt[]>();

                testConfigMap.put(PUPPY_TYPE, puppyList);
                testConfigMap.put(ADULT_TYPE, adultList);
                testConfigMap.put(FIGIHTING_TYPE, fightingList);
                testConfigMap.put(DOG_ONLY_TYPE, dogOnlyList);
            }
            return testConfigMap;
        }
        set;
    }

    public static Test_Config__mdt[] puppyConfigList{
        get{
            if(puppyConfigList == null || puppyConfigList.isEmpty()){
                puppyConfigList = testConfigMap.get('puppy');
                ListUtils.sort(puppyConfigList, new SObjectStringFieldComparator('Test_Display_Order__c'), COMPARE_NUMBERS);
            }
            return puppyConfigList;
        }
        set;
    }

    public static Test_Config__mdt[] adultConfigList{
        get{
            if(adultConfigList == null || adultConfigList.isEmpty()){
                adultConfigList = testConfigMap.get('Adult Animal');
                ListUtils.sort(adultConfigList, new SObjectStringFieldComparator('Test_Display_Order__c'), COMPARE_NUMBERS);
            }
            return adultConfigList;
        }
        set;
    }

    public static Test_Config__mdt[] fightingConfigList{
        get{
            if(fightingConfigList == null || fightingConfigList.isEmpty()){
                fightingConfigList = testConfigMap.get('Dog Fighting');
                ListUtils.sort(fightingConfigList, new SObjectStringFieldComparator('Test_Display_Order__c'), COMPARE_NUMBERS);
            }
            return fightingConfigList;
        }
        set;
    }

    public static Test_Config__mdt[] dogOnlyConfigList{
        get{
            if(dogOnlyConfigList == null || dogOnlyConfigList.isEmpty()){
                dogOnlyConfigList = testConfigMap.get('Dog/Dog Only');
                ListUtils.sort(dogOnlyConfigList, new SObjectStringFieldComparator('Test_Display_Order__c'), COMPARE_NUMBERS);
            }
            return dogOnlyConfigList;
        }
        set;
    }

    public static ConfigTypeWrapper adultConfigInfo{
        get{
            if(adultConfigInfo == null){
                adultConfigInfo = getConfigInfo(ADULT_TYPE);
            }
            return adultConfigInfo;            
        }
        set;
    }

    public static ConfigTypeWrapper puppyConfigInfo{
        get{
            if(puppyConfigInfo == null){
                puppyConfigInfo = getConfigInfo(PUPPY_TYPE);
            }
            return puppyConfigInfo;            
        }
        set;
    }

    public static ConfigTypeWrapper fightingConfigInfo{
        get{
            if(fightingConfigInfo == null){
                fightingConfigInfo = getConfigInfo(FIGIHTING_TYPE);
            }
            return fightingConfigInfo;            
        }
        set;
    }

    public static ConfigTypeWrapper dogOnlyConfigInfo{
        get{
            if(dogOnlyConfigInfo == null){
                dogOnlyConfigInfo = getConfigInfo(DOG_ONLY_TYPE);
            }
            return dogOnlyConfigInfo;            
        }
        set;
    }

    public class ConfigTypeWrapper {
        public String summaryTemplate;
        public String[] templateList;
        public String[] templateParentList;
        public Map<String, String[]> parentToTemplateListMap;
        public Map<String, Test_Config__mdt[]> commentSkipFieldsMap;

    }

    public static ConfigTypeWrapper getConfigInfo(String type){
        ConfigTypeWrapper configInfo = new ConfigTypeWrapper();
        Set<String> parentConfigSet = new Set<String>();
        Map<String, String[]> parentToTemplateListMap = new Map<String, String[]>();
        Map<String, Test_Config__mdt[]> configMap = new Map<String, Test_Config__mdt[]>();

        Test_Config__mdt[] testConfigList = new Test_Config__mdt[0];
        if(type == ADULT_TYPE){
            testConfigList = adultConfigList;
        }
        else if(type == PUPPY_TYPE){
            testConfigList = PUPPYConfigList;
        }
        else if(type == FIGIHTING_TYPE){
            testConfigList = fightingConfigList;
        }
        else if(type == DOG_ONLY_TYPE){
            testConfigList = dogOnlyConfigList;
        }

        Set<String> configNameSet = new Set<String>();
        List<SummaryWrapper> configSummary = new List<SummaryWrapper>();
        String summaryString = '';

        Map<String, String> result = new Map<String, String>();

        for (Test_Config__mdt t : testConfigList) {
            String testName = t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;

            //getSummaryTemplate
            if (testName != null) {
                testName = testName.replace(' P1', '').replace(' P2', '').replace(' P3', '');
                if (!configNameSet.contains(testName)) {
                    configNameSet.add(testName);
                    configSummary.add(new SummaryWrapper(Integer.valueOf(t.Test_Display_Order__c), '<p><b>' + testName + ':</b> </p>'));
                }
            }

            
            //getSummaryTemplateList
            String parentTestName = t.Parent_Test_Api_Name__c != null ? t.Parent_Test_Api_Name__c : 
                t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
            if (parentTestName != null) {
                parentConfigSet.add(parentTestName);

                if(parentToTemplateListMap.containsKey(parentTestName)){
                    parentToTemplateListMap.get(parentTestName).add(testName);
                } else {
                    parentToTemplateListMap.put(parentTestName, new String[]{testName});
                }
            }

            //getCommentSkipFieldsMap
            String fullTestName = t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
            if (fullTestName != null) {
                testName = fullTestName.replace(' P1', '').replace(' P2', '').replace(' P3', '');

                if(configMap.containsKey(testName)){
                    if(!t.is_Child__c){
                        configMap.get(testName).add(t);
                    }
                } else {
                    configMap.put(testName, new Test_Config__mdt[]{t});
                }
            }
        }

        for (SummaryWrapper s : configSummary) {
            summaryString += s.labelValue;
        }

        configInfo.summaryTemplate = summaryString;
        configInfo.templateList = new List<String>(configNameSet);
        configInfo.templateParentList = new List<String>(parentConfigSet);
        configInfo.commentSkipFieldsMap = configMap;
        configInfo.parentToTemplateListMap = parentToTemplateListMap;

        return configInfo;
        
    }

    public static Map<String, String[]> getHighValueCategoryMap() {
        Map<String, String[]> highValueMap = new Map<String, String[]>();
        List<Picklist_Description_Config__mdt> picklistConfigList = Picklist_Description_Config__mdt.getAll().values();
        for (Picklist_Description_Config__mdt p : picklistConfigList) {
            if (p.Value_Category__c == '4') {
                Test_Config__mdt t = Test_Config__mdt.getInstance(p.Test_Config__c);
                String testName = t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
                testName = testName.replace(' P1', '').replace(' P2', '').replace(' P3', '');
                if (!testName.startsWith('Food Bowl') && !testName.startsWith('Chewy')) {
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

        // Map<String, String> summary = getSummaryTemplate();
        for (Behavior_Evaluation__c b : triggerNew) {
            if (b.Evaluation_Subtype__c != null) {
                //Assign default set of summary items for the current type
                ConfigTypeWrapper configInfos = getConfigInfos(b.Evaluation_Subtype__c);
                b.Behavior_Evaluation_Summary__c = configInfos.summaryTemplate;
            }
        }
    }

    public static void handleUpdate(List<Behavior_Evaluation__c> triggerNew, Map<Id, Behavior_Evaluation__c> triggerOldMap) {
        //List of picklist fields/values that have a value category of 4
        Map<String, String[]> highValueMap = getHighValueCategoryMap();

        for (Behavior_Evaluation__c b : triggerNew) {
            ConfigTypeWrapper configInfos = getConfigInfo(b.Evaluation_Subtype__c);

            Map<String, Test_Config__mdt[]> commentFieldsMap = configInfos.commentSkipFieldsMap;
            String[] summaryList = configInfos.templateList;
            System.debug('summaryList: ' + summaryList);

            String[] parentSummaryList = configInfos.templateParentList;
            System.debug('parentSummaryList: ' + parentSummaryList);

            Map<String, String[]> parentSummaryMap = configInfos.parentToTemplateListMap;

            Boolean skipDogTests = false;
            Behavior_Evaluation__c oldRecord = triggerOldMap.get(b.Id);
            if (oldRecord.Overall_Evaluation_Grade__c == null && b.Overall_Evaluation_Grade__c == 'D - Dog Aggression') {
                //Automates skipping dog tests
                skipDogTests = true;
            }            

            Map<String, CommentSkipWrapper[]> commentMap = new Map<String, CommentSkipWrapper[]>();

            Map<String, String> summaryDiffMap = parseSummaryList(b.Behavior_Evaluation_Summary__c, summaryList);

            for(String parentSummaryTitle : parentSummaryMap.keySet()){
                Boolean skipSubsequentParts = false;
                String skipReason = null;
                
                for(String summaryTitle : parentSummaryMap.get(parentSummaryTitle)){
                    String parsedComments = summaryDiffMap.containsKey(summaryTitle) ? summaryDiffMap.get(summaryTitle) : null;
                    CommentSkipWrapper[] commentList = new CommentSkipWrapper[0];

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
                                if (summaryTitle.startsWith('Same Sex') || summaryTitle.startsWith('Opposite Sex') || summaryTitle.startsWith('Same_Sex') || summaryTitle.startsWith('Opposite_Sex')) {
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

                            String testCommentsText = (string) b.get(config.Test_Comment_Field_Name__c);
                            String skipReasonText = (string) b.get(config.Test_Skip_Reason_Field__c);
                            String oldSkipReasonTest = (string) oldRecord.get(config.Test_Skip_Reason_Field__c);

                            //clear skip reason and comments from comment field from the parsed comments
                            if(parsedComments != null){
                                if(testCommentsText != null){
                                    parsedComments = parsedComments.replaceAll(testCommentsText, '');
                                }

                                if(skipReasonText != null){
                                    parsedComments = parsedComments.replaceAll(skipReasonText, '');
                                }

                                if(oldSkipReasonTest != null){
                                    parsedComments = parsedComments.replaceAll(oldSkipReasonTest, '');
                                }

                                parsedComments = cleanString(parsedComments);
                            }

                            System.debug('parsedComments: ' + parsedComments);

                            commentList.add(new CommentSkipWrapper(
                                config.Test_Name__c,
                                testCommentsText, 
                                skipReasonText,
                                !highValueSelections.isEmpty() ? string.join(highValueSelections, ';') : null,
                                parsedComments
                            ));

                            //unskip if score was added
                            if(oldRecord.get(config.Picklist_API_Name__c) == null && b.get(config.Picklist_API_Name__c) != null){
                                System.debug('**setting skip field to null');
                                b.put(config.Test_Skip_Reason_Field__c, null);
                            }
                        }
                        commentMap.put(summaryTitle, commentList);
                    }
                }
            }

            String summary = '';
            
            for(String testName: summaryList){
                summary += '<p><b>' + testName + ':</b>&nbsp;';
                if(commentMap.containsKey(testName)){
                    String[] tempCommentList = new String[0];
                    for(CommentSkipWrapper comments : commentMap.get(testName)){
                        if(comments.commentField != null) {
                            System.debug('comments.commentField: ' + comments.commentField);
                            tempCommentList.add(comments.commentField);
                        }

                        if(comments.skipField != null) {
                            System.debug('comments.skipField: ' + comments.skipField);
                            tempCommentList.add(comments.skipField);
                        }

                        if(comments.highValueField != null) {
                            System.debug('comments.highValueField: ' + comments.highValueField);
                            tempCommentList.add(comments.highValueField);
                        }

                        if(String.isNotBlank(comments.summaryField)) {
                            System.debug('comments.summaryField: ' + comments.summaryField);
                            tempCommentList.add(comments.summaryField);
                        }   
                    }
                    if(!tempCommentList.isEmpty()){
                        summary += string.join(tempCommentList, ', ');
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

    public static ConfigTypeWrapper getConfigInfos(String type){
        ConfigTypeWrapper configInfos = new ConfigTypeWrapper();

        if(type == ADULT_TYPE){
            configInfos = adultConfigInfo;
        }

        else if(type == PUPPY_TYPE){
            configInfos = puppyConfigInfo;
        }

        else if(type == FIGIHTING_TYPE){
            configInfos = fightingConfigInfo;
        }

        else if(type == DOG_ONLY_TYPE){
            configInfos = dogOnlyConfigInfo;
        }

        return configInfos;
    }

    public static Map<String, String> parseSummaryList(String newSummary, String[] summaryList){
        Map<String, String> summaryMap = new Map<String, String>();

        if(String.isNotEmpty(newSummary)){
        
            for(Integer i = 0; i < summaryList.size(); i++){
                Integer newSummaryIndexStart = newSummary.indexOf(summaryList[i]);
                if(newSummaryIndexStart == -1) continue;
                Integer newSummaryIndexEnd = i + 1 >= summaryList.size() ? null : newSummary.indexOf(summaryList[i+1]);

                String newSubSummary;
                if(newSummaryIndexEnd == null || newSummaryIndexEnd == -1){
                    newSubSummary = newSummary.substring(newSummaryIndexStart);
                } else {
                    newSubSummary = newSummary.substring(newSummaryIndexStart, newSummaryIndexEnd);
                }

                Integer index = newSubSummary.indexOf(':');
                String summaryKey = cleanString(newSubSummary.substring(0, index));
                String summaryValue = cleanString(newSubSummary.substring(index));

                summaryMap.put(summaryKey, summaryValue);
            }
        }
        return summaryMap;
    }

    public static String cleanString(String toClean){
        toClean = toClean.stripHtmlTags();
        toClean = toclean.normalizeSpace();
        System.debug('toClean: ' + toClean);
        if(toClean != null && String.isNotEmpty(toClean)){
            System.debug('toClean length: ' + toClean.length());
            Boolean isAlphanumeric = false;

            while(!isAlphanumeric){
                if(toClean == null){
                    isAlphanumeric = true;
                }
                else if(toClean.length() == 1){                    
                    toClean = toClean.isAlphanumeric() ? toClean : null;
                } else {
                    isAlphanumeric = toClean.substring(0, 1).isAlphanumeric();
                    if(!isAlphanumeric){
                        toClean = toClean.subString(1);
                    }
                }
            }
        }
        return toClean;
    }
}