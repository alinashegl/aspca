/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

@IsTest
private class test_BehaviorEvaluationTrigger {
    @IsTest
    static void testBehavior() {
        User u = [SELECT Id, Email, Name FROM User WHERE Email = 'lbarnett@meetveracity.com'];
        String initials = 'LB';
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
            Behavior_Evaluation__c evaluation = new Behavior_Evaluation__c(
                    Behavior_in_Kennel__c = 'Social',
                    Animal__c = anim.Id,
                    Scribe_Initials__c = initials,
                    Tester_Initials__c = initials,
                    Handler_Initials__c = initials,
                    Comments_BIK__c = 'Test Comments for Unit Test',
                    Evaluation_Subtype__c = 'Adult Animal'
            );
            insert evaluation;
        }
        System.debug('@@@ RUNNING AS USER ==> ' + u.Name);
    }
}