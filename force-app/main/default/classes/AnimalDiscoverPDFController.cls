public class AnimalDiscoverPDFController {
    public String animalId {get; set;}
    public List<String> potentBehIssue { get; set; }
    public String summary { get; set; }
    public Boolean paramForensic { get; set; }
    public Map<String, Object> fieldsToValue {get;set;}
    public Map<String,Set<Integer>> testAndValues {get;set;}  
    public Map<String,List<String>> testAndDisplayValues {get;set;}
    public List<List<String>> finalTestAndDisplayValues {get;set;}
    public Map<Integer,String> testOrder {get;set;}
    public List<EvaluationGroup> evaluation { get; set; }
    public List<AnimalGradeHistory> GradeHistories  { get; set; }
    
    public AnimalDiscoverPDFController(ApexPages.standardController con){
        this.animalId = con.getId();
    }
        
    /*public AnimalDiscoverPDFController() {
        this.animalId = ApexPages.currentPage().getparameters().get('Id');
    }*/
    
    public Animal__c animalD {
        public get {
            if (animalD == null){
                animalD = [select Id ,Name, Animal_Name__c,Breed__C,Age__c, Animal_Age__c,Animal_Name_Id__c, Color__c,Gender__c,Case_Type__c,Animal_Status__c,Grade_Change_Reason__c,Current_Behavior_Grade_Change_Date__c,
                           Current_Location__c,Intake_Type__c,Behavior_Concerns__c, Shelter_Kennel__c , Shelter_Location__c, Behavior_Case_Worker__c,Behavior_Case_Worker__r.Name,
                           (SELECT ID, NAME, Observation_Date__c, Observation_Notes__c, Observation_Reported_By__c,Behavior_Staff_Initials__c, Behavior_Response__c, Observation_Type__c, Animal__r.Behavior_Concerns__c from Observations__r),
                           (SELECT Id, Additional_Comments__c,Behaviors_Exhibited_by_the_Dog__c, Was_Bitten_Area_Covered_with_Clothing__c, Damage_Done_by_the_Dog__c, Incident_Date_Time__c, Incident_Description__c ,Name, Number_of_bites__c, Other_Damage_Done_by_the_Dog__c, Person_Involved__c, Please_explain_why_you_think_so__c, Report_Date__c, Specific_Target_of_Dog_s_Behavior__c, Type_of_Bite__c FROM Incidents__r),
                           (SELECT Id, Animal__c, Capture_Date__c, Behavior_Foster_Note__c, Initials__c, Name FROM Behavior_Foster_Notes__r)
                           
                           from Animal__C where ID = : animalId];
            }
            return animalD;
        }
        private set;
    }
    
    public List<animalPlaySummary>  aPlayGroups {
        public get {
            set<id> sids = new set<id>();
            List<Animal_Playgroup__c> ags = [SELECT ID, Playgroup_Session__c FROM Animal_Playgroup__c WHERE  Animal__c = : animalId]; 
            for(Animal_Playgroup__c apg : ags){
                sids.add(apg.Playgroup_Session__c);
            }
            
            List<Animal_Playgroup__c> anmPlayGroups = [SELECT ID, Play_Rating__c, Playgroup_Individual_Notes__c,Animal__C,Animal__r.Name,Playgroup_Session__c,
                                                       Playgroup_Session__r.Playgroup_Location__c,Playgroup_Session__r.Playgroup_Notes__c, 
                                                       Playgroup_Session__r.Playgroup_Date__c FROM Animal_Playgroup__c WHERE  Playgroup_Session__c IN : sids];
            Set<String> existingIds = new Set<String>();
            List<String> IndividualNotes = new List<String> ();
            aPlayGroups = new List<animalPlaySummary>();  
            for(Animal_Playgroup__c amp: anmPlayGroups){
                String pSessionId = amp.Playgroup_Session__c;
                animalPlaySummary aps = new animalPlaySummary();
                aps.Id=amp.ID;
                aps.playRating=amp.Play_Rating__c;
              
                if(!existingIds.contains(pSessionId)) {
                    List<string> animalNames = new List<string>();
                    List<string> animallocation = new List<string>();
                    List<string> animalSessionNotes = new List<string>();
                    for(Animal_Playgroup__c champ: anmPlayGroups){
                        if(amp.Playgroup_Session__c == champ.Playgroup_Session__c)
                        {
                            animalNames.add(champ.Animal__r.Name);
                            animallocation.add(champ.Playgroup_Session__r.Playgroup_Location__c);
                            animalSessionNotes.add(champ.Playgroup_Session__r.Playgroup_Notes__c);
                        }
                    }
                    aps.animalNames = animalNames;
                    existingIds.add(amp.Playgroup_Session__c);
                    aps.playLocation = animallocation;
                    aps.playSessionNotes = animalSessionNotes;
                    aps.playSessionDate= String.valueOf(amp.Playgroup_Session__r.Playgroup_Date__c);
                    aPlayGroups.add(aps);
                }
            }
            return aPlayGroups;
        }
        private set;
    }

    public List<SessionProtocol[]> aTreatmentSession {
        public get {
            Map<Id, SessionProtocol[]> treatmentSessionToProtocolsMap = new Map<Id, SessionProtocol[]>();
            List<SessionProtocol[]> aTreatmentSession = new List<SessionProtocol[]>();
            for(Session_protocol__c sp : [
                SELECT Id, 
                InView__c,
                LastModifiedById,
                Manager_Review_Notes__c,
                Needs_Review__c,
                Novel_Person__c,
                Novel_Person_Notes__c,
                Overall_Score__c,
                Overall_Score_Number__c,
                Overall_Score_Color__c,
                Preferred_Motivators__c,
                ProtocolId__c,
                Protocol_Box_Link__c,
                Protocol_Name__c,
                Protocol_Notes__c,
                IsRemoved__c,
                Review_Complete__c,
                TreatmentSessionId__r.Session_Date__c,
                Name,
                IsSkipped__c,
                Status__c,
                TreatmentSessionId__c,
                (
                    SELECT Id, Protocol_Scale_Name__c, Protocol_Score__c, Protocol_Score_Number__c 
                    FROM Session_Protocol_Scales__r 
                    WHERE Protocol_Scale__r.isDefault__c = true
                )
                FROM Session_Protocol__c
                WHERE TreatmentSessionId__r.Animal__c = :animalId
                AND TreatmentSessionId__r.Session_Date__c = LAST_N_DAYS:60
                ORDER BY TreatmentSessionId__r.Session_Date__c DESC
            ]){
                if(treatmentSessionToProtocolsMap.containsKey(sp.TreatmentSessionId__c)){
                    treatmentSessionToProtocolsMap.get(sp.TreatmentSessionId__c).add(new SessionProtocol(sp));
                } else {
                    treatmentSessionToProtocolsMap.put(sp.TreatmentSessionId__c, new SessionProtocol[]{new SessionProtocol(sp)});
                }                
            }

            for(SessionProtocol[] protos : treatmentSessionToProtocolsMap.values()){
                aTreatmentSession.add(protos);
            }
            System.debug('aTreatmentSessin: ' + aTreatmentSession);
            return aTreatmentSession;
        }
        private set;
    }


    
    public List<AnimalGradeHistory> gradeHistory {
        public get {
            String query = 'SELECT Id, RecordName__c, CreatedDate, CreatedBy.Name, FieldName__c, NewValue__c, OldValue__c, ObjectId__c, ObjectName__c FROM EntityHistory__c';
            List<SObject> results = new List<SObject>();
            List<AnimalGradeHistory> animalHistories = new List<AnimalGradeHistory>();
            if ( animalId != null && animalId != '' ) {
                query += ' WHERE (ParentId__c = \''+animalId+'\'';
                query += ' OR ObjectId__c = \''+animalId+'\')';
                query += ' Order by RecordName__c,CreatedDate';
                system.debug(query);
                results = Database.query( query );
            }
            
            for(Integer i = 0; i < results.size() - 1;i++){
                AnimalGradeHistory agh = new AnimalGradeHistory();
                agh.historyDate = DateTime.valueOf(results[i].get('CreatedDate'));
                agh.historyName = String.valueOf(results[i].get('NewValue__c'));
                if(String.valueof(results[i].get('RecordName__c')) == String.valueof(results[i+1].get('RecordName__c'))){
                    agh.historyReason = String.valueof(results[i+1].get('NewValue__c'));
                    i=i+1;
                }
                animalHistories.add(agh);
            }
            return animalHistories;
        }
        private set;
    }
    
    public List<BehaviorEvaluation> behaviorEvaluations{
        public get {
            List<Behavior_Evaluation__c> behEvaluations = [SELECT 
                                                           Id, 
                                                           Name,
                                                           Animal__r.Current_Recent_Shelter_Location__c,
                                                           Animal_Age__c,Animal_Breed__c,Animal_Color__c,
                                                           Animal_ID__c,Animal_Name__c,Animal_Sex__c,Animal__c,
                                                           Behavior_Evaluation_Summary__c,
                                                           Facility_Outcome__c, Evaluation_Date__c,Case_Number__c,
                                                           Scribe_Initials__c,Tester_Initials__c,createdDate,
                                                           Overall_Evaluation_Grade__c,Evaluation_Subtype__c,
                                                           Puppy_Dog_Interaction_P3__c,
                                                           Puppy_Dog_Interaction_P2__c,
                                                           Puppy_Dog_Interaction_P1__c,
                                                           Puppy_Social_Behavior_P2__c,
                                                           Puppy_Restraint__c,
                                                           Puppy_Play_Tag__c,
                                                           Toddler_Doll_P2__c,
                                                           Toddler_Doll_P1__c,
                                                           Tag_Test__c,
                                                           Social_Behavior_P2_2__c,
                                                           Social_Behavior_P1__c,
                                                           Unpleasant_Touch_2nd__c,
                                                           Unpleasant_Touch_1st__c,
                                                           Scolding_Person_P2__c,
                                                           Scolding_Person_P1__c,
                                                           Same_Sex_P3__c,
                                                           Same_Sex_P2__c,
                                                           Same_Sex_P1__c,
                                                           Resource_Guarding_P2_Touch_Neck__c,
                                                           Resource_Guarding_P2_Touch_Face__c,
                                                           Resource_Guarding_P2_Touch_Body__c,
                                                           Resource_Guarding_P2_Push_Face__c,
                                                           Resource_Guarding_P1_Touch_Neck__c,
                                                           Resource_Guarding_P1_Touch_Face__c,
                                                           Resource_Guarding_P1_Touch_Body__c,
                                                           Resource_Guarding_P1_Push_Face__c,
                                                           Pleasant_Touch__c,
                                                           Play_Test_Tug_P2__c,
                                                           Play_Test_Tug_P1__c,
                                                           Opposite_Sex_P3__c,
                                                           Opposite_Sex_P2__c,
                                                           Behavior_on_Leash__c,
                                                           Opposite_Sex_P1__c,
                                                           Behavior_in_Kennel__c,
                                                           Fake_Dog__c,
                                                           Potential_Behavior_Issues__c,
                                                           Puppy_Resource_Guarding_P2_Touch_Neck__c,
                                                           Puppy_Resource_Guarding_P2_Touch_Face__c,
                                                           Puppy_Resource_Guarding_P2_Touch_Body__c,
                                                           Puppy_Social_Behavior_P1__c,
                                                           Puppy_Resource_Guarding_P2_Push_Face__c,
                                                           Puppy_Resource_Guarding_P1_Touch_Neck__c,
                                                           Puppy_Resource_Guarding_P1_Touch_Face__c,
                                                           Puppy_Resource_Guarding_P1_Touch_Body__c,
                                                           Puppy_Resource_Guarding_P1_Push_Face__c,
                                                           Puppy_Play_Tug_P2__c,
                                                           Puppy_Play_Tug_P1__c,
                                                           Puppy_Child_Doll_P1__c,
                                                           Puppy_Child_Doll_P2__c,
                                                           Puppy_Behavior_on_Leash__c,
                                                           Puppy_Behavior_in_Kennel__c,
                                                           Skipped_UT_2nd__c,
                                                           Skipped_UT_1st__c,
                                                           Skipped_Tag__c,
                                                           Skipped_TD_P2__c,
                                                           Skipped_TD_P1__c,
                                                           Skipped_SSD_P3__c,
                                                           Skipped_SSD_P2__c,
                                                           Skipped_SSD_P1__c,
                                                           Skipped_SP_P2__c,
                                                           Skipped_SP_P1__c,
                                                           Skipped_SB_P2__c,
                                                           Skipped_SB_P1__c,
                                                           Skipped_RG_P2__c,
                                                           Skipped_RG_P2_TN__c,
                                                           Skipped_RG_P2_TF__c,
                                                           Skipped_RG_P2_TB__c,
                                                           Skipped_RG_P2_PF__c,
                                                           Skipped_RG_P1__c,
                                                           Skipped_RG_P1_TN__c,
                                                           Skipped_RG_P1_TF__c,
                                                           Skipped_RG_P1_TB__c,
                                                           Skipped_RG_P1_PF__c,
                                                           Skipped_Pleasant__c,
                                                           Skipped_Pleasant_Touch__c,
                                                           Skipped_Play_Tug_P2__c,
                                                           Skipped_Play_Tug_P1__c,
                                                           Skipped_OSD_P3__c,
                                                           Skipped_OSD_P2__c,
                                                           Skipped_OSD_P1__c,
                                                           Skipped_FD__c,
                                                           Skipped_BOL__c,
                                                           Skipped_BIK__c,
                                                           Social_Behavior_Test_P1__c,
                                                           Social_Behavior_P2__c,
                                                           Pleasant_Touch_Test__c,
                                                           Play_Test_P2__c,
                                                           Play_Test_P1__c,
                                                           Puppy_Skipped_Restraint__c,                                                                                                                                                                                                                                                                                              
                                                                                     
                                                           Puppy_Skipped_DI_P3__c,
                                                           Puppy_Skipped_DI_P2__c,
                                                           Puppy_Skipped_DI_P1__c,
                                                           Puppy_Skipped_CD_P2__c,
                                                                                                        
                                                           Puppy_BIK_Housing__c,
                                                           Potential_Issue_Aggression_To_People__c,
                                                           Potential_Issue_Aggression_To_Animals__c,
                                                           Potential_Issue_Fear__c,
                                                           Potential_Issue_High_Arousal__c,
                                                           Potential_Issue_Other__c,
                                                           Potential_Issue_Other_Notes__c,
                                                           Animal__r.Placement_Recommendations__c,
                                                           Animal__r.Age__c
                                                           FROM Behavior_Evaluation__c
                                                           WHERE Animal__r.ID = : animalId  Order by Name  DESC LIMIT 10];
            
            List<BehaviorEvaluation> behaviorEvaluations = new List<BehaviorEvaluation>();
            Set<Id> behvIds = new Set<Id>();
          
            
            for (Behavior_Evaluation__c behV : behEvaluations) {
                behvIds.add(behV.Id);
                evaluation = new List<EvaluationGroup>();
                finalTestAndDisplayValues = new List<List<String>>();
                finalTestAndDisplayValues = getBehaviorEvaluationMatrix(behV);
                evaluation = getEvaluation(behV);
                BehaviorEvaluation  behvEval = new BehaviorEvaluation();
                behvEval.Id = behV.Id;
                behvEval.AnimalName = behV.Animal_Name__c;
                behvEval.AnimalID =  behV.Animal_ID__c ;
                behvEval.AnimalAge = behV.Animal__r.Age__c;
                behvEval.AnimalBreed = behV.Animal_Breed__c;
                behvEval.AnimalColor = behV.Animal_Color__c;
                behvEval.AnimalSex = behV.Animal_Sex__c;
                behvEval.AnimalEvaluationDate = behV.createdDate;
                behvEval.AnimalCaseNumber =  behV.Case_Number__c;
                behvEval.AnimalFacilityOutcome = behV.Facility_Outcome__c;
                behvEval.AnimalOverallEvaluationGrade =  behV.Overall_Evaluation_Grade__c;
                behvEval.AnimalSummary = behV.Behavior_Evaluation_Summary__c;
                behvEval.CurrentShelterLocation = behV.Animal__r.Current_Recent_Shelter_Location__c;
                
                //behvEval.GradeHistories = animalGradeHistory(behV.Id);
                behvEval.AnimalTesterInitials =  behV.Tester_Initials__c;
                behvEval.AnimalEvaluationSubtype = behV.Evaluation_Subtype__c;
                behvEval.AnimalScribeInitials =  behV.Scribe_Initials__c;
                behvEval.BehaviorTestAndDisplayValues =  finalTestAndDisplayValues;
                behvEval.Behaviorevaluation = evaluation;
                behvEval.PotentialIssueAggressionToPeople = behV.Potential_Issue_Aggression_To_People__c;
                behvEval.PotentialIssueAggressionToAnimals = behV.Potential_Issue_Aggression_To_Animals__c;
                behvEval.PotentialIssueFear = behV.Potential_Issue_Fear__c;
                behvEval.PotentialIssueHighArousal = behV.Potential_Issue_High_Arousal__c;
                behvEval.PotentialIssueOther = behV.Potential_Issue_Other__c;
                behvEval.PotentialIssueOtherNotes = behV.Potential_Issue_Other_Notes__c;
                behvEval.PlacementRecommendations = behV.Animal__r.Placement_Recommendations__c;
                behaviorEvaluations.add(behvEval);
            }
			GradeHistories = new List<AnimalGradeHistory>();
            GradeHistories = animalGradeHistory(behvIds);
            return behaviorEvaluations;
        }
        private set;
    }
    
    private List<List<String>> getBehaviorEvaluationMatrix(Behavior_Evaluation__c behaviorEvaluation){
        
        //Create map of field names and their corresponding values
        fieldsToValue = behaviorEvaluation.getPopulatedFieldsAsMap();
        testAndValues = new Map<String,Set<Integer>>(); //Map to collect subtest names and corresponding behaviors
        testAndDisplayValues = new Map<String,List<String>>(); //Temp Map to collect subtest names and corresponding categories in correct order
        testOrder = new Map<Integer,String>(); //Map to order tests
        //Map of ordered subtests along with categories
        for (String fieldName : fieldsToValue.keySet()){
            //System.debug('field name is ' + fieldName + ', value is ' + fieldsToValue.get(fieldName));
            //Assign field values to behaviors String
            String behaviors = String.valueOf(fieldsToValue.get(fieldName));
            String skipped = '❌';
            String notNecessary = '---';
            //system.debug(behaviors);
            //Iterate through Skipped fields to pull out skip reason
            if (fieldName.contains('Skipped')){
                List<Test_Config__mdt> testConfigSkip;
                switch on behaviorEvaluation.Evaluation_SubType__c {
                    when 'Puppy' {
                        testConfigSkip = [SELECT Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                          WHERE Test_Skip_Reason_Field__c = :fieldName AND IsPuppy__c = true LIMIT 1];
                    }
                    when 'Adult Animal' {
                        testConfigSkip = [SELECT Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                          WHERE Test_Skip_Reason_Field__c = :fieldName AND IsAdult__c = true LIMIT 1];
                    }
                    when 'Dog Fighting' {
                        testConfigSkip = [SELECT Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                          WHERE Test_Skip_Reason_Field__c = :fieldName AND IsDogFighting__c = true LIMIT 1];
                    }
                    when 'Dog/Dog Only' {
                        testConfigSkip = [SELECT Test_Name__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                          WHERE Test_Skip_Reason_Field__c = :fieldName AND IsDogOnly__c = true LIMIT 1];
                    }
                }
                for (Test_Config__mdt testMetadata : testConfigSkip){
                    String testName = '';
                    if (testMetadata.Overall_Test_Display_Name__c != null){
                        testName = testMetadata.Overall_Test_Display_Name__c;
                    }
                    else{
                        testName = testMetadata.Test_Name__c;
                    }
                    
                    if(behaviors.contains('not necessary') || behaviors.contains('appropriate helper dog')){
                        testAndDisplayValues.put(testName, new List<String>{'---','---','---','---'});
                    } else{
                        testAndDisplayValues.put(testName, new List<String>{'❌','❌','❌','❌'});
                    }
                    
                }
                //system.debug('WITHIN SKIPPED IF: ' + testAndDisplayValues);
            }
            else{
                //system.debug('AFTER SKIPPED IF: ' + testAndDisplayValues);
                //Split values for multi-select picklist fields and assign to array
                List<String> behArray = behaviors.split(';');
                //Iterate through array to categorize each selection into a numeric value, based on Value Category
                for (String beh : behArray){      
                    for (Picklist_Description_Config__mdt picklistMetadata : [SELECT Test_Config__r.MasterLabel,Test_Config__r.Test_Name__c,Field_API_Name__c,Value_Category__c,Field_Value__c FROM
                                                                              Picklist_Description_Config__mdt
                                                                              WHERE Field_API_Name__c = :fieldName AND Field_Value__c = :beh LIMIT 1 ]){
                                                                                  //Assign Value Category String value to Integer
                                                                                  Integer valueCategory = Integer.valueOf(picklistMetadata.Value_Category__c);
                                                                                  
                                                                                  //If testAndValues map does not contain current subtest, create new key-value set for Subtest name and Value Category
                                                                                  if(!testAndValues.containsKey(picklistMetadata.Test_Config__r.Test_Name__c)){
                                                                                      testAndValues.put(picklistMetadata.Test_Config__r.Test_Name__c, new Set<Integer>{valueCategory});
                                                                                  }
                                                                                  //If testAndValues map already contains current subtest, add Value Category to the corresponding key
                                                                                  else{
                                                                                      testAndValues.get(picklistMetadata.Test_Config__r.Test_Name__c).add(valueCategory);
                                                                                      
                                                                                  }
                                                                                  //system.debug('MAP SIZE AFTER INSERT '+ testAndValues.size());   
                                                                              }
                    
                }
            }
        } //END OF FOR LOOP
        
        //Iterate through Value Category Set in testAndValues Map and assign a category to each column, by adding them to a List
        //Categories: 1=Not Concerning, 2=Red Flag, 3=Alert, 4=Inconclusive
        for (String subtest : testAndValues.keySet()){
            for (Integer i = 0; i < 4; i++){
                if(!testAndDisplayValues.containsKey(subtest)){
                    testAndDisplayValues.put(subtest, new List<String>{});
                }
                //If subtest includes behavior in current category, display checkbox; else display blank
                if (testAndValues.get(subtest).contains(i+1)){
                    testAndDisplayValues.get(subtest).add('✔');
                }
                else{
                    testAndDisplayValues.get(subtest).add(' '); 
                }
                
            }
            
        } 
        // Iterate through subtests in testAndDisplayMap and order by Test_Display_Order__c
        // Add subtest and order combinations into testOrder Map
        for (String subtest : testAndDisplayValues.keySet()){
            List<Test_Config__mdt> testMetadata;
            switch on behaviorEvaluation.Evaluation_SubType__c {
                when 'Puppy' {
                    testMetadata = [SELECT Test_Display_Order__c,Test_Name__c FROM Test_Config__mdt
                                    WHERE Test_Name__c = :subtest AND IsPuppy__c = true LIMIT 1];
                }
                when 'Adult Animal' {
                    testMetadata = [SELECT Test_Display_Order__c,Test_Name__c FROM Test_Config__mdt
                                    WHERE Test_Name__c = :subtest AND IsAdult__c = true LIMIT 1];
                }
                when 'Dog Fighting' {
                    testMetadata = [SELECT Test_Display_Order__c,Test_Name__c FROM Test_Config__mdt
                                    WHERE Test_Name__c = :subtest AND IsDogFighting__c = true LIMIT 1];
                }
                when 'Dog/Dog Only' {
                    testMetadata = [SELECT Test_Display_Order__c,Test_Name__c FROM Test_Config__mdt
                                    WHERE Test_Name__c = :subtest AND IsDogOnly__c = true LIMIT 1];
                }
            }
            if(testMetadata.size() != 0){
                testOrder.put(Integer.valueOf(testMetadata[0].Test_Display_Order__c), testMetadata[0].Test_Name__c);
            }
            else{
                List<Test_Config__mdt> overallTestMetadata;
                switch on behaviorEvaluation.Evaluation_SubType__c {
                    when 'Puppy' {
                        overallTestMetadata = [SELECT Test_Display_Order__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                               WHERE Overall_Test_Display_Name__c = :subtest AND IsPuppy__c = true LIMIT 1];
                    }
                    when 'Adult Animal' {
                        overallTestMetadata = [SELECT Test_Display_Order__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                               WHERE Overall_Test_Display_Name__c = :subtest AND IsAdult__c = true LIMIT 1];
                    }
                    when 'Dog Fighting' {
                        overallTestMetadata = [SELECT Test_Display_Order__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                               WHERE Overall_Test_Display_Name__c = :subtest AND IsDogFighting__c = true LIMIT 1];
                    }
                    when 'Dog/Dog Only' {
                        overallTestMetadata = [SELECT Test_Display_Order__c,Overall_Test_Display_Name__c FROM Test_Config__mdt
                                               WHERE Overall_Test_Display_Name__c = :subtest AND IsDogOnly__c = true LIMIT 1];
                    }
                }
                if(overallTestMetadata.size() != 0) {
                    testOrder.put(Integer.valueOf(overallTestMetadata[0].Test_Display_Order__c), overallTestMetadata[0].Overall_Test_Display_Name__c);
                }
            }
            
        }
        //Order testAndDisplayValues map using testOrder, and adds test name and string list to finalTestAndDisplayValues list of lists
        List<Integer> aList = new List<Integer>();
        aList.addAll(testOrder.keySet());
        aList.sort();
        
        for(Integer a: aList)
        {
            for (String subtestList : testAndDisplayValues.keySet()){
                if (testOrder.get(a) == subtestList){
                    List<String> testList = new List<String>();
                    testList.add(subtestList);
                    testList.addAll(testAndDisplayValues.get(subtestList));
                    finalTestAndDisplayValues.add(testList);
                }  
            }
        }
        return finalTestAndDisplayValues;
    }
    
    private List<EvaluationGroup> getEvaluation(Behavior_Evaluation__c behEval){
        if(behEval.Potential_Behavior_Issues__c != null){
            potentBehIssue = behEval.Potential_Behavior_Issues__c.split(';');
        }
        
        summary = behEval.Behavior_Evaluation_Summary__c;
        if (paramForensic != null && paramForensic == true) {
            //remove same sex and opposite sex entries
            Integer sameStart = summary.indexOf('<p><b>Same Sex');
            if (sameStart != -1) {
                Integer sameEnd = summary.indexOf('</p>', sameStart);
                summary = summary.substring(0, sameStart) + summary.substring(sameEnd + 4);
            }
            Integer oppositeStart = summary.indexOf('<p><b>Opposite Sex');
            if (oppositeStart != -1) {
                Integer oppositeEnd = summary.indexOf('</p>', oppositeStart);
                summary = summary.substring(0, oppositeStart) + summary.substring(oppositeEnd + 4);
            }
        }
        List<Test_Config__mdt> testConfigMetadata;
        switch on behEval.Evaluation_SubType__c {
            when 'Puppy' {
                testConfigMetadata = [SELECT MasterLabel, Test_Display_Order__c, Test_Name__c, Test_Description__c, IsPuppy__c, IsAdult__c, IsDogFighting__c, IsDogOnly__c,
                                      Test_Header_Description__c, Test_Type_Description__c, Test_Optional_Field__c, Test_Skip_Reason_Field__c, Test_Comment_Field_Name__c,
                                      (SELECT Field_API_Name__c,Picklist_Order__c,Value_Category__c,Field_Value__c, Field_Description__c
                                       FROM Picklist_Description_Configs__r)
                                      FROM Test_Config__mdt
                                      WHERE IsPuppy__c = true
                                      AND Test_Name__c != null];
            }
            when 'Adult Animal' {
                testConfigMetadata = [SELECT MasterLabel, Test_Display_Order__c, Test_Name__c, Test_Description__c, IsPuppy__c, IsAdult__c, IsDogFighting__c, IsDogOnly__c,
                                      Test_Header_Description__c, Test_Type_Description__c, Test_Optional_Field__c, Test_Skip_Reason_Field__c, Test_Comment_Field_Name__c,
                                      (SELECT Field_API_Name__c,Picklist_Order__c,Value_Category__c,Field_Value__c, Field_Description__c
                                       FROM Picklist_Description_Configs__r)
                                      FROM Test_Config__mdt
                                      WHERE IsAdult__c = true
                                      AND Test_Name__c != null];
            }
            when 'Dog Fighting' {
                testConfigMetadata = [SELECT MasterLabel, Test_Display_Order__c, Test_Name__c, Test_Description__c, IsPuppy__c, IsAdult__c, IsDogFighting__c, IsDogOnly__c,
                                      Test_Header_Description__c, Test_Type_Description__c, Test_Optional_Field__c, Test_Skip_Reason_Field__c, Test_Comment_Field_Name__c,
                                      (SELECT Field_API_Name__c,Picklist_Order__c,Value_Category__c,Field_Value__c, Field_Description__c
                                       FROM Picklist_Description_Configs__r)
                                      FROM Test_Config__mdt
                                      WHERE IsDogFighting__c = true
                                      AND Test_Name__c != null];
            }
            when 'Dog/Dog Only' {
                testConfigMetadata = [SELECT MasterLabel, Test_Display_Order__c, Test_Name__c, Test_Description__c, IsPuppy__c, IsAdult__c, IsDogFighting__c, IsDogOnly__c,
                                      Test_Header_Description__c, Test_Type_Description__c, Test_Optional_Field__c, Test_Skip_Reason_Field__c, Test_Comment_Field_Name__c,
                                      (SELECT Field_API_Name__c,Picklist_Order__c,Value_Category__c,Field_Value__c, Field_Description__c
                                       FROM Picklist_Description_Configs__r)
                                      FROM Test_Config__mdt
                                      WHERE IsDogOnly__c = true
                                      AND Test_Name__c != null];
            }
        }
        
        //Get field data mapping to add selected item descriptions
        Map<String, Object> evalFields = behEval.getPopulatedFieldsAsMap();
        Set<String> testGroup = new Set<String>();
        Map<String, EvaluationGroup> evaluationMap = new Map<String, EvaluationGroup>();
        if(testConfigMetadata != null){
            for (Test_Config__mdt config : testConfigMetadata) {
            //Ignore tabs for forensic use
            if (paramForensic != null && paramForensic == true) {
                if (config.Test_Name__c.startsWith('Same Sex') || config.Test_Name__c.startsWith('Opposite Sex')) {
                    continue;
                }
            }
            List<ValueGroup> vGroup = new List<ValueGroup>();
            Map<String, ValueGroup> valueMap = new Map<String, ValueGroup>();
            for (Picklist_Description_Config__mdt pick : config.Picklist_Description_Configs__r) {
                //Gather selected items per tab by comparing the defined metadata value to the actual field value
                FieldGroup fGroup = new FieldGroup();
                fGroup.fieldOrder = Integer.valueOf(pick.Picklist_Order__c);
                String testNameType = config.Test_Name__c;
                if (testNameType.contains(' - ')) {
                    fGroup.fieldTypeOrder = Integer.valueOf(config.Test_Display_Order__c);
                    fGroup.fieldType = testNameType.substringAfterLast(' - ');
                    fGroup.fieldTypeDescription = config.Test_Type_Description__c;
                }
                if (evalFields.get(pick.Field_API_Name__c) != null && String.valueOf(evalFields.get(pick.Field_API_Name__c)).contains(pick.Field_Value__c)) {
                    fGroup.isSelected = true;
                }
                else {
                    fGroup.isSelected = false;
                }
                if (valueMap.containsKey(pick.Field_Value__c)) {
                    valueMap.get(pick.Field_Value__c).fields.add(fGroup);
                    valueMap.get(pick.Field_Value__c).fields.sort();
                }
                else {
                    valueMap.put(pick.Field_Value__c, new ValueGroup(Integer.valueOf(pick.Value_Category__c), Integer.valueOf(pick.Picklist_Order__c), pick.Field_Value__c, pick.Field_Description__c, new List<FieldGroup> {fGroup}));
                }
            }
            if (evaluationMap.containsKey(config.Test_Description__c)) {
                vGroup = valueMap.values();
                vGroup.sort();
                for (ValueGroup v : vGroup) {
                    switch on v.valueCategory {
                        when 0 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup0) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                        when 1 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup1) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                        when 2 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup2) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                        when 3 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup3) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                        when 4 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup4) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            else {
                vGroup = valueMap.values();
                vGroup.sort();
                List<ValueGroup> vG0 = new List<ValueGroup>();
                List<ValueGroup> vG1 = new List<ValueGroup>();
                List<ValueGroup> vG2 = new List<ValueGroup>();
                List<ValueGroup> vG3 = new List<ValueGroup>();
                List<ValueGroup> vG4 = new List<ValueGroup>();
                for (ValueGroup v : vGroup) {
                    switch on v.valueCategory {
                        when 0 {
                            vG0.add(v);
                        }
                        when 1 {
                            vG1.add(v);
                        }
                        when 2 {
                            vG2.add(v);
                        }
                        when 3 {
                            vG3.add(v);
                        }
                        when 4 {
                            vG4.add(v);
                        }
                    }
                }
                OptionalField opField = new OptionalField();
                if (!String.isBlank(config.Test_Optional_Field__c)) {
                    Object optionalValue = evalFields.get(config.Test_Optional_Field__c);
                    if (optionalValue instanceof Boolean) {
                        opField.selectedValue = getMuzzled((Boolean)optionalValue);
                        opField.availableValues = new List<String>{'Muzzled', 'Not Muzzled'};
                            }
                    else {
                        //picklist
                        opField.selectedValue = (String)optionalValue;
                        opField.availableValues = new List<String>();
                        List<PicklistEntry> optValues = Behavior_Evaluation__c.getSObjectType().getDescribe().fields.getMap().get(config.Test_Optional_Field__c).getDescribe().getPicklistValues();
                        for (PicklistEntry p : optValues) {
                            opField.availableValues.add(p.getLabel());
                        }
                    }
                }
                evaluationMap.put(config.Test_Description__c, new EvaluationGroup(Integer.valueOf(config.Test_Display_Order__c), config.Test_Description__c, config.Test_Header_Description__c, /*config.Test_Type_Description__c, */opField, (String)evalFields.get(config.Test_Skip_Reason_Field__c), (String)evalFields.get(config.Test_Comment_Field_Name__c), vG0, vG1, vG2, vG3, vG4));
            }
        }
    	}
        evaluation = evaluationMap.values();
        //sort tab group data
        evaluation.sort();
        return evaluation;
    }

    Private List<AnimalGradeHistory> animalGradeHistory(Set<Id> behavIds){
        String query = 'SELECT Id, RecordName__c, CreatedDate, CreatedBy.Name, FieldName__c, NewValue__c, OldValue__c, ObjectId__c, ObjectName__c FROM EntityHistory__c';
        String behaviorIds = '';
        List<SObject> results = new List<SObject>();
        for(String s : behavIds){
            behaviorIds += '\''+s+'\',';
        }
        behaviorIds = behaviorIds.removeEnd(',');
        //behaviorIds += ')';
        System.debug(behaviorIds);
        if(String.isBlank(behaviorIds)){
            behaviorIds = '\'\'';
        }
        
        List<AnimalGradeHistory> animalHistories = new List<AnimalGradeHistory>();
        if ( animalId != null && animalId != '' ) {
            query += ' WHERE ParentId__c = \''+animalId+'\'';
            query += ' AND ObjectId__c IN ('+behaviorIds+')';
            query += ' Order by RecordName__c,CreatedDate';
            system.debug(query);
            results = Database.query( query );
        }
        
        for(Integer i = 0; i < results.size();i++){
            AnimalGradeHistory agh = new AnimalGradeHistory();
            agh.historyDate = DateTime.valueOf(results[i].get('CreatedDate'));
            agh.historyName = String.valueOf(results[i].get('NewValue__c'));
            agh.historyId = String.valueOf(results[i].get('ObjectId__c'));
            if(String.valueof(results[i].get('RecordName__c')) == String.valueof(results[i+1].get('RecordName__c'))){
                agh.historyReason = String.valueof(results[i+1].get('NewValue__c'));
                i=i+1;
            }
            animalHistories.add(agh);
        }
        return animalHistories;
    }
    
    public String getMuzzled(Boolean val) {
        if (val) {
            return 'Muzzled';
        }
        else {
            return 'Not Muzzled';
        }
    }
    public class EvaluationGroup implements Comparable {
        public Integer groupOrder { get; set; }
        public String groupValue { get; set; }
        public String headerValue { get; set; }
        public OptionalField optionalValue { get; set; }
        public String skipValue { get; set; }
        public String commentValue { get; set; }
        public List<ValueGroup> valueGroup0 { get; set; }
        public List<ValueGroup> valueGroup1 { get; set; }
        public List<ValueGroup> valueGroup2 { get; set; }
        public List<ValueGroup> valueGroup3 { get; set; }
        public List<ValueGroup> valueGroup4 { get; set; }
        public Boolean hasGroup0 {
            get {
                return this.valueGroup0.size() > 0;
            }
            private set;
        }
        public Boolean hasGroup1 {
            get {
                return this.valueGroup1.size() > 0;
            }
            private set;
        }
        public Boolean hasGroup2 {
            get {
                return this.valueGroup2.size() > 0;
            }
            private set;
        }
        public Boolean hasGroup3 {
            get {
                return this.valueGroup3.size() > 0;
            }
            private set;
        }
        public Boolean hasGroup4 {
            get {
                return this.valueGroup4.size() > 0;
            }
            private set;
        }
        public Boolean hasFieldTypes {
            get {
                if (this.valueGroup1 != null && this.valueGroup1.size() > 0) {
                    if (this.valueGroup1[0].fields != null && this.valueGroup1[0].fields.size() > 0) {
                        return !String.isEmpty(this.valueGroup1[0].fields[0].fieldType);
                    }
                    else {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
            private set;
        }
        public EvaluationGroup() {}
        public EvaluationGroup(Integer groupOrder, String groupValue, String headerValue, OptionalField optionalValue, String skipValue, String commentValue, List<ValueGroup> valueGroup0, List<ValueGroup> valueGroup1, List<ValueGroup> valueGroup2, List<ValueGroup> valueGroup3, List<ValueGroup> valueGroup4) {
            this.groupOrder = groupOrder;
            this.groupValue = groupValue;
            this.headerValue = headerValue;
            this.optionalValue = optionalValue;
            this.skipValue = skipValue;
            this.commentValue = commentValue;
            this.valueGroup0 = valueGroup0;
            this.valueGroup1 = valueGroup1;
            this.valueGroup2 = valueGroup2;
            this.valueGroup3 = valueGroup3;
            this.valueGroup4 = valueGroup4;
        }
        public Integer compareTo(Object compare) {
            EvaluationGroup eval = (EvaluationGroup)compare;
            Integer returnValue = 0;
            if (this.groupOrder > eval.groupOrder) {
                returnValue = 1;
            }
            else if (this.groupOrder < eval.groupOrder) {
                returnValue = -1;
            }
            return returnValue;
        }
    }
    public class OptionalField {
        public String selectedValue { get; set; }
        public List<String> availableValues { get; set; }
        public OptionalField() {}
        public OptionalField(String selectedValue, List<String> availableValues) {
            this.selectedValue = selectedValue;
            this.availableValues = availableValues;
        }
    }
    public class ValueGroup implements Comparable {
        public Integer valueCategory { get; set; }
        public Integer fieldOrder { get; set; }
        public String fieldValue { get; set; }
        public String fieldDescription { get; set; }
        public List<FieldGroup> fields { get; set; }
        public ValueGroup() {}
        public ValueGroup(Integer valueCategory, Integer fieldOrder, String fieldValue, String fieldDescription, List<FieldGroup> fields) {
            this.valueCategory = valueCategory;
            this.fieldOrder = fieldOrder;
            this.fieldValue = fieldValue;
            this.fieldDescription = fieldDescription;
            this.fields = fields;
        }
        public Integer compareTo(Object compare) {
            ValueGroup valGroup = (ValueGroup)compare;
            Integer returnValue = 0;
            if (this.valueCategory > valGroup.valueCategory) {
                returnValue = 1;
            }
            else if (this.valueCategory < valGroup.valueCategory) {
                returnValue = -1;
            }
            else if (this.fieldOrder > valGroup.fieldOrder) {
                returnValue = 1;
            }
            else if (this.fieldOrder < valGroup.fieldOrder) {
                returnValue = -1;
            }
            return returnValue;
        }
    }
    public class FieldGroup implements Comparable {
        public Integer fieldOrder { get; set; }
        public Boolean isSelected { get; set; }
        public Integer fieldTypeOrder { get; set; }
        public String fieldType { get; set; }
        public String fieldTypeDescription { get; set; }
        public FieldGroup() {}
        public FieldGroup(Integer fieldOrder, Boolean isSelected, Integer fieldTypeOrder, String fieldType, String fieldTypeDescription) {
            this.fieldOrder = fieldOrder;
            this.isSelected = isSelected;
            this.fieldTypeOrder = fieldTypeOrder;
            this.fieldType = fieldType;
            this.fieldTypeDescription = fieldTypeDescription;
        }
        public Integer compareTo(Object compare) {
            FieldGroup pick = (FieldGroup)compare;
            Integer returnValue = 0;
            if (this.fieldOrder > pick.fieldOrder) {
                returnValue = 1;
            }
            else if (this.fieldOrder < pick.fieldOrder) {
                returnValue = -1;
            }
            else if (this.fieldTypeOrder > pick.fieldTypeOrder) {
                returnValue = 1;
            }
            else if (this.fieldTypeOrder < pick.fieldTypeOrder) {
                returnValue = -1;
            }
            return returnValue;
        }
    }
    public class AnimalGradeHistory {
        public datetime historyDate {get; set;}
        public string historyId {get; set;}
        public string historyName {get; set;}
        public string historyReason {get; set;}
    } 
    public class animalPlaySummary {
        public String Id { get; set; }
        public String playRating { get; set; }
        public List<String> playGroupIndividualNotes { get; set; }
        public List<String> animalNames { get; set; }
        public String playSessionId { get; set; }
        public List<String> playLocation { get; set; }
        public List<String> playSessionNotes { get; set; }
        public String playSessionDate { get; set; }
    }
    
    Public Class BehaviorEvaluation {
        Public string Id {get;set;}
        Public string AnimalName {get;set;}
        Public string AnimalID {get;set;}
        Public string AnimalAge {get;set;}
        Public string AnimalBreed{get;set;}
        Public string AnimalColor {get;set;}
        Public string AnimalSex {get;set;}
        Public DateTime AnimalEvaluationDate {get;set;}
        Public string AnimalCaseNumber {get;set;}
        Public string AnimalFacilityOutcome {get;set;}
        Public string AnimalOverallEvaluationGrade {get;set;}
        Public string AnimalSummary {get;set;}
        Public string CurrentShelterLocation {get;set;}
        Public List<AnimalGradeHistory> GradeHistories {get;set;}
        Public string AnimalTesterInitials {get;set;}
        Public string AnimalEvaluationSubtype {get;set;}
        Public string AnimalScribeInitials {get;set;}
        public List<List<String>> BehaviorTestAndDisplayValues {get;set;}
        Public List<EvaluationGroup> Behaviorevaluation { get; set; }
        Public string PotentialIssueAggressionToPeople { get; set; }
        Public string PotentialIssueAggressionToAnimals { get; set; }
        Public string PotentialIssueFear { get; set; }
        Public string PotentialIssueHighArousal { get; set; }
        Public string PotentialIssueOther { get; set; }
        Public string PotentialIssueOtherNotes { get; set; }
        Public string PlacementRecommendations { get; set; }
    }
}