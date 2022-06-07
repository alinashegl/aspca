public with sharing class TreatmentByDogLWCController {
    public DogInfoWrapper[] dogInfoWrapperList {get; set;}
    public String dogList{get;set;}

    public TreatmentByDogLWCController(){        
        dogList = apexpages.currentpage().getparameters().get('dogList');
        Id[] dogList = dogList.split(',');
        System.debug('dogList: ' + dogList);
        dogInfoWrapperList = getDogInfo(dogList);        
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
        return getDogList(selectedLocations, null);
    }

    @AuraEnabled(cacheable=true)
    public static DogWrapper[] getDogList(String[] selectedLocations, String filterText){
        try {
            DogWrapper[] dogs = new DogWrapper[0];
            String query = 'SELECT Id, Animal_Name_Id__c, Current_Location__c FROM Animal__c WHERE Current_Location__c IN: selectedLocations';
            if(filterText != null){
                query += ' AND Animal_Name_Id__c LIKE \'%' + filterText + '%\'';
            }

            System.debug('query: ' + query);

            for(Animal__c dog : Database.query(query)){
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

    @testVisible
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

    @testVisible
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

    @testVisible
    private static TxProtocolWrapper[] getDogTreatments(Id dogId){
        return
            getDogTreatments(new Id[]{dogId}).get(dogId);        
    }

    @testVisible
    private static Map<Id, TxProtocolWrapper[]> getDogTreatments(Id[] dogIds){
        Map<Id, Map<String, Session_Protocol__c[]>> sessionProtocolsByDogMap = getSessionProtocolsByDog(dogIds);
        Map<Id, Map<Id, Plan_Protocol__c>> planProtocolByDogMap = getActivePlanProtocols(dogIds);        

        Map<Id, TxProtocolWrapper[]> protocolWrapperByDogMap = new Map<Id, TxProtocolWrapper[]>();

        for(Id dogId : planProtocolByDogMap.keySet()){
            Map<String, Session_Protocol__c[]> protoToSessionProtoMap = sessionProtocolsByDogMap.containsKey(dogId) ? sessionProtocolsByDogMap.get(dogId) : new Map<String, Session_Protocol__c[]>();
            Map<Id, Plan_Protocol__c> protoToPlanProtoMap = planProtocolByDogMap.get(dogId);
            TxProtocolWrapper[] protocols = new TxProtocolWrapper[0];
            // TxProtocolWrapper[] removedProtocols = new TxProtocolWrapper[0];

            for(Plan_Protocol__c pProtocol : protoToPlanProtoMap.values()){
                String pName = pProtocol.Protocol__r.Name;
                Session_Protocol__c[] sessionProtocols = protoToSessionProtoMap.containsKey(pName) ? protoToSessionProtoMap.get(pName) : new Session_Protocol__c[0];

                TxProtocolWrapper txP = new TxProtocolWrapper();
                txP.name = pName;
                txP.category = pProtocol.Protocol__r.Protocol_Categories__c;
                txP.dateAddedToPlan = (String) Date.valueOf(pProtocol.CreatedDate).format(); 

                System.debug('dateAddedToPlan: ' + txP.dateAddedToPlan);
                txP.isActive = !pProtocol.isRemoved__c;
                txP.treatments = new TreatmentWrapper[0];
                txP.removedTreatments = new TreatmentWrapper[0];

                for(Session_Protocol__c sp : sessionProtocols){
                    if(txp.isActive){
                        txP.treatments.add(new TreatmentWrapper(sp));
                    } else {
                        txP.removedTreatments.add(new TreatmentWrapper(sp));
                    }
                }
                protocols.add(txp);
            }

            //compile the list of protocols with active first and then removed
            // TxProtocolWrapper[] protocols = activeProtocols;
            // protocols.addAll(removedProtocols);
            protocolWrapperByDogMap.put(dogId, protocols);
        }
        
        return protocolWrapperByDogMap;
    }

    private static Map<Id, Map<String, Session_Protocol__c[]>> getSessionProtocolsByDog(Id[] dogIds){
        Map<Id, Map<String, Session_Protocol__c[]>> sessionProtocolsByDogMap = new Map<Id, Map<String, Session_Protocol__c[]>>();
        for(Session_Protocol__c protocol : [
            SELECT Id, Protocol_Name__c, isRemoved__c, TreatmentSessionId__c, Overall_Score__c, Overall_Score_Number__c, Overall_Score_Color__c, 
            TreatmentSessionId__r.Session_Date__c, ProtocolId__r.Protocol_Categories__c, TreatmentSessionId__r.Animal__c
            FROM Session_Protocol__c
            WHERE TreatmentSessionId__r.Animal__c IN: dogIds
            AND Overall_Score__c != null
            ORDER BY ProtocolId__r.Protocol_Categories__c ASC, Protocol_Name__c ASC, TreatmentSessionId__r.Session_Date__c DESC
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
        return sessionProtocolsByDogMap;
    }

    private static Map<Id, Map<Id, Plan_Protocol__c>> getActivePlanProtocols(Id[] dogIds){
        Plan_Protocol__c[] pProtocols = [
            SELECT Id, CreatedDate, isRemoved__c, Treatment_Plan__r.Animal__c, Protocol__c, Protocol__r.Protocol_Categories__c, Protocol__r.Name
            FROM Plan_Protocol__c 
            WHERE Treatment_Plan__r.IsActive__c  = true 
            AND  Treatment_Plan__r.Animal__c IN :dogIds
        ];
        Map<Id, Map<Id, Plan_Protocol__c>> protocolMap = new Map<Id, Map<Id, Plan_Protocol__c>>();
        for(Plan_Protocol__c proto : pProtocols){
            if(protocolMap.containsKey(proto.Treatment_Plan__r.Animal__c)){
                protocolMap.get(proto.Treatment_Plan__r.Animal__c).put(proto.Protocol__c, proto);
            } else {
                protocolMap.put(proto.Treatment_Plan__r.Animal__c, new Map<Id, Plan_Protocol__c>{proto.Protocol__c => proto});
            }
        }
        return protocolMap;
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
        @AuraEnabled public String dateAddedToPlan {get;set;}
        @AuraEnabled public Boolean isActive {get;set;}
        // @AuraEnabled public SessionProtocol[] sessionProtocols {get; set;}
        @AuraEnabled public TreatmentWrapper[] treatments {get;set;}
        @AuraEnabled public TreatmentWrapper[] removedTreatments {get;set;}
    }

    public class SessionProtocol{
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
            if(sp.TreatmentSessionId__r.Session_Date__c != null){
                this.txDateFormatted = (String) sp.TreatmentSessionId__r.Session_Date__c.format();
            }
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