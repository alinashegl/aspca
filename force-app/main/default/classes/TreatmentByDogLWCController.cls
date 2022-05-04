public with sharing class TreatmentByDogLWCController {
    public DogInfoWrapper[] dogInfoWrapper {get; set;}
    public String dogList{get;set;}

    public TreatmentByDogLWCController(){        
        dogList = apexpages.currentpage().getparameters().get('dogList');
        Id[] dogList = dogList.split(',');
        System.debug('dogList: ' + dogList);
        dogInfoWrapper = getDogInfo(dogList);        
    }

    @AuraEnabled
    public static string[] getUserLocation(){
        try {
            return BehaviorUtil.locationGroup;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static DogWrapper[] getDogList(String[] selectedLocations){
        try {
            DogWrapper[] dogs = new DogWrapper[0];
            for(Animal__c dog : [SELECT Id, Animal_Name_Id__c, Current_Location__c FROM Animal__c WHERE Current_Location__c IN: selectedLocations]){
                dogs.add(new DogWrapper(dog));
            }
            return dogs;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static DogInfoWrapper getDogInfo(Id recordId){
        return getDogInfo(new Id[]{recordId})[0];
    }

    private static DogInfoWrapper[] getDogInfo(Id[] dogIds){
        Map<Id, Set<String>>  medicationsByDogMap = getDogMedications(dogIds);
        Map<Id, TxProtocolWrapper[]> protocolByDogMap = getDogTreatments(dogIds);

        DogInfoWrapper[] dogInfos = new DogInfoWrapper[0];

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
            if(protocolByDogMap.containsKey(dog.Id)){
                dogInfo.protocols = protocolByDogMap.get(dog.Id);
            }
            
            dogInfos.add(dogInfo);
        }
        return dogInfos;
    }    

    private static Map<Id, Set<String>> getDogMedications(Id[] dogIds){
        Map<Id, Set<String>> dogToMedicationMap = new Map<Id, Set<String>>();
        Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.TREATMENT_TASK_RECORD_TYPE_NAME);

        for(Task t : [
            SELECT Id, Medication__r.Name, Animal__c 
            FROM Task 
            WHERE RecordTypeId =: recordTypeId
            AND Animal__c IN: dogIds
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

    private static TxProtocolWrapper[] getDogTreatments(Id dogId){
        return
            getDogTreatments(new Id[]{dogId}).get(dogId);        
    }

    private static Map<Id, TxProtocolWrapper[]> getDogTreatments(Id[] dogIds){
        Map<Id, Map<String, Session_Protocol__c[]>> sessionProtocolsByDogMap = new Map<Id, Map<String, Session_Protocol__c[]>>();

        for(Session_Protocol__c protocol : [
            SELECT Id, Protocol_Name__c, TreatmentSessionId__c, Overall_Score__c, Overall_Score_Number__c, Overall_Score_Color__c, TreatmentSessionId__r.Session_Date__c, ProtocolId__r.Protocol_Categories__c, TreatmentSessionId__r.Animal__c
            FROM Session_Protocol__c
            WHERE TreatmentSessionId__r.Animal__c IN: dogIds
            AND Overall_Score__c != null
            ORDER BY ProtocolId__r.Protocol_Categories__c ASC, Protocol_Name__c ASC, TreatmentSessionId__r.Session_Date__c ASC
        ]){
            Id dogId = protocol.TreatmentSessionId__r.Animal__c;
            if(sessionProtocolsByDogMap.containsKey(dogId)){
                Map<String, Session_Protocol__c[]> protocolMap = sessionProtocolsByDogMap.get(dogId);
                if(protocolMap.containsKey(protocol.Protocol_Name__c)){
                    protocolMap.get(protocol.Protocol_Name__c).add(protocol);
                } else {
                    protocolMap.put(protocol.Protocol_Name__c, new Session_Protocol__c[]{protocol});
                }
            }else {
                sessionProtocolsByDogMap.put(dogId, 
                    new Map<String, Session_Protocol__c[]>{
                        protocol.Protocol_Name__c => new Session_Protocol__c[]{protocol}
                    }
                );
            }
        }

        Map<Id, TxProtocolWrapper[]> protocolWrapperByDogMap = new Map<Id, TxProtocolWrapper[]>();

        for(Id dogId : sessionProtocolsByDogMap.keySet()){
            TxProtocolWrapper[] protocols = new TxProtocolWrapper[0];
            Map<String, Session_Protocol__c[]> protocolMap = sessionProtocolsByDogMap.get(dogId);
            for(String pName : protocolMap.Keyset()){
                TxProtocolWrapper txP = new TxProtocolWrapper();
                txP.name = pName;
                txP.category = protocolMap.get(pName)[0].ProtocolId__r.Protocol_Categories__c;
                txP.treatments = new TreatmentWrapper[0];
                for(Session_Protocol__c sp : protocolMap.get(pName)){
                    txP.treatments.add(new TreatmentWrapper(sp));
                }
                protocols.add(txP);
            }

            protocolWrapperByDogMap.put(dogId, protocols);
        }

        
        return protocolWrapperByDogMap;
    }

    public class DogInfoWrapper{
        @AuraEnabled public Id id {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String gender {get;set;}
        @AuraEnabled public String breed {get;set;}
        @AuraEnabled public String age {get;set;}
        @AuraEnabled public String location {get;set;}
        @AuraEnabled public String evalGrade {get;set;}
        @AuraEnabled public String medications {get;set;}
        @AuraEnabled public String txPriority {get;set;}
        @AuraEnabled public TxProtocolWrapper[] protocols {get;set;}

        public DogInfoWrapper(Animal__c dog){
            this.id = dog.Id;
            this.name = dog.Animal_Name_Id__c;
            this.gender = dog.Gender__c;
            this.breed = dog.Breed__c;
            this.age = dog.Current_Animal_Age_Formatted__c;
            this.location = dog.Current_Location__c;
            this.evalGrade = dog.Current_Behavior_Grade__c;
            this.txPriority = !dog.Treatment_Plan__r.isEmpty() ? dog.Treatment_Plan__r[0].Treatment_Priority__c : null;
        }

    }

    public class TxProtocolWrapper{
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String category {get;set;}
        @AuraEnabled public TreatmentWrapper[] treatments {get;set;}
    }

    public class TreatmentWrapper{
        @AuraEnabled public Id id {get;set;}
        @AuraEnabled public String score {get;set;}
        @AuraEnabled public String color {get;set;}
        @AuraEnabled public String colorText {get;set;}
        @AuraEnabled public Date txDate {get;set;}
        @AuraEnabled public String txDateFormatted {get;set;}

        public TreatmentWrapper(Session_Protocol__c sp){
            this.id = sp.Id;
            this.score = sp.Overall_Score__c;
            this.color = sp.Overall_Score_Color__c;
            this.colorText = sp.Overall_Score_Number__c == 1 ? 'Red' :
                sp.Overall_Score_Number__c == 2 ? 'Orange' :
                sp.Overall_Score_Number__c == 3 ? 'Yellow' :
                sp.Overall_Score_Number__c == 4 ? 'Green' : null;

            this.txDate = sp.TreatmentSessionId__r.Session_Date__c;
            this.txDateFormatted = (String) sp.TreatmentSessionId__r.Session_Date__c.format();
        }
    }

    public class DogWrapper{
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public String location;
        @AuraEnabled public Boolean selected;

        public DogWrapper(Animal__c dog){
            this.id = dog.Id;
            this.name = dog.Animal_Name_Id__c;
            this.location = dog.Current_Location__c;
            this.selected = false;
        }
    }


    
}
