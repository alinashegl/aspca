public with sharing class AnimalTriggerHandler {
    @testVisible
    Private static Boolean alreadyRan = false;

    public static void Execute() {
        if (!Trigger.isExecuting) { return; }
        Trigger_Config__c config = Trigger_Config__c.getInstance();
        if (config != null  && config.Animal_Trigger_Enabled__c == false) { return; }
        if (Trigger.isUpdate && Trigger.isBefore ) {
            beforeUpdateHandler();
        }
    }
    
    public static void insertHandler(){
        reviewForMRCDailyCare((Animal__c[])Trigger.new);
/*        CaseContactRole conrole = new CaseContactRole();
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

        }  */
    }
    
/*    public static void insertHandlerBefore(){
        string initials = '';
        for (Animal__c a : (List<Animal__c>)Trigger.new){
            if (a.Gender__c == null){
                a.Gender__c = 'Unknown';
            }
            
            if (a.Age__c == null){
                a.Age__c = 'Unknown At Intake';
            }
            
            if (a.Color__c == null){
                a.Color__c = 'Unspecified';
            }
            
//            if (a.Name.contains('Form')){
//                initials = UserInfo.getFirstName().substring(0,1) + UserInfo.getLastName().substring(0,1);
//                a.Team__c = initials;
//            }           
            
     
        }  
    }*/

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
        reviewForMRCDailyCare(anms, oldAnms);
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
        if(RecursiveTriggerHandler.isFirstTime){
            RecursiveTriggerHandler.isFirstTime = false;
            LogHistory.LogHistory(oldAnms, anms);
        }
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
        try {
            //make sure we're not creating duplicate tasks
            System.debug('**createBrcMrcTasks');
            Map<Id, Animal__c> queriedAnimals = new Map<Id, Animal__c>([
                SELECT Id, (
                    SELECT Id, ActivityDate, Record_Type__c 
                    FROM Activities__r 
                    WHERE Record_Type__c =: AutoScheduleTasksUtil.MRC_BRC_FOLLOW_UP_TASK_RECORD_TYPE_NAME 
                    ORDER BY ActivityDate DESC 
                    LIMIT 1
                ) 
                FROM Animal__c WHERE Id IN: animals]
            );
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
        } catch (Exception e) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{'steven.workman@aspca.com'});
            mail.setSenderDisplayName('Animal Trigger Error:');
            mail.setSubject('Animal Trigger Error');
            mail.setHtmlBody(
                'Error with createBrcMrcTasks: ' + e.getMessage() +' </br>'+
                'StackTrace: ' + e.getStackTraceString() + '</br>' + 
                'userName: ' + userInfo.getName()
            );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    private static void reviewForMRCDailyCare(Animal__c[] animals, Map<Id, Animal__c> oldAnimals){
        Animal_Daily_Care__c[] newAdcs = new Animal_Daily_Care__c[0];
        //this list is for animals that have had certain updates that need to be pushed to the current animal daily care.
        Animal__c[] updatedAnimals = new Animal__c[0];
        for(Animal__c anim : animals){
            if(anim.Current_Location__c == 'MRC' && anim.Final_Outcome__c == null){
                Animal__c oldAnim = oldAnimals.get(anim.Id);
                if(oldAnim.Current_Location__c != anim.Current_Location__c){
                    newAdcs.add(prepADC(anim));
                }
                else if(anim.Handling_Instructions__c != oldAnim.Handling_Instructions__c){
                    updatedAnimals.add(anim);
                }
                else if(anim.Feeding_Amount__c != oldAnim.Feeding_Amount__c){
                    updatedAnimals.add(anim);
                }
            }
        }

        if(!newAdcs.isEmpty()){
            insertNewAnimalDailyCares(newAdcs);
        }

        if(!updatedAnimals.isEmpty()){
            updateAnimalDailyCares(updatedAnimals);
        }
    }

    private static void updateAnimalDailyCares(Animal__c[] animals){
        Animal_Daily_Care__c[] adcs = [SELECT Id, Handling_Instructions__c, Feeding_Amount__c, Animal__r.Handling_Instructions__c, Animal__r.Feeding_Amount__c FROM Animal_Daily_Care__c WHERE Animal__c IN: animals AND Daily_Care__r.Date__c = TODAY];
        for(Animal_Daily_Care__c adc : adcs){
            adc.Handling_Instructions__c = adc.Animal__r.Handling_Instructions__c;
            adc.Feeding_Amount__c = adc.Animal__r.Feeding_Amount__c;
        }

        update adcs;
    }

    private static void reviewForMRCDailyCare(Animal__c[] animals){
        Animal_Daily_Care__c[] newAdcs = new Animal_Daily_Care__c[0];
        for(Animal__c anim : animals){
            if(anim.Current_Location__c == 'MRC' && anim.Final_Outcome__c == null){
                newAdcs.add(
                    prepADC(anim)
                );
            }
        }

        if(!newAdcs.isEmpty()){
            insertNewAnimalDailyCares(newAdcs);
        }
    }

    private static void insertNewAnimalDailyCares(Animal_Daily_Care__c[] newAdcs){
        Daily_Care__c[] dcs = [SELECT Id FROM Daily_Care__c WHERE Date__c = TODAY ORDER BY Date__c DESC LIMIT 1];
        if(!dcs.isEmpty()){
            Daily_Care__c dc = dcs[0];
            for(Animal_Daily_Care__c adc : newAdcs){
                adc.Daily_Care__c = dc.Id;
            }
            insert newAdcs;
        }
    }

    private static Animal_Daily_Care__c prepADC(Animal__c anim){
        return new Animal_Daily_Care__c(
            Animal__c = anim.Id,
            Handling_Instructions__c = anim.Handling_Instructions__c,
            Round__c = '1',
            Special_Care_Outside_TX__c = 'Dry',
            Special_Care_TX__c = 'Dry + Wet',
            Movements_For_Cleaning__c = null
        );
    }
    
     public static void beforeFieldUpdateHandler(List<Animal__c> anms, Map<Id, Animal__c> oldAnms){
        for(Animal__c anm: anms){
            if(anm.Seizure_Surrender_Date__c != oldAnms.get(anm.Id).Seizure_Surrender_Date__c ){
                anm.Email_Notification__c = true;
            }
        }
    }

}