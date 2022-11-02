public class BehaviorEvaluationSummaryUtil {
    public static Boolean skipTrigger = false;
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
        @AuraEnabled public String summaryTemplate;
        @AuraEnabled public Map<String, Test_Config__mdt> templateMap;
        @AuraEnabled public String[] templateList;
        @AuraEnabled public String[] templateParentList;
        @AuraEnabled public Map<String, String[]> parentToTemplateListMap;
        @AuraEnabled public Map<String, Test_Config__mdt[]> commentSkipFieldsMap;
    }

    public static ConfigTypeWrapper getConfigInfo(String type){
        ConfigTypeWrapper configInfo = new ConfigTypeWrapper();
        Set<String> parentConfigSet = new Set<String>();
        Map<String, String[]> parentToTemplateListMap = new Map<String, String[]>();
        Map<String, Test_Config__mdt[]> configMap = new Map<String, Test_Config__mdt[]>();
        Map<String, Test_Config__mdt> nameToConfigMap = new Map<String, Test_Config__mdt>();

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
                    configSummary.add(new SummaryWrapper(Integer.valueOf(t.Test_Display_Order__c), '<b>' + testName + ':</b>&nbsp;<br>'));
                    nameToConfigMap.put(testName, t);
                }
            }
            
            //getSummaryTemplateList
            String parentTestName = t.Parent_Test_Api_Name__c != null ? t.Parent_Test_Api_Name__c : 
                t.Overall_Test_Display_Name__c != null ? t.Overall_Test_Display_Name__c : t.Test_Name__c;
            if (parentTestName != null) {
                parentConfigSet.add(parentTestName);

                if(parentToTemplateListMap.containsKey(parentTestName)){
                    String[] testNameList = parentToTemplateListMap.get(parentTestName);
                    Set<String> testNameSet = new Set<String>(testNameList);
                    testNameSet.add(testName);
                    parentToTemplateListMap.put(parentTestName, new String[(testNameSet)]);
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
        configInfo.templateMap = nameToConfigMap;
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
        if (skipTrigger) return;
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

    public static void handleAfterInsert(List<Behavior_Evaluation__c> triggerNew){
        if (skipTrigger) return;
        Behavior_Evaluation_Summary__c[] summaries = new Behavior_Evaluation_Summary__c[0];
        for (Behavior_Evaluation__c b : triggerNew) {
            if (b.Evaluation_Subtype__c != null) {
                ConfigTypeWrapper configInfos = getConfigInfos(b.Evaluation_Subtype__c);
                summaries.add(new Behavior_Evaluation_Summary__c(
                    Behavior_Evaluation__c = b.Id,
                    Test_Name__c = 'General Comments',
                    Display_Order__c = 0
                ));

                Integer i = 1;
                for(String test : configInfos.templateMap.keySet()){
                    Test_Config__mdt config = configInfos.templateMap.get(test);
                    summaries.add(new Behavior_Evaluation_Summary__c(
                        Behavior_Evaluation__c = b.Id,
                        Test_Name__c = test,
                        Display_Order__c = Decimal.valueOf(config.Test_Display_Order__c),
                        ConfigId__c = config.Id
                    ));
                }
            }
        }
        insert summaries;
    }

    @AuraEnabled
    public static void handleSummaryUpdate(Id evalId){
        handleSummaryUpdate(new Id[]{evalId});
    }

    public static void handleSummaryUpdate(Id[] evalIds){
        Behavior_Evaluation__c[] evaluations = [
            SELECT Id,
            (
                SELECT Id, Test_Name__c, Summary_Comments__c, Display_Order__c, ConfigId__c
                FROM Behavior_Evaluation_Summaries__r
                ORDER BY Display_Order__c ASC
            )
            FROM Behavior_Evaluation__c 
            WHERE Id IN :evalIds
        ];
    
        for(Behavior_Evaluation__c eval : evaluations){
            if(eval.Behavior_Evaluation_Summaries__r.isEmpty()){
                continue;
            }
            String evalSummary = '';
    
            for(Behavior_Evaluation_Summary__c summary : eval.Behavior_Evaluation_Summaries__r){
                Test_Config__mdt config = Test_Config__mdt.getInstance(summary.ConfigId__c);
                if(summary.Test_Name__c != 'General Comments'){
                    evalSummary += '<p><b>' + summary.Test_Name__c + ':</b>&nbsp;';
                }
                evalSummary += summary.Summary_Comments__c == null ? '</p>' : summary.Summary_Comments__c + '</p>';
            }
    
            eval.Behavior_Evaluation_Summary__c = evalSummary;
        }

        update evaluations;
    }


    public static void handleBeforeUpdate(List<Behavior_Evaluation__c> triggerNew, Map<Id, Behavior_Evaluation__c> oldMap){
        if (skipTrigger) return;
        handleSummaryUpdate(triggerNew);
        handleSkipDogTests(triggerNew, oldMap);
    }

    public static void handleSummaryUpdate(List<Behavior_Evaluation__c> triggerNew){
        Map<Id, Behavior_Evaluation__c> evaluationsMap = new Map<Id, Behavior_Evaluation__c>([
            SELECT Id,
            (
                SELECT Id, Test_Name__c, Summary_Comments__c, Display_Order__c, ConfigId__c
                FROM Behavior_Evaluation_Summaries__r
                ORDER BY Display_Order__c ASC
            )
            FROM Behavior_Evaluation__c 
            WHERE Id IN :triggerNew
        ]);
    
        for(Behavior_Evaluation__c eval : triggerNew){
            if(!evaluationsMap.containsKey(eval.Id) || evaluationsMap.get(eval.Id).Behavior_Evaluation_Summaries__r.isEmpty()){
                continue;
            }
            String evalSummary = '';
    
            for(Behavior_Evaluation_Summary__c summary : evaluationsMap.get(eval.Id).Behavior_Evaluation_Summaries__r){
                Test_Config__mdt config = Test_Config__mdt.getInstance(summary.ConfigId__c);
                if(summary.Test_Name__c != 'General Comments'){
                    evalSummary += '<p><b>' + summary.Test_Name__c + ':</b>&nbsp;';
                }
                evalSummary += summary.Summary_Comments__c == null ? '</p>' : summary.Summary_Comments__c + '</p>';
            }
    
            eval.Behavior_Evaluation_Summary__c = evalSummary;
        }
    }

    public static void handleSkipDogTests(List<Behavior_Evaluation__c> triggerNew, Map<Id, Behavior_Evaluation__c> oldMap){
        for (Behavior_Evaluation__c b : triggerNew) {
            Boolean skipDogTests = false;
            Behavior_Evaluation__c oldRecord = oldMap.get(b.Id);
            if (oldRecord.Overall_Evaluation_Grade__c == null && b.Overall_Evaluation_Grade__c == 'D - Dog Aggression') {
                //Automates skipping dog tests
                ConfigTypeWrapper configInfos = getConfigInfo(b.Evaluation_Subtype__c);
                Test_Config__mdt[] configs = new Test_Config__mdt[0];
                if(configInfos.commentSkipFieldsMap.containsKey('Opposite Sex Dog')){
                    configs.addAll(configInfos.commentSkipFieldsMap.get('Opposite Sex Dog'));
                }

                if(configInfos.commentSkipFieldsMap.containsKey('Same Sex Dog')){
                    configs.addAll(configInfos.commentSkipFieldsMap.get('Same Sex Dog'));
                }

                for(Test_Config__mdt config : configs){
                    b.put(config.Test_Skip_Reason_Field__c, 'Skipped due to risk to the helper dog');
                }
            } 
        }
    }

    public static void handleAfterUpdate(List<Behavior_Evaluation__c> triggerNew, Map<Id, Behavior_Evaluation__c> triggerOldMap) {
        if (skipTrigger) return;
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

    @AuraEnabled
    public static void updateBehaviorEvalSummary(Id recordId){
        try {
            handleSummaryUpdate(new Id[]{recordId});
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static SummaryDisplay getConfigList(Id recordId){
        try {
            Behavior_Evaluation__c ba = [
                SELECT Id, Evaluation_Subtype__c, IsLocked__c,
                (
                    SELECT Id, Test_Name__c, Summary_Comments__c, Display_Order__c 
                    FROM Behavior_Evaluation_Summaries__r
                    ORDER BY Display_Order__c ASC
                )
                FROM Behavior_Evaluation__c 
                WHERE Id = :recordId LIMIT 1];        
            return new SummaryDisplay(ba);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class SummaryDisplay{
        @AuraEnabled public SummaryTestInfo[] templateList;
        @AuraEnabled public Boolean isLocked;

        public SummaryDisplay(Behavior_Evaluation__c ba){
            this.templateList = new SummaryTestInfo[0];
            for(Behavior_Evaluation_Summary__c summary : ba.Behavior_Evaluation_Summaries__r){
                templateList.add(new SummaryTestInfo(summary));
            }
            this.isLocked = ba.IsLocked__c;
        }
    }

    public class SummaryTestInfo{
        @AuraEnabled public Id testId;
        @AuraEnabled public String testName;
        @AuraEnabled public String summaryComments;
        @AuraEnabled public String testComments;

        public SummaryTestInfo(Behavior_Evaluation_Summary__c summary){
            this.testId = summary.Id;
            this.testName = summary.Test_Name__c;
            this.summaryComments = summary.Summary_Comments__c;
        }
    }

    public static void populateEvaluationSummaries(Id[] animalIds, Integer count){
        String query = 'SELECT Id, Evaluation_Subtype__c,Behavior_Evaluation_Summary__c ' + 
            'FROM Behavior_Evaluation__c '+
            'WHERE Evaluation_Subtype__c != null '+
            'AND Id NOT IN( '+
                'SELECT Behavior_Evaluation__c FROM Behavior_Evaluation_Summary__c '+
            ')';

        if(animalIds != null && !animalIds.isEmpty()){
            query += ' AND Animal__c IN :animalIds';
        }
            
        if(count != null && count > 0){
            query += ' LIMIT :count';
        }

        Behavior_Evaluation__c[] evals = database.query(query);

        Behavior_Evaluation_Summary__c[] summaries = new Behavior_Evaluation_Summary__c[0];
        for (Behavior_Evaluation__c eval : evals) {
            if (eval.Evaluation_Subtype__c != null) {
                ConfigTypeWrapper configInfos = getConfigInfos(eval.Evaluation_Subtype__c);
                Map<String, String> parsedMap = parseSummary(configInfos.templateList, eval.Behavior_Evaluation_Summary__c);
                summaries.add(new Behavior_Evaluation_Summary__c(
                    Behavior_Evaluation__c = eval.Id,
                    Test_Name__c = 'General Comments',
                    Display_Order__c = 0,
                    Summary_Comments__c = parsedMap.containsKey('preText') ? parsedMap.get('preText') : null
                ));

                Integer i = 1;
                for(String test : configInfos.templateList){
                    Test_Config__mdt config = configInfos.templateMap.get(test);
                    summaries.add(new Behavior_Evaluation_Summary__c(
                        Behavior_Evaluation__c = eval.Id,
                        Test_Name__c = test,
                        Display_Order__c = Decimal.valueOf(config.Test_Display_Order__c),
                        ConfigId__c = config.Id,
                        Summary_Comments__c = parsedMap.containsKey(test) ? parsedMap.get(test) : null
                    ));
                }
            }
        }
        insert summaries;
    }

    private static Map<String, String> parseSummary(String[] summaryList, String newSummary){
        // ConfigTypeWrapper configInfos = getConfigInfo(evalSubtype);
        // String[] summaryList = configInfos.templateList;

        Map<String, String> summaryMap = new Map<String, String>();
        if(String.isNotEmpty(newSummary)){        
            for(Integer i = 0; i < summaryList.size(); i++){
                Integer newSummaryIndexStart = newSummary.indexOf(summaryList[i]);
                if(i == 0 && newSummaryIndexStart > 0){
                    String preText = newSummary.substring(0, newSummaryIndexStart);
                    preText = cleanString(preText);
                    System.debug('preText: ' + preText);
                    summaryMap.put('preText', preText);
                }
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
        String[] toCleanList = toClean.split(',');
        Set<String> toCleanSet = new Set<String>(toCleanList);
        toCleanSet.remove('');
        toCleanSet.remove(null);
        toClean = string.join(new List<String>(toCleanSet), ', ');
        if(toClean != null && String.isNotEmpty(toClean)){
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