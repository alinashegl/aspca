public class SeizureEmailNotificationController { 
    public static void handleSeizureEmailNotificationSchedular(){
        String[] locations = new String[]{'CRC','MRC','CRC/MRC'};
        Map<Id, List<Animal__c>> animalsRec = new  Map<Id, List<Animal__c>>();

        List<Animal__c> lstAnimals =[
            SELECT Id ,Name, Animal_Name_Id__c,Animal_Name__c,Gender__c,Current_Behavior_Grade__c,Surrender_Type__c, Email_Notification__c,
            Play_Category__c, Seizure_Surrender_Date__c,Current_Recent_Shelter_Location__c, Behavior_Case_Worker__c,
            (SELECT Id, Treatment_Priority__c FROM Treatment_Plan__r WHERE IsActive__c = true ORDER BY CreatedDate DESC LIMIT 1) 
            FROM Animal__c where Email_Notification__c =: true 
            AND Current_Recent_Shelter_Location__c IN :locations
            AND Active_Animal__c = true
        ];
        List<Animal__c> animalValues = null;   
        if(!lstAnimals.isEmpty()){
            for(Animal__c anm : lstAnimals){
                if(!animalsRec.containsKey(anm.Behavior_Case_Worker__c)){
                    animalValues = new  List<Animal__c>();
                }
                animalValues.add(anm);
                animalsRec.put(anm.Behavior_Case_Worker__c, animalValues);
            }
                    
            Map<Id, List<String>> contactByIdEmail  = new  Map<Id, List<String>> ();
            List<Contact> lstcontatcs = [Select Id,ReportsToId, ReportsTo.Email, Email from Contact where Id IN : animalsRec.keySet()];
            List<String> emails = new List<String>();
            for (Contact conn : lstcontatcs) {
                if(conn.ReportsToId != null && conn.ReportsTo.Email != null){
                    emails.add(conn.ReportsTo.Email);
                }
                if(conn.Email != null){
                    emails.add(conn.Email);
                }
                if(!emails.isEmpty()){
                    contactByIdEmail.put(conn.Id, emails);
                    emails = new List<String>();
                }
            }
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Date dtTodayDate = System.Today();
            Datetime dtTodayDateTime = datetime.newInstance(dtTodayDate.year(), dtTodayDate.month(),dtTodayDate.day());
            string strDate = dtTodayDateTime.format('MM/dd/yyyy');
            //for (Id conId : contactByIdEmail.keySet()) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{'scott.silvestro@aspca.org','Lauren.Zverina@aspca.org','katy.mahaley@aspca.org'});
                //mail.setToAddresses(contactByIdEmail.get(conId));
                //mail.setCcAddresses(new List<String> {'CRCBehaviorMgmt@aspca.org'});
                mail.setSubject('Animal surrender notification');
                String td1='"border:1px solid green; width=200px;"';
                String tdHead= '"border:1px solid green; width=200px; color:white; background-color:green; font-weight:bold;"';
                
                String htmlBody = 'Hello Manager! <br/>This is the ownership report for '+strDate+'.<br/><br/><center><table style="border:3px solid green; border-collapse:collapse;">';
                htmlBody  = htmlBody + '<thead>'
                            + '<tr>'
                                + '<th style='+ tdHead +'>Name</th>'
                                + '<th style='+ tdHead +'>Sex</th>'
                                + '<th style='+ tdHead +'>Current Behavior</th>'
                                + '<th style='+ tdHead +'>Treatment Priority</th>'
                                + '<th style='+ tdHead +'>Play Category</th>'
                                + '<th style='+ tdHead +'>Surrender Date</th>'
                                + '<th style='+ tdHead +'>Surrender Type</th>'
                            + '</tr>'
                            + '</thead><tbody>';
                //List<Animal__c> animals = animalsRec.get(conId);

                //for (Animal__c anm : animals) {
                List<Animal__c> animalList = new List<Animal__c>();
                for (Animal__c anm : lstAnimals) {
                    String animalName = anm.Animal_Name_Id__c == null ? '': anm.Animal_Name_Id__c;
                    String animalGender = anm.Gender__c == null ? '': anm.Gender__c;
                    String animalCurrBehvGrade = anm.Current_Behavior_Grade__c == null ? '': anm.Current_Behavior_Grade__c;
                        String animalPlayPriority = '';
                        if(anm.Treatment_Plan__r != null && anm.Treatment_Plan__r.size() > 0){
                            animalPlayPriority = anm.Treatment_Plan__r[0]. Treatment_Priority__c;
                        }
                        
                    String animalPlayCategory = anm.Play_Category__c == null ? '': anm.Play_Category__c;
                    Date animalSurrDate = anm.Seizure_Surrender_Date__c;
                    String animalsurrenderType = anm.Surrender_Type__c == null ? '': anm.Surrender_Type__c; 
                    htmlBody = htmlBody +   '<tr>'
                                        + '<td style='+ td1 +'>'+ animalName +'</td>'
                                        + '<td style='+ td1 +'>'+ animalGender +'</td>'
                                        + '<td style='+ td1 +'>'+ animalCurrBehvGrade +'</td>'
                                        + '<td style='+ td1 +'>'+ animalPlayPriority +'</td>'
                                        + '<td style='+ td1 +'>'+ animalPlayCategory +'</td>'
                                        + '<td style='+ td1 +'>'+ String.valueOf(animalSurrDate) +'</td>'
                                        + '<td style='+ td1 +'>'+ animalsurrenderType +'</td>'
                                        + '</tr>'; 
                    anm.Email_Notification__c = false;
                    // animalList.add(anm);
                }
                htmlBody = htmlBody + '</tbody></table></center>';
                
                mail.setHtmlBody(htmlBody);
                system.debug(htmlBody);
                mails.add(mail);
            //}
            if(test.isRunningTest()){
                if(!lstAnimals.isEmpty()){
                    update lstAnimals;
                }
            } else {
                if (mails.size() > 0){
                    try{
                        Messaging.sendEmail(mails);
                        if(!lstAnimals.isEmpty()){
                            update lstAnimals;
                        }
                    } catch(exception ex){
                        system.debug('error '+ ex );
                    }
                }
            }
        }
    }
}