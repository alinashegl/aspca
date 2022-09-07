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
            String query = 'SELECT Id, Animal_Name_Id__c, Current_Location__c FROM Animal__c WHERE Current_Location__c IN: selectedLocations AND Active_Animal__c = true';
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

    public static Map<Id, Map<String, TxProtocolWrapper>> getDogTreatments(Id[] dogIds){
        //map of active plans (if the values contains a set a of Ids, they are the ids of removed protocols at the plan level)
        Map<Id, Set<Id>> m_activePlansProtocolIds = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> m_activePlansRemovedProtocols = new Map<Id, Set<Id>>();
        Map<Id, Map<Id, String>> m_activePlanToCreatedDate = new Map<Id, Map<Id, String>>();
        for(Treatment_Plan__c plan : [
            SELECT Id, Animal__c, 
            (SELECT Id, Protocol__c, isRemoved__c, CreatedDate FROM Plan_Protocols__r)
            FROM Treatment_Plan__c
            WHERE isActive__c = true
            AND Animal__c IN :dogIds
        ]){
            Set<Id> protocolIds = new Set<Id>();
            Set<Id> removedProtocolIds = new Set<Id>();
            Map<Id, String> m_planProtolCreatedDate = new Map<Id, String>();
            for(Plan_Protocol__c protocol : plan.Plan_Protocols__r){
                protocolIds.add(protocol.Protocol__c);

                if(protocol.isRemoved__c){
                    removedProtocolIds.add(protocol.Protocol__c);
                }

                m_planProtolCreatedDate.put(protocol.Protocol__c, (String) Date.valueOf(protocol.CreatedDate).format());
                
            }
            m_activePlansProtocolIds.put(plan.Animal__c, protocolIds);
            m_activePlansRemovedProtocols.put(plan.Animal__c, removedProtocolIds);
            m_activePlanToCreatedDate.put(plan.Animal__c, m_planProtolCreatedDate);
        }
          
        Map<Id, Map<String, TxProtocolWrapper>> sessionProtocolsByDogMap = new Map<Id, Map<String, TxProtocolWrapper>>();

        for(Session_Protocol__c protocol : getSessionProtocols(dogIds)){
            Id dogId = protocol.TreatmentSessionId__r.Animal__c;
            Id treatmentPlanId = protocol.TreatmentSessionId__r.Treatment_Plan__c;
            Map<Id, String> m_planProtolCreatedDate = 
                m_activePlanToCreatedDate.containsKey(protocol.TreatmentSessionId__r.Animal__c) ?
                m_activePlanToCreatedDate.get(protocol.TreatmentSessionId__r.Animal__c) :
                new Map<Id, String>();

            //instantiate the sessionProtocolsMap
            Map<String, TxProtocolWrapper> sessionProtocolsMap = new Map<String, TxProtocolWrapper>();

            //if this dog Id already has been added to sessionProtocolsByDogMap get the SessionProtocolsForDog
            if(sessionProtocolsByDogMap.containsKey(dogId)){
                sessionProtocolsMap = sessionProtocolsByDogMap.get(dogId);
            }

            //get the TxProtocolWrapper by the protocol name, if the key exists, otherwise instanitae a new one
            TxProtocolWrapper protocolInfo = new TxProtocolWrapper();
            if(sessionProtocolsMap.containsKey(protocol.Protocol_Name__c)){
                protocolInfo = sessionProtocolsMap.get(protocol.Protocol_Name__c);
            } else {
                protocolInfo.name = protocol.Protocol_Name__c;
                protocolInfo.category = protocol.ProtocolId__r.Protocol_Categories__c;
                //todo: need to come back and fix this later
                protocolInfo.dateAddedToPlan = m_planProtolCreatedDate.containsKey(protocol.ProtocolId__c) ? m_planProtolCreatedDate.get(protocol.ProtocolId__c) : null;
                //set defaults to false
                protocolInfo.isActiveNotRemoved = false;
                protocolInfo.isActiveRemoved = false;
                protocolInfo.isHistorical = false;
                sessionProtocolsMap.put(protocol.Protocol_Name__c, protocolInfo);
            }

            //get the active plan protocol Ids for this dog to compare the session protocols against
            Set<Id> activePlanProtocolIds = m_activePlansProtocolIds.containsKey(dogId) ? 
                m_activePlansProtocolIds.get(dogId) : 
                new Set<Id>();

            //get the removed plan protocol Ids for this dog to compare the session protocols against
            Set<Id> removedPlanProtocolIds = m_activePlansRemovedProtocols.containsKey(dogId) ? 
                m_activePlansRemovedProtocols.get(dogId) : 
                new Set<Id>();  

            Boolean removedAtPlanLevel = removedPlanProtocolIds.contains(protocol.ProtocolId__c);
            
            //if the protocolId is in the active plan
            if(activePlanProtocolIds.contains(protocol.ProtocolId__c)){
                protocolInfo.isActiveProtocol = true;
                //if the protocol was completed in the current plan
                if(protocol.TreatmentSessionId__r.Treatment_Plan__r.IsActive__c){
                    //if the session protocol has not been removed from the current plan
                    if(!protocol.IsRemoved__c && !removedAtPlanLevel){
                        //add to list of active protocols that have not been removed
                        protocolInfo.isActiveNotRemoved = true;
                        protocolInfo.activePlanSessionProtocols.add(new TreatmentWrapper(protocol));
                    } else {
                        //add to list of active protocols that have been removed
                        protocolInfo.isActiveRemoved = true;
                        protocolInfo.isActiveNotRemoved = false;
                        protocolInfo.activePlanRemovedSessionProtocols.add(new TreatmentWrapper(protocol));
                    }
                //not completed in current plan, so it's an historical session protocol
                }else{
                    if(!protocol.IsRemoved__c && !removedAtPlanLevel){
                        //add to list of historical protocols that have not been removed
                        protocolInfo.isActiveNotRemoved = true;
                        protocolInfo.historicalActiveSessionProtocols.add(new TreatmentWrapper(protocol));
                    } else {
                        //add to list of historical protocols that have been removed
                        protocolInfo.isActiveRemoved = true;
                        protocolInfo.isActiveNotRemoved = false;
                        protocolInfo.historicalRemovedSessionProtocols.add(new TreatmentWrapper(protocol));
                    }
                }
            } else {
                //protocol Id is not one of the active protocols, so it's historical
                protocolInfo.isHistorical = true;
                protocolInfo.historicalSessionProtocols.add(new TreatmentWrapper(protocol));                  
            }

            sessionProtocolsByDogMap.put(dogId, sessionProtocolsMap);
        }
        return sessionProtocolsByDogMap;
    }

     private static Session_Protocol__c[] getSessionProtocols(Id[] dogIds){
        return [
            SELECT Id, Protocol_Name__c, isRemoved__c, Overall_Score__c, Overall_Score_Number__c, Overall_Score_Color__c, TreatmentSessionId__r.Treatment_Plan__c,
            TreatmentSessionId__c, TreatmentSessionId__r.Session_Date__c, ProtocolId__c, ProtocolId__r.Protocol_Categories__c, TreatmentSessionId__r.Animal__c,
            TreatmentSessionId__r.Treatment_Plan__r.IsActive__c
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
        @AuraEnabled public String medications {get;set;}
        @AuraEnabled public String txPriority {get;set;}
        @AuraEnabled public TxProtocolWrapper[] txProtocols {get;set;}

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
        @AuraEnabled public Boolean isActiveProtocol {get; set;}
        @AuraEnabled public Boolean isActiveNotRemoved {get; set;}
        @AuraEnabled public Boolean isActiveRemoved {get; set;}
        @AuraEnabled public Boolean isHistorical {get; set;}

        @AuraEnabled public TreatmentWrapper[] activePlanSessionProtocols {get; set;}
        @AuraEnabled public TreatmentWrapper[] historicalActiveSessionProtocols {get; set;}
        @AuraEnabled public TreatmentWrapper[] activePlanRemovedSessionProtocols {get; set;}
        @AuraEnabled public TreatmentWrapper[] historicalRemovedSessionProtocols {get; set;}
        @AuraEnabled public TreatmentWrapper[] historicalSessionProtocols {get; set;}

        public TxProtocolWrapper(){
            this.activePlanSessionProtocols = new TreatmentWrapper[0];
            this.historicalActiveSessionProtocols = new TreatmentWrapper[0];
            this.activePlanRemovedSessionProtocols = new TreatmentWrapper[0];
            this.historicalRemovedSessionProtocols = new TreatmentWrapper[0];
            this.historicalSessionProtocols = new TreatmentWrapper[0];
        }    
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