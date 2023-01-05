public with sharing class TreatmentsByDogPDFController {
    public DogInfoWrapper[] dogInfoWrapperList {get; set;}
    public String dogList{get;set;}
    public Boolean isCRCApp{get;set;}

    public TreatmentsByDogPDFController(){        
        dogList = apexpages.currentpage().getparameters().get('dogList');
        isCRCApp = apexpages.currentpage().getparameters().get('appName') == 'CRC Dog Database';
        Id[] dogList = dogList.split(',');
        System.debug('dogList: ' + dogList);
        dogInfoWrapperList = getDogInfo(dogList, isCRCApp);
    }

    @testVisible
    private static DogInfoWrapper[] getDogInfo(Id[] dogIds, Boolean isCRCApp){
        //if is not CRC no need to get medications
        Map<Id, Set<String>>  medicationsByDogMap = new Map<Id, Set<String>>();
        if(isCRCApp){
            medicationsByDogMap = getDogMedications(dogIds);
        }

        DogInfoWrapper[] dogInfos = new DogInfoWrapper[0];
        Map<Id, Map<String, TxProtocolWrapper>> treatmentsByDogMap = getDogTreatments(dogIds);

        for(Animal__c dog : [
            SELECT Id, Animal_Name_Id__c, Gender__c, Breed__c, Current_Animal_Age_Formatted__c, Current_Location__c, 
            Current_Behavior_Grade__c,
            (SELECT Id, Treatment_Priority__c FROM Treatment_Plan__r WHERE IsActive__c = true LIMIT 1)
            FROM Animal__c 
            WHERE Id IN: dogIds 
        ]){
            DogInfoWrapper dogInfo = new DogInfoWrapper(dog);

            if(medicationsByDogMap.containsKey(dog.Id)){
                dogInfo.medications = string.join(new List<String>(medicationsByDogMap.get(dog.Id)), '; ');
            }

            if(treatmentsByDogMap.containsKey(dog.Id)){
                Map<String, TxProtocolWrapper> dogTreatments = treatmentsByDogMap.get(dog.Id);
                dogInfo.txProtocols = dogTreatments.values();
            }            
            dogInfos.add(dogInfo);
        }
        return dogInfos;
    }    

    @testVisible
    private static Map<Id, Set<String>> getDogMedications(Id[] dogIds){
        Map<Id, Set<String>> dogToMedicationMap = new Map<Id, Set<String>>();
        Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.TREATMENT_TASK_RECORD_TYPE_NAME);

        for(Task t : [
            SELECT Id, Medication__r.Name, Animal__c 
            FROM Task 
            WHERE RecordTypeId =: recordTypeId
            AND Animal__c IN: dogIds
            AND Medication__r.Behavior_Medication__c = true
            AND Status != 'Completed'
            AND ((IsRecurrence = true AND RecurrenceEndDateOnly >= TODAY)
            OR (RecurrenceActivityId = null AND ActivityDate >= TODAY))

        ]){
            if(dogToMedicationMap.containsKey(t.Animal__c)){
                dogToMedicationMap.get(t.Animal__c).add(t.Medication__r.Name);
            } else {
                dogToMedicationMap.put(t.Animal__c, new Set<String>{t.Medication__r.Name});
            }
        }

        return dogToMedicationMap;
    }

    @testVisible
    private static Map<Id, Map<String, TxProtocolWrapper>> getDogTreatments(Id[] dogIds){
        Map<Id, Map<String, TxProtocolWrapper>> m_dogToProtocols = new Map<Id, Map<String, TxProtocolWrapper>>();
               
        Session_Protocol__c[] sessionProtocols = getSessionProtocols (dogIds);
        for(Session_Protocol__c sp : sessionProtocols){
            Map<String, TxProtocolWrapper> m_protocols = new Map<String, TxProtocolWrapper>();
            if(m_dogToProtocols.containsKey(sp.TreatmentSessionId__r.Animal__c)){
                m_protocols = m_dogToProtocols.get(sp.TreatmentSessionId__r.Animal__c);
            }

            TreatmentWrapper treatment = new TreatmentWrapper(sp);

            if(m_protocols.containsKey(sp.Protocol_Name__c)){
                m_protocols.get(sp.Protocol_Name__c).sessionProtocols.add(treatment);
            }
            else{
                TxProtocolWrapper protoWrapper = new TxProtocolWrapper(sp);
                protowrapper.sessionProtocols.add(treatment);
                m_protocols.put(sp.Protocol_Name__c, protoWrapper);
            }
            m_dogToProtocols.put(sp.TreatmentSessionId__r.Animal__c, m_protocols);
        }
        return m_dogToProtocols;
    }

     private static Session_Protocol__c[] getSessionProtocols(Id[] dogIds){
        return [
            SELECT Id, Protocol_Name__c, isRemoved__c, Overall_Score__c, Overall_Score_Number__c, Overall_Score_Color__c, TreatmentSessionId__r.Treatment_Plan__c,
            TreatmentSessionId__c, TreatmentSessionId__r.Session_Date__c, ProtocolId__c, ProtocolId__r.Protocol_Categories__c, TreatmentSessionId__r.Animal__c,
            TreatmentSessionId__r.Treatment_Plan__r.IsActive__c,Protocol_Notes__c,
            (SELECT Id, Protocol_Scale_Name__c,Protocol_Score__c FROM Session_Protocol_Scales__r)
            FROM Session_Protocol__c
            WHERE TreatmentSessionId__r.Animal__c IN :dogIds
            AND Overall_Score__c != null
            ORDER BY ProtocolId__r.Protocol_Categories__c ASC, Protocol_Name__c ASC, TreatmentSessionId__r.Session_Date__c DESC
        ];
    }

    public class DogInfoWrapper{
        @AuraEnabled public Id id {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String gender {get;set;}
        @AuraEnabled public String breed {get;set;}
        @AuraEnabled public String age {get;set;}
        @AuraEnabled public String location {get;set;}
        @AuraEnabled public String evalGrade {get;set;}
        @AuraEnabled public String txPriority {get;set;}
        @AuraEnabled public String medications {get;set;}
        @AuraEnabled public Boolean hideMedications {get;set;}

        @AuraEnabled public TxProtocolWrapper[] txProtocols {get;set;}
        
        public DogInfoWrapper(Animal__c dog){
            User u = [SELECT Id, Location__c FROM User WHERE Id = :userInfo.getUserId() LIMIT 1];
            
            this.id = dog.Id;
            this.name = dog.Animal_Name_Id__c;
            this.gender = dog.Gender__c;
            this.breed = dog.Breed__c;
            this.age = dog.Current_Animal_Age_Formatted__c;
            this.location = dog.Current_Location__c;
            this.evalGrade = dog.Current_Behavior_Grade__c;
            this.txPriority = !dog.Treatment_Plan__r.isEmpty() ? dog.Treatment_Plan__r[0].Treatment_Priority__c : null;
            this.hideMedications = u.Location__c == 'ARC/CARE';
        }
    }

    public class TxProtocolWrapper{
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String category {get;set;}
        @AuraEnabled public TreatmentWrapper[] sessionProtocols {get; set;}

        public TxProtocolWrapper(Session_Protocol__c sp){
            this.name = sp.Protocol_Name__c;
            this.category = sp.ProtocolId__r.Protocol_Categories__c;
            this.sessionProtocols = new TreatmentWrapper[0];
        }    
    }

    public class TreatmentWrapper{
        @AuraEnabled public Id id {get;set;}
        @AuraEnabled public String score {get;set;}
        @AuraEnabled public String colorText {get;set;}
        @AuraEnabled public String txDateFormatted {get;set;}
        @AuraEnabled public String protocolNotes {get;set;}
        @AuraEnabled public String fearBest {get;set;}
        @AuraEnabled public String fearWorst {get;set;}
        @AuraEnabled public String arousalBest {get;set;}
        @AuraEnabled public String arousalWorst {get;set;}
        @AuraEnabled public String agressiveBest {get;set;}
        @AuraEnabled public String agressionMovement {get;set;}

        public TreatmentWrapper(Session_Protocol__c sp){
            this.id = sp.Id;
            this.score = sp.Overall_Score__c;
            this.colorText = sp.Overall_Score_Number__c == 1 ? 'Red' :
                sp.Overall_Score_Number__c == 2 ? 'Orange' :
                sp.Overall_Score_Number__c == 3 ? 'Yellow' :
                sp.Overall_Score_Number__c == 4 ? 'Green' : null;

            if(sp.TreatmentSessionId__r.Session_Date__c != null){
                this.txDateFormatted = (String) sp.TreatmentSessionId__r.Session_Date__c.format();
            }
            this.protocolNotes = sp.Protocol_Notes__c;

            for(Session_Protocol_Scale__c scale : sp.Session_Protocol_Scales__r){
                System.debug('scale.Protocol_Scale_Name__c: ' + scale);
                switch on scale.Protocol_Scale_Name__c {
                    when 'Fear - Best' {
                        this.fearBest = scale.Protocol_Score__c;
                    }
                    when 'Fear - Worst' {
                        this.fearWorst = scale.Protocol_Score__c;
                    }
                    when 'Arousal - Best' {
                        this.arousalBest = scale.Protocol_Score__c;
                    }
                    when 'Arousal - Worst' {
                        this.arousalWorst = scale.Protocol_Score__c;
                    }
                    when 'Aggression - Movement' {
                        this.agressiveBest = scale.Protocol_Score__c;
                    }
                    when 'Aggressive - Worst' {
                        this.agressionMovement = scale.Protocol_Score__c;
                    }
                }
            }
        }
    }
}
