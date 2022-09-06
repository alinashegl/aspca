public with sharing class CreateActionItem_Obj {

    public Action_Item__c caseVar{get;set;}
    
    
    public List<ContactWrapper> complainants {get;set;}
    public List<ContactWrapper> subjects {get;set;}
    public List<Action_Item_Scene_Location__c> sceneList{get;set;}
    public List<Contact> conList{get;set;}
    public List<Action_Item_Role__c> cRoleList{get;set;} 
    
    public CreateActionItem_Obj() {
        
        caseVar = new Action_Item__c();
        sceneList = new List<Action_Item_Scene_Location__c>();
        sceneList.add(new Action_Item_Scene_Location__c	());
        
        
        complainants = new List<ContactWrapper>();
        subjects = new List<ContactWrapper>();
        
        ContactWrapper cw = new ContactWrapper();
        cw.ccRole.role__c = 'Complainant';
        complainants.add(cw);
        cw.index = complainants.size();
        
        ContactWrapper cw1 = new ContactWrapper();
        cw1.ccRole.role__c = 'Subject/Defendant';
        subjects.add(cw1);
        cw1.index = subjects.size();
    }
    
    public pageReference saveData(){


/*        for(ContactWrapper cw : complainants) {
             if(cw.useOrAddContact == null ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide contact details')); 
                return null;
            }
            if((cw.useOrAddContact == 'Add') && (cw.con.LastName == null || cw.con.MailingCity == null || cw.con.MailingState == null || cw.con.County__c == null  || cw.con.Contact_Type__c == null || cw.ccRole.Role__c == null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'We can not leave blank these contact fields: LastName,Mailing City,Mailing state,County,Role for this contact on this case,Contact Type'));
                return null;
            }
            if(cw.useOrAddContact == 'Use' && cw.ccRole.Role__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide Contact Role '));
                return null;
            }  
        }
        for(ContactWrapper cw : subjects) {
            if(cw.useOrAddContact == null ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide contact details')); 
                return null;
            }
            if((cw.useOrAddContact == 'Add') && (cw.con.LastName == null || cw.con.MailingCity == null || cw.con.MailingState == null || cw.con.County__c == null || cw.ccRole.Role__c == null || cw.con.Contact_Type__c == null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'We can not leave blank these contact fields: Last Name, Mailing City, Mailing State, County, Role, Contact Type'));
                return null;
            }
            if(cw.useOrAddContact == 'Use' && cw.ccRole.Role__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide Contact Role '));
                return null;
            } 
        }*/
         
        insert caseVar;
        
        for(Action_Item_Scene_Location__c sl : sceneList){ 
            sl.Action_Item__c = caseVar.Id;
        }
        insert sceneList;
         conList = new List<Contact>();
        for(ContactWrapper cw : complainants) {
            if(cw.useOrAddContact == 'Add') {
                conList.add(cw.con);
            }
        }
        for(ContactWrapper cw : subjects) {
            if(cw.useOrAddContact == 'Add') {
                conList.add(cw.con);
            }
        }
        insert conList;
        cRoleList = new List<Action_Item_Role__c>();
        for(ContactWrapper cw : complainants) {
            if(cw.useOrAddContact == 'Add') {
                
                cw.ccRole.Contact__c = cw.con.Id;
                cw.ccRole.Action_Item__c = caseVar.Id;
            } else {
                cw.ccRole.Contact__c = cw.selectedConId;
                cw.ccRole.Action_Item__c = caseVar.Id;
            }
            if (cw.ccRole.Contact__c != null){
                cRoleList.add(cw.ccRole);
            }
        }

        for(ContactWrapper cw : subjects) {
            if(cw.useOrAddContact == 'Add') {
                cw.ccRole.Contact__c = cw.con.Id;
                cw.ccRole.Action_Item__c = caseVar.Id; 
            } else {
                cw.ccRole.Contact__c = cw.selectedConId;
                cw.ccRole.Action_Item__c = caseVar.Id;  
            }
            if (cw.ccRole.Contact__c != null){
                cRoleList.add(cw.ccRole);
            }
            
        }
        system.debug(cRoleList);
        if (cRoleList != null){
       		insert cRoleList;
        }
        
        Schema.DescribeSObjectResult result = Action_Item__c.SObjectType.getDescribe();
        PageReference ref = new PageReference('/' + result.getKeyPrefix());
        ref.setRedirect(true); 
        return ref; 
    }
    
    public void back(){
        String indexStr = Apexpages.currentPage().getParameters().get('index');
        String typeStr = Apexpages.currentPage().getParameters().get('type');
        system.debug('indexStr:'+indexStr);
        Integer index = Integer.valueOf(indexStr);
        if(index != 1){
            complainants.remove(index-1);
        }
    }
    
    public void backSubject(){
        String indexStr = Apexpages.currentPage().getParameters().get('index');
        String typeStr = Apexpages.currentPage().getParameters().get('type');
        system.debug('indexStr:'+indexStr);
        Integer index = Integer.valueOf(indexStr);
        if(index != 1){
            subjects.remove(index-1);
        }
    }
    
    public void Remove(){
        String indexStr = Apexpages.currentPage().getParameters().get('index');
        String typeStr = Apexpages.currentPage().getParameters().get('type');
        system.debug('indexStr:'+indexStr);
        Integer index = Integer.valueOf(indexStr);
        if(index != 1){
            sceneList.remove(index-1);
        }
    }
    
    public void searchContact(){
        String indexStr = Apexpages.currentPage().getParameters().get('index');
        String typeStr = Apexpages.currentPage().getParameters().get('type');
        system.debug('indexStr:'+indexStr);
        Integer index = Integer.valueOf(indexStr); 
        ContactWrapper cw = null;
        if(typeStr == 'complainant') {
            for(ContactWrapper cw1 : complainants) {
                cw = cw1;
                if(cw1.index == index) {
                    break;
                }
            }
        } else {
            for(ContactWrapper cw1 : subjects) {
                cw = cw1;
                if(cw1.index == index) {
                    break;
                }
            }
        }
        
        system.debug('cw::'+cw);
        system.debug('cw.conSearchText:'+cw.conSearchText);
        string whereCondOne = cw.conSearchText+'%';
        if(cw.conSearchText!=null && cw.conSearchText != ''){
            
            List<Contact> conListOne = [select Id,Name,FirstName,LastName,Contact_Type__c,MailingCity,MailingState,MailingStreet,Account.Name from Contact where (LastName like :whereCondOne or FirstName like :whereCondOne)];
            cw.searchResults = new List<SelectOption>();
            for(Contact cont : conListOne){
                cw.searchResults.add(new SelectOption(cont.Id,cont.Name + ' - ' + cont.MailingStreet +' , '+ cont.MailingCity +' , '+ cont.MailingState +' - '+ ' Account: ' + cont.Account.Name + ' - ' + 'Contact Type' + ': ' + cont.Contact_Type__c));
            }
        }
        system.debug('--cw.searchResults---'+cw.searchResults);
    }
    
    public void addNewLocation() {
        Action_Item_Scene_Location__c sc = new Action_Item_Scene_Location__c();
        sceneList.add(sc);
        system.debug('@@sceneList@@'+sceneList);
    }
    
    public void addComplainant() {
        ContactWrapper cw = new ContactWrapper();
        cw.ccRole.role__c = 'Complainant';
        complainants.add(cw);
        cw.index = complainants.size();
    }
    
    public void addSubject() {
        ContactWrapper cw = new ContactWrapper();
        cw.ccRole.role__c = 'Subject/Defendant';
        subjects.add(cw);
        cw.index = subjects.size();
    }
    
    public class ContactWrapper {   
        public String conSearchText {get;set;}
        public String selectedConId {get;set;}
        public Contact con {get;set;} 
        public integer index {get;set;}  
        public List<SelectOption> searchResults {get;set;}
        public String useOrAddContact {get;set;}
        public Action_Item_Role__c ccRole{get;set;}
        public String validationError {get;set;}
       
        public ContactWrapper() { 
            con = new Contact();
            ccRole = new Action_Item_Role__c(); 
            
            
        }
    }
}