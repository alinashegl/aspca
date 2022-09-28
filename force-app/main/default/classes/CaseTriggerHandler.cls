public class CaseTriggerHandler {
    
        public static void insertHandler(){
        CaseContactRole conrole = new CaseContactRole();
        for (Case a : (List<Case>)Trigger.new){
            if (a.ContactId != null){
                conrole.CasesId = a.Id;
                conrole.ContactId = a.ContactId;
                conrole.Role = 'Officer';   
                insert conrole;
            }
        }  
    }
    
    public static void updateHandler(List<Case> cs, Map<Id, Case> oldcs){
        CaseContactRole conrole = new CaseContactRole();
        for (Case a : cs){
            Id oldCon = oldcs.get(a.id).ContactId;
			if (a.ContactId != oldCon && a.ContactId != null){
                conrole.CasesId = a.Id;
            	conrole.ContactId = a.ContactId;
            	conrole.Role = 'Officer'; 
                insert conrole;
                System.debug(conrole);
            	}
            }
    }

}