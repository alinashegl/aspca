/**************************************************************************************************
* Name   : ClsEvidenceInformation 
* Author : Jagdish Khantwal
* Date   :  
* Purpose: 
* 
* ======================================
* = MODIFICATION HISTORY =
* ======================================
* DATE              AUTHOR               CHANGE
* ----              ------               ------
* 00/00/2013     Jagdish Khantwal      Created 
* 
***************************************************************************************************/

public class ClsEvidenceInformation
{
    public List<Evidence__c> lstEvidence{get;set;}
    public Evidence__c objEvidenceStartDate{get;set;}
    public Evidence__c objEvidenceEndDate{get;set;}
    public string strCaseNumber{get;set;}
    public String soqlquery { get; set; } 
    string caseId;
    
   // List to store Evidence records 
    public List<EvidenceWrapper> lstWrpperEvidence{get;set;}
   
    public Evidence__c objEvidenceCategory{get;set;}
    
   //wrapper class to display checkbox and the Evidence values on UI
      public class EvidenceWrapper{
      public boolean isSelected{get;set;}
      public Evidence__c ObjEvidence {get;set;}
       
      public EvidenceWrapper(Evidence__c  ev){
            this.isSelected = false;
            ObjEvidence = ev;
        }
    } 
    
    
    public ClsEvidenceInformation(){
    
       objEvidenceStartDate=new Evidence__c();
       objEvidenceEndDate=new Evidence__c();
       
        objEvidenceCategory = new Evidence__c();
        caseId=ApexPages.currentPage().getparameters().get('Id');
        
         string  evidenceReceiptId = ApexPages.currentPage().getparameters().get('ReceiptId');
        
        if(evidenceReceiptId != null && evidenceReceiptId != ''){
        
        lstEvidence=[select Id,Name,Received_Date_Time__c,Evidence_Description__c,Animal__c,Animal__r.name, Case__c,Case__r.casenumber,Case__r.Agency_Case__c, case__r.Account.name,Disposition_Date__c,Evidence_Type__c , Evidence_Category__c,Primary_Agency__c,createddate,
                         (select id,name,Evidence_ID__c,Disposition__c,Disposition_Date__c,  Received_By__c from Evidence_Tracking__r)
                          from Evidence__c where id=:evidenceReceiptId];
        
        }
        
        system.debug('caseId----'+caseId);
        if(caseId != null && caseId != ''){
               
            lstEvidence=[select Id,Name,Received_Date_Time__c,Evidence_Description__c,Animal__c,Animal__r.name, Case__c,Case__r.casenumber,Case__r.Agency_Case__c, case__r.Account.name,Disposition_Date__c,Evidence_Type__c , Evidence_Category__c,Primary_Agency__c,createddate,
                         (select id,name,Evidence_ID__c,Disposition__c,Disposition_Date__c,  Received_By__c from Evidence_Tracking__r)
                          from Evidence__c where Case__c=:caseId order by createddate];
                          
            if(lstEvidence != null && lstEvidence.size() > 0){
                lstWrpperEvidence = new  List<EvidenceWrapper>();
                for(Evidence__c  objEve : lstEvidence) {
                    lstWrpperEvidence.add(new EvidenceWrapper(objEve));
                }
            
                objEvidenceStartDate.Disposition_Date__c=date.newinstance(lstEvidence[0].createddate.year(), lstEvidence[0].createddate.month(), lstEvidence[0].createddate.day()); 
                strCaseNumber=lstEvidence[0].Case__r.casenumber;
                
            }
        }
        objEvidenceEndDate.Disposition_Date__c=system.today();
    }
    public pagereference Search(){
         searchCriteria();
        return null;
    }
    
    private void searchCriteria()
    {
        string queryString = '';
       
        queryString = 'Select Id,Received_Date_Time__c ,Case__r.casenumber,Case__r.Agency_Case__c,Name,case__r.account.name,Evidence_Description__c,Animal__c,Animal__r.name,Case__c,Disposition_Date__c,Evidence_Type__c ,Evidence_Category__c,Primary_Agency__c,createddate, ' + 
                            '(Select id,name,Disposition_Date__c,Disposition__c from Evidence_Tracking__r)'+
                             'From Evidence__c '; 
        
        /*
        queryString = 'Select Id,Received_Date_Time__c ,Case__r.casenumber,Case__r.Agency_Case__c,Name,case__r.account.name,Evidence_Description__c,Animal__c,Animal__r.name,Case__c,Disposition_Date__c,Evidence_Type__c ,Evidence_Category__c,Primary_Agency__c,createddate, ' + 
                            '(Select id,name,Disposition_Date__c,Disposition__c from Evidence_Tracking__r ';
        */ 
        system.debug('Query String init: ' + queryString);
        
        /*
        if(objEvidenceStartDate.Disposition_Date__c == null)
            objEvidenceStartDate.Disposition_Date__c = system.today();  
        Date sdt = objEvidenceStartDate.Disposition_Date__c;
        system.debug('sdt------'+sdt);
        String dateStr = DateTime.newInstance(sdt.year(),sdt.month(),sdt.day()).format('yyyy-MM-dd');
        */

                String dateStr;
        if (objEvidenceStartDate.Disposition_Date__c != null) {
                Date sdt = objEvidenceStartDate.Disposition_Date__c;
                system.debug('sdt------'+sdt);
                dateStr = DateTime.newInstance(sdt.year(),sdt.month(),sdt.day()).format('yyyy-MM-dd');
        }

                /*
        if(objEvidenceEndDate.Disposition_Date__c == null)
            objEvidenceEndDate.Disposition_Date__c = system.today();
            
        Date edt = objEvidenceEndDate.Disposition_Date__c;
        String dateEndStr = DateTime.newInstance(edt.year(),edt.month(),edt.day()).format('yyyy-MM-dd');
                */
                String dateEndStr;         
        if (objEvidenceEndDate.Disposition_Date__c != null) {
                Date edt = objEvidenceEndDate.Disposition_Date__c;
                dateEndStr = DateTime.newInstance(edt.year(),edt.month(),edt.day()).format('yyyy-MM-dd');
        }
        
        system.debug('category-----'+objEvidenceCategory.Evidence_Category__c);
        system.debug('type-----'+objEvidenceCategory.Evidence_Type__c);
        System.debug('Start Date Str: '+dateStr+'  End Date Str: '+dateEndStr);
        
        // Build the Query string for the Disposition Start and End Date
        String strDateQuery='';
        if ( (objEvidenceStartDate.Disposition_Date__c != null) && (objEvidenceEndDate.Disposition_Date__c != null) ) {
                strDateQuery = ' where Disposition_Date__c >= ' + dateStr + ' and Disposition_Date__c <= ' +dateEndStr ;
        }
        else if ( (objEvidenceStartDate.Disposition_Date__c == null) && (objEvidenceEndDate.Disposition_Date__c == null) ) {
                strDateQuery='';
        }
        else if (objEvidenceStartDate.Disposition_Date__c == null) {
                strDateQuery = ' where Disposition_Date__c <= ' +dateEndStr ;
        }
        else if (objEvidenceEndDate.Disposition_Date__c == null) {
                strDateQuery = ' where Disposition_Date__c >= ' + dateStr;
        }
        strDateQuery += ' )';
        // StrDateQuery += ') From Evidence__c ';
        // queryString += strDateQuery;
        
        System.debug('Date Query Str: '+strDateQuery); 
        System.debug('Query String after Date: '+queryString);
        if (objEvidenceCategory.Evidence_Category__c == null && objEvidenceCategory.Evidence_Type__c == null) {
                queryString += 'Where Case__c = ' + '\'' + caseId + '\'';
        }
        else if(objEvidenceCategory.Evidence_Category__c != null  && objEvidenceCategory.Evidence_Type__c != null) {
                queryString += 'Where Evidence_Category__c = ' + '\'' +objEvidenceCategory.Evidence_Category__c + '\'' + ' and Case__c = ' + '\'' + caseId + '\'' + ' and Evidence_Type__c = ' + '\'' + objEvidenceCategory.Evidence_Type__c+ '\'';
        }    
        else if(objEvidenceCategory.Evidence_Category__c != null  && objEvidenceCategory.Evidence_Type__c == null) {
               queryString += 'Where Evidence_Category__c = ' + '\'' +objEvidenceCategory.Evidence_Category__c + '\'' + ' and Case__c = ' + '\'' + caseId + '\''; 
        }
        System.debug ('queryString :::>>>' + queryString);
        
        if ( (objEvidenceStartDate.Disposition_Date__c != null ) ||  (objEvidenceEndDate.Disposition_Date__c != null ) ) {
                queryString += ' and id in (select Evidence_ID__c from Evidence_Tracking__c ';
                queryString += strDateQuery;
        }
        // queryString += strDateQuery;
        System.debug ('Final queryString :::>>>' + queryString);
        
        lstEvidence = Database.query(queryString);
    
        if (lstEvidence != null && lstEvidence.size() > 0)
          {
            lstWrpperEvidence = new  List<EvidenceWrapper>();
             for(Evidence__c  objEve : lstEvidence) {
                lstWrpperEvidence.add(new EvidenceWrapper(objEve));
             }
          }  
          else
          {
            lstWrpperEvidence = new  List<EvidenceWrapper>();
          }
    }
    public pagereference BackToCase(){
        pagereference pgBack=new pagereference('/'+caseId);
        pgBack.setredirect(true);
        return pgBack;
    }
    
  
    public list<Evidence__c > getlstEvidence(){      
        List<Evidence__c >temp = new list<Evidence__c  >();
       
        
        system.debug('lstWrpperEvidence-----'+lstWrpperEvidence.size());
        if(lstWrpperEvidence.size()>0){
            for(EvidenceWrapper cc: lstWrpperEvidence){
                system.debug('before if isSelected-----'+cc.isSelected);
                if(cc.isSelected){
                    system.debug('isSelected-----'+cc.isSelected);
                    temp.add(cc.ObjEvidence);  
                }
            }
        }
         system.debug('*********temp:'+temp);
        return temp;   
    }
    
   
    public pagereference CallFullReport(){
         lstEvidence = getlstEvidence();
        if(lstEvidence.size()<=0 || lstEvidence==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one record.'));
            return null;
        }   
        else{
             PageReference pg = new PageReference ('/apex/generateEvidenceFullReport');
             pg.setRedirect(false);
             return pg;
       }
       
    }  
    

    

}