public with sharing class TreatmentByDogLWCController {
    public TreatmentByDogLWCController(){

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
        System.debug('recordId: ' + recordId);
        Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.TREATMENT_TASK_RECORD_TYPE_NAME);
        Animal__c dog = [
            SELECT Id, Animal_Name_Id__c, Gender__c, Breed__c, Current_Animal_Age_Formatted__c, Current_Location__c, 
            Current_Behavior_Grade__c,
            (SELECT Id, Treatment_Priority__c FROM Treatment_Plan__r WHERE IsActive__c = true LIMIT 1)
            FROM Animal__c 
            WHERE Id =: recordId LIMIT 1 
        ];

        DogInfoWrapper dogInfo = new DogInfoWrapper(dog);

        Set<String> medicationSet = new Set<String>();
        
        for(Task t : [
            SELECT Id, Medication__r.Name 
            FROM Task 
            WHERE RecordTypeId =: recordTypeId
            AND Animal__c =: dog.Id
            AND ((IsRecurrence = true AND RecurrenceEndDateOnly >= TODAY)
            OR (RecurrenceActivityId = null AND ActivityDate >= TODAY))
        ]){
            medicationSet.add(t.Medication__r.Name);
        }

        dogInfo.medications = string.join(new List<String>(medicationSet), '; ');

        dogInfo.protocols = getDogTreatments(recordId);

        return dogInfo;
    }

    private static TxProtocolWrapper[] getDogTreatments(Id dogId){
        TxProtocolWrapper[] protocols = new TxProtocolWrapper[0];
        Map<String, Session_Protocol__c[]> protocolMap = new Map<String, Session_Protocol__c[]>();
        for(Session_Protocol__c protocol : [
            SELECT Id, Protocol_Name__c, TreatmentSessionId__c, Overall_Score__c, Overall_Score_Color__c, TreatmentSessionId__r.Session_Date__c, ProtocolId__r.Protocol_Categories__c
            FROM Session_Protocol__c
            WHERE TreatmentSessionId__r.Animal__c =: dogId
            AND Overall_Score__c != null
            ORDER BY ProtocolId__r.Protocol_Categories__c ASC, Protocol_Name__c ASC, TreatmentSessionId__r.Session_Date__c ASC
        ]){
            if(protocolMap.containsKey(protocol.Protocol_Name__c)){
                protocolMap.get(protocol.Protocol_Name__c).add(protocol);
            } else {
                protocolMap.put(protocol.Protocol_Name__c, new Session_Protocol__c[]{protocol});
            }
        }

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

        System.debug('protocols: ' + protocols);
        return protocols;
    }

    public class DogInfoWrapper{
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public String gender;
        @AuraEnabled public String breed;
        @AuraEnabled public String age;
        @AuraEnabled public String location;
        @AuraEnabled public String evalGrade;
        @AuraEnabled public String medications;
        @AuraEnabled public String txPriority;
        @AuraEnabled public TxProtocolWrapper[] protocols;

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
        @AuraEnabled public String name;
        @AuraEnabled public String category;
        @AuraEnabled public TreatmentWrapper[] treatments;
    }

    public class TreatmentWrapper{
        @AuraEnabled public Id id;
        @AuraEnabled public String score;
        @AuraEnabled public String color;
        @AuraEnabled public Date txDate;
        @AuraEnabled public String txDateFormatted;

        public TreatmentWrapper(Session_Protocol__c sp){
            this.id = sp.Id;
            this.score = sp.Overall_Score__c;
            this.color = sp.Overall_Score_Color__c;
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
