public class BehaviorProfileSendEmail {

@InvocableMethod(label='Send Behavior Email Alert' description='Behavior Profile Send Email')
    public static void sendEmail(List<EmailRequest> requestList) {
        if(requestList.size() > 0 && requestList[0].behEvaluations != null){
            Behavior_Evaluation__c inputCollection = requestList[0].behEvaluations;
            List<Behavior_Evaluation__c> behEvaluations = [SELECT Animal__r.Gender__c, Animal__r.Current_Animal_Age_Formatted__c, Animal__r.Name, Animal__r.Animal_Name__c,
                                                           Animal__r.Color__c, Animal__r.Breed__c, Animal__r.Case__c, Animal__r.Petpoint_ID__c, 
                                                           Animal__r.AAH_ID__c, Animal__r.LastModifiedDate, Behavior_Evaluation_Summary__c, Animal__r.Placement_Recommendations__c,
                                                           Animal__r.Current_Behavior_Grade__c, Animal__r.Forensic_Behavior_Eval_Grade__c, Animal__r.Original_Animal_Name__c,
                                                           Animal__r.Behavior_Placement_Status__c, Animal__r.Approved_for_bath__c, Animal__r.Muzzle_needed_for_bath__c, 
                                                           Animal__r.Special_instructions_for_bath__c, Animal__r.Approved_for_Revolution__c, Animal__r.NYPD_Complaint__c,
                                                           Animal__r.Special_instructions_for_Revolution__c,Animal__r.Meets_Adoptability_Date__c
                                                           FROM Behavior_Evaluation__c
                                                           WHERE Id = : inputCollection.id];
            
            for(Behavior_Evaluation__c behEval: behEvaluations){
                sendEmailAlert(behEval);
            }
        }
    }
    
    private static void sendEmailAlert(Behavior_Evaluation__c behEval){
        List<String> emails = System.Label.BehaviorProfileEmailsSendOut.replaceAll('\\s+','-').split(',');
        List<User> users = [Select Id from user where email IN : emails];
        EmailTemplate et =[Select Id, Subject, Body, HtmlValue from EmailTemplate where DeveloperName= 'Behavior_Profile_Send_Emails'];
        if(emails.size() > 0 && users.size() > 0){
            
            String animalName = '';
            if(String.isNotBlank(behEval.Animal__r.Animal_Name__c) || String.isNotBlank(behEval.Animal__r.Original_Animal_Name__c)){
                if(String.isNotBlank(behEval.Animal__r.Animal_Name__c)){
                    animalName = behEval.Animal__r.Animal_Name__c;
                }
                if(String.isNotBlank(behEval.Animal__r.Original_Animal_Name__c)){
                    animalName = animalName + ' ' + behEval.Animal__r.Original_Animal_Name__c;
                }
            }
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            String textBody = et.HtmlValue.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Name}', animalName);
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Gender__c}', String.isNotBlank(behEval.Animal__r.Gender__c) ? behEval.Animal__r.Gender__c : '');
            textBody = textBody.replace('{!</span></font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.</span><span style="font-size: 12pt;">Current_Animal_Age_Formatted__c</span><span style="font-size: 12pt;">}', String.isNotBlank(behEval.Animal__r.Current_Animal_Age_Formatted__c) ? behEval.Animal__r.Current_Animal_Age_Formatted__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Color__c}', String.isNotBlank(behEval.Animal__r.Color__c) ? behEval.Animal__r.Color__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Breed__c}', String.isNotBlank(behEval.Animal__r.Breed__c) ? behEval.Animal__r.Breed__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Case__c}', String.isNotBlank(behEval.Animal__r.NYPD_Complaint__c) ? behEval.Animal__r.NYPD_Complaint__c : '');
            textBody = textBody.replace('{!</span></font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.</span><span style="font-size: 12pt;">Petpoint_ID__c</span><span style="font-size: 12pt;">}', String.isNotBlank(behEval.Animal__r.Petpoint_ID__c) ? behEval.Animal__r.Petpoint_ID__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.AAH_ID__c}', String.isNotBlank(behEval.Animal__r.AAH_ID__c) ? behEval.Animal__r.AAH_ID__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.LastModifiedDate}', String.isNotBlank(String.valueOf(behEval.Animal__r.LastModifiedDate)) ? String.valueOf(behEval.Animal__r.LastModifiedDate) : '');
            textBody = textBody.replace('{!</span>Behavior_Evaluation__c<span style="font-size: 12pt;">.</span>Behavior_Evaluation_Summary__c<span style="font-size: 12pt;">}', String.isNotBlank(behEval.Behavior_Evaluation_Summary__c) ? behEval.Behavior_Evaluation_Summary__c.replace('General Comments:', '') : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Placement_Recommendations__c}', String.isNotBlank(behEval.Animal__r.Placement_Recommendations__c) ? behEval.Animal__r.Placement_Recommendations__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><font face="arial" style="font-size: 12pt;">Animal__c.</font><span style="font-size: 12pt;">Current_Behavior_Grade__c</span><font face="arial" style="font-size: 12pt;">}', String.isNotBlank(behEval.Animal__r.Current_Behavior_Grade__c) ? behEval.Animal__r.Current_Behavior_Grade__c : '');
            textBody = textBody.replace('{!</span></font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.</span><span style="font-size: 12pt;">Forensic_Behavior_Eval_Grade__c</span><span style="font-size: 12pt;">}', String.isNotBlank(behEval.Animal__r.Forensic_Behavior_Eval_Grade__c) ? behEval.Animal__r.Forensic_Behavior_Eval_Grade__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Behavior_Placement_Status__c}', String.isNotBlank(behEval.Animal__r.Behavior_Placement_Status__c) ? behEval.Animal__r.Behavior_Placement_Status__c : '');
            textBody = textBody.replace('{!</span></font><span style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">Behavior_Evaluation__c</span><span style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">.</span><span style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">Animal__c.</span><font face="arial">Meets_Adoptability_Date__c<span style="font-size: 12pt;">}', String.isNotBlank(String.valueOf(behEval.Animal__r.Meets_Adoptability_Date__c)) ? String.valueOf(behEval.Animal__r.Meets_Adoptability_Date__c) : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Approved_for_bath__c}', String.isNotBlank(behEval.Animal__r.Approved_for_bath__c) ? behEval.Animal__r.Approved_for_bath__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Muzzle_needed_for_bath__c}', String.isNotBlank(behEval.Animal__r.Muzzle_needed_for_bath__c) ? behEval.Animal__r.Muzzle_needed_for_bath__c : '');
            textBody = textBody.replace('{!</span><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Special_instructions_for_bath__c}', String.isNotBlank(behEval.Animal__r.Special_instructions_for_bath__c) ? behEval.Animal__r.Special_instructions_for_bath__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Approved_for_Revolution__c}', String.isNotBlank(behEval.Animal__r.Approved_for_Revolution__c) ? behEval.Animal__r.Approved_for_Revolution__c : '');
            textBody = textBody.replace('{!</font><span style="font-size: 12pt;">Behavior_Evaluation__c</span><span style="font-size: 12pt;">.</span><span style="font-size: 12pt;">Animal__c.Special_instructions_for_Revolution}', String.isNotBlank(behEval.Animal__r.Special_instructions_for_Revolution__c) ? behEval.Animal__r.Special_instructions_for_Revolution__c : '');
            textBody = textBody.replace('<![CDATA[', '').replace(']]>','');
            message.setToAddresses(emails);
            message.setTemplateId(et.id);
            message.setSubject(et.Subject.replace('{!Behavior_Evaluation__c.Animal__c.Animal_Name__c}',behEval.Animal__r.Animal_Name__c));
            
            message.setHtmlBody(textBody);
            message.saveAsActivity = false;
            message.setTargetobjectid(users[0].Id);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }  
    
    public class EmailRequest {
        @InvocableVariable(required=true)
        public Behavior_Evaluation__c behEvaluations;
    }
}