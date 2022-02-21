public with sharing class AnimalTriggerHandler {
    Private static Boolean alreadyRan = false;

    public static void Execute() {
        if (!Trigger.isExecuting) { return; }
        Trigger_Config__c config = Trigger_Config__c.getInstance();
        if (config != null  && config.Animal_Trigger_Enabled__c == false) { return; }
        //System.debug('#### Running Animal Trigger');
        //trigger_Controller.getInstance().process(Animal__c.SObjectType);
        if (Trigger.isUpdate && Trigger.isBefore ) {
            beforeUpdateHandler();
        }
    }
    
    public static void insertHandler(){
        CaseContactRole conrole = new CaseContactRole();
        for (Animal__c a : (List<Animal__c>)Trigger.new){
            List<CaseContactRole> curroles = [SELECT Id from CaseContactRole WHERE CasesId =: a.Case__c AND ContactId =: a.Discharged_to_Contact__c AND Role = 'Animal Discharge Contact'];
            if (a.Discharged_to_Contact__c != null){
                conrole.CasesId = a.Case__c;
                conrole.ContactId = a.Discharged_to_Contact__c;
                conrole.Role = 'Animal Discharge Contact';   
                if (curroles.size() > 0){
                    break;
                } 
                else {
                insert conrole;
                }
            }
            
            if (a.Location__Latitude__s !=null){
                reverseGeoloc(a.Location__Latitude__s, a.Location__Longitude__s, a.Id);
                
            }

        }  
    }
    
    public static void insertHandlerBefore(){
        string initials = '';
        for (Animal__c a : (List<Animal__c>)Trigger.new){
            if (a.Gender__c == null){
                a.Gender__c = 'Unknown';
            }
            
//            if (a.Age__c == null){
//                a.Age__c = 'Unknown At Intake';
//            }
            
            if (a.Color__c == null){
                a.Color__c = 'Unspecified';
            }
            
            if (a.Name.contains('Form')){
                initials = UserInfo.getFirstName().substring(0,1) + UserInfo.getLastName().substring(0,1);
                a.Team__c = initials;
            }           
            
     
        }  
    }

    public static void beforeUpdateHandler() {
        Map<Id, SObject> toUpdate = Trigger.newMap;

    }

    public static void onBeforeUpdateHandler(List<Animal__c> anms, Map<Id, Animal__c> oldAnms){
        if(alreadyRan == true) return;
        Animal__c[] brcMrcApprovedAnimals = new Animal__c[0];
        for (Animal__c a : anms){
            Animal__c oldAnimal = oldAnms.get(a.Id);
            System.debug('anim: ' + a);
            System.debug('oldAnimal: ' + oldAnimal);
            if(
                a.Type_of_Animal__c == 'Dog' &&
                ((a.MRC_Status__c == 'MRC Accepted' && oldAnimal.MRC_Status__c != 'MRC Accepted' && a.Current_Recent_Shelter_Location__c != 'MRC') ||
                (a.BRC_Status__c == 'BRC Accepted' && oldAnimal.MRC_Status__c != 'BRC Accepted' && a.Current_Recent_Shelter_Location__c != 'BRC'))
            ){
                brcMrcApprovedAnimals.add(a);
            }
        }
        if(!brcMrcApprovedAnimals.isEmpty()){
            createBrcMrcTasks(brcMrcApprovedAnimals);
        }

        alreadyRan = true;
    }
    
    public static void updateHandler(List<Animal__c> anms, Map<Id, Animal__c> oldAnms){
        CaseContactRole[] conroles = new CaseContactRole[0];
        Map<Id, CaseContactRole> animalToCaseContactRoleMap = queryCaseContactRoles(anms);
        for (Animal__c a : anms){
            Id oldCon = oldAnms.get(a.id).Discharged_to_Contact__c;    
			if (a.Discharged_to_Contact__c != oldCon && a.Discharged_to_Contact__c != null){
                CaseContactRole ccr = animalToCaseContactRoleMap.containsKey(a.Id) ? animalToCaseContactRoleMap.get(a.Id) : null;
                if(ccr == null){
                    CaseContactRole conrole = new CaseContactRole(
                        CasesId = a.Case__c,
                        ContactId = a.Discharged_to_Contact__c,
                        Role = 'Animal Discharge Contact'
                    );
                    conRoles.add(conRole);
                }
            }
        }
        System.debug(conroles);
        insert conroles;
        LogHistory.LogHistory(oldAnms, anms);
    }

    private static Map<Id, CaseContactRole> queryCaseContactRoles(Animal__c[] animals){
        Map<Id, Animal__c> caseToAnimalMap = new Map<Id, Animal__c>();
        Set<Id> caseIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        Map<Id, CaseContactRole> animalToCCRMap = new Map<Id, CaseContactRole>();
        for(Animal__c anim: animals){
            //skip if discharge to contact is blank
            if(anim.Discharged_to_Contact__c == null) continue;
            caseToAnimalMap.put(anim.Case__c, anim);
            caseIds.add(anim.Case__c);
            contactIds.add(anim.Discharged_to_Contact__c);
        }

        for(CaseContactRole ccr : [SELECT Id, CasesId, ContactId FROM CaseContactRole WHERE CasesId IN: caseIds AND ContactId IN: contactIds]){
            //just in case we get a ccr without a matchinga case
            if(!caseToAnimalMap.containsKey(ccr.CasesId)) continue;

            Animal__c anim = caseToAnimalMap.get(ccr.CasesId);
            if(ccr.ContactId == anim.Discharged_to_Contact__c){
                animalToCCRMap.put(anim.Id, ccr);
            }
        }

        return animalToCCRMap;
    }
    
	@future(callout=true)
	public static void reverseGeoloc(Decimal lat, Decimal longit, Id animalId) {
        
		String address = '';
        Http h = new Http();
		HttpRequest req = new HttpRequest();
        address = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='+String.valueOf(lat)+','+String.valueOf(longit)+'&result_type=street_address&key=AIzaSyB_vRSHbde-6dByBFtnz-shb4CjuG8OPH0';
       	req.setMethod('GET');
        req.setEndpoint(address);
        HttpResponse res = h.send(req);
        
        system.debug(address);

        if (res.getStatusCode() == 200){
        	Map<String,Object> gr = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
			List<Object> results = (List<Object>)gr.get('results');
        	Map<String,Object> firstResult = (Map<String,Object>)results[0];  
        	if (firstResult != null){            
        		String fullAddress = (String)firstResult.get('formatted_address');
        		List<Animal__c> lstAnim = [SELECT Formatted_Address__c FROM Animal__c WHERE Id = :animalId];
            	if (!lstAnim.isEmpty()){
                	lstAnim[0].Formatted_Address__c = fullAddress;
                	system.debug(lstAnim[0].Formatted_Address__c);
            	}
        		update lstAnim;
        	}
        }
    }

    @testVisible
    private static void createBrcMrcTasks(Animal__c[] animals){
        //make sure we're not creating duplicate tasks
        Map<Id, Animal__c> queriedAnimals = new Map<Id, Animal__c>([SELECT Id, (SELECT Id, ActivityDate, Record_Type__c FROM Activities__r WHERE Record_Type__c =: AutoScheduleTasksUtil.MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME ORDER BY ActivityDate DESC LIMIT 1) FROM Animal__c WHERE Id IN: animals]);
        Task[] toInsert = new Task[0];
        for(Animal__c anim : animals){
            if(!queriedAnimals.get(anim.Id).Activities__r.isEmpty()){
                if(queriedAnimals.get(anim.Id).Activities__r[0].ActivityDate < date.today()){
                    toInsert.add(ScheduleAnimalBRCMRC.prepTask(anim, date.today().addDays(14), false));
                }
            }
            else {
                toInsert.add(ScheduleAnimalBRCMRC.prepTask(anim, date.today().addDays(14), false));
            }
        }
        insert toInsert;
    }
}