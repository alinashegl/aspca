public with sharing class AnimalTriggerHandler {

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

    
    public static void updateHandler(List<Animal__c> anms, Map<Id, Animal__c> oldAnms){
        CaseContactRole conrole = new CaseContactRole();
        for (Animal__c a : anms){
            List<CaseContactRole> curroles = [SELECT Id from CaseContactRole WHERE CasesId =: a.Case__c AND ContactId =: a.Discharged_to_Contact__c AND Role = 'Animal Discharge Contact'];
            Id oldCon = oldAnms.get(a.id).Discharged_to_Contact__c;
/*            System.debug(oldCon);
            if (oldCon != null){
                List<CaseContactRole> delConRoles = [SELECT Id from CaseContactRole WHERE CasesId =: a.Case__c AND ContactId =: oldCon AND Role = 'Animal Discharge Contact'];
                System.debug('CaseContactRole to be deleted: ' + delConRoles);
                delConRoles[0].Role = 'Receiving Shelter Contact';
                System.debug('CaseContactRole to be updated: ' + delConRoles);
                //delete delConRoles;
            }*/
			if (a.Discharged_to_Contact__c != oldCon && a.Discharged_to_Contact__c != null){
                conrole.CasesId = a.Case__c;
            	conrole.ContactId = a.Discharged_to_Contact__c;
            	conrole.Role = 'Animal Discharge Contact'; 
                if (curroles.size() > 0){
                    break;
                } 
                else {
                	insert conrole;
                }
                System.debug(conrole);
            }
            }
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
}