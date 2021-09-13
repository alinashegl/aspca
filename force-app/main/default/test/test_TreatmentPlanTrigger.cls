/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_TreatmentPlanTrigger {
    @IsTest
    static void regressionCoverage() {
        User u = [SELECT Id, Email, Name FROM User WHERE Email = 'lbarnett@meetveracity.com'];
        System.runAs(u){
            Case cs = new Case();
            insert cs;

            Animal__c anim = new Animal__c(
                    Name = 'Test',
                    Case__c=cs.Id,
                    Type_of_Animal__c='Dog',
                    Color__c = 'Black',
                    Age__c='Unknown At Intake'
            );
            insert anim;

            Opportunity plan = new Opportunity(
                    Name = 'Test',
                    CloseDate = Date.today().addDays(90),
                    StageName = 'Qualification',
                    Animal__c = anim.Id
            );
            insert plan;
        }
        System.debug('@@@ RUNNING AS USER ==> ' + u.Name);

    }
}