/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public without sharing class DomainActionBindingSelector  extends SObjectSelector{
    public DomainActionBindingSelector() { super(Domain_Action_Binding__mdt.SObjectType); }

    // implement required GetDefaultFields() method
    public override Set<Schema.SObjectField> GetDefaultFields() {
        return new Set<Schema.SObjectField> {
                Domain_Action_Binding__mdt.SObject__c,
                Domain_Action_Binding__mdt.WhenToProcess__c,
                Domain_Action_Binding__mdt.TriggeredWhen__c,
                Domain_Action_Binding__mdt.DomainActionImplementation__c,
                Domain_Action_Binding__mdt.Sequence__c
        };
    }

    // implement required GetDefaultOrderBy() method
    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy> {
                (iOrderBy) OrderBy.Ascending(Domain_Action_Binding__mdt.Sequence__c),
                (iOrderBy) OrderBy.Ascending(Domain_Action_Binding__mdt.DomainActionImplementation__c)
        };
    }

    /**
     * Query for retrieving Trigger-specific DomainAction bindings
     * @param  targetSObject String     The SObject the Trigger is executing on
     * @param  process       process    Before/After
     * @param  action        action     Insert/Update/Delete
     * @return  List of Domain_Action_Binding__mdt entries
     */
    public List<Domain_Action_Binding__mdt> GetForTrigger(String targetSObject, String process, String action) {
        iQueryFactory qf = GetQueryFactory()
                .WithCriteria(Criteria.Equals(Domain_Action_Binding__mdt.SObject__c, targetSObject))
                .WithCriteria(Criteria.Equals(Domain_Action_Binding__mdt.WhenToProcess__c, process))
                .WithCriteria(Criteria.Equals(Domain_Action_Binding__mdt.TriggeredWhen__c, action));
        // THE PROCESS BELOW SHOULD ONLY BE REPEATED FOR CMDT SOBJECTS
        // YOU CAN NOT INSERT CMDT DURING A UNIT TEST, SO THIS HACK LETS THE UNIT TESTS HAPPEN
        // DO NOT REPEAT THIS PATTERN IN A NORMAL SOBJECT SELECTOR
        if (Test.isRunningTest()) {
            String sObjectName = Account.getSObjectType().getDescribe().getName();
            return new List<Domain_Action_Binding__mdt>{
                    new Domain_Action_Binding__mdt(
                            SObject__c = sObjectName,
                            WhenToProcess__c = 'Before',
                            TriggeredWhen__c = 'Insert',
                            DomainActionImplementation__c = 'cqtest_SObjectDomain.testDomainActionOne',
                            Sequence__c = 10
                    ),
                    new Domain_Action_Binding__mdt(
                            SObject__c = sObjectName,
                            WhenToProcess__c = 'Before',
                            TriggeredWhen__c = 'Insert',
                            DomainActionImplementation__c = 'cqtest_SObjectDomain.testDomainActionOnenTwo',
                            Sequence__c = 10
                    )
            };
        } else {
            return (List<Domain_Action_Binding__mdt>) qf.Execute();
        }
    }
}