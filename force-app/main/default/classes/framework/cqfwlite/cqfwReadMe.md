#Frameworks
Documentation on Frameworks built into this Package
## CQ-Lite

NEW Framework to streamline Request-Response and Trigger handling. Designed in order to ensure all future 
development is clean and concise. Any changes that occur can follow a similar pattern


## ActionBindings
Custom Metadata record that binds the Domain class for trigger handling. Current implementation is designed for an 
Outer Class <=> Inner Class construction. When creating a new Domain class for an sObject it requires a corresponding 
DomainActionBinding__mdt record in SFDC. The DomainActionBinding__mdt requires the following Paramters

**Label**  Record Name

**CQ Domain Action Binding Name** - MDT DeveloperName

**DomainActionImplementation** - String literal of Domain class
> Example. BehaviorEvaluationDomain

**sObject** - String Literal of sObject API Name

**Sequence** - Order in which Domain actions are executed 
> Note: Important in instances where Domain actions have dependencies are need to execute in a certain order


**TriggerdWhen** - What DML action fires Domain Action
> Insert, Update, Delete

**WhenTOProcess** - What process fires Domain Action
> Before, After

When DomainActionBinding__mdt record is created go to cq.cls file in Base Folder and add DomainActionBinding.

*Example*
```apex
public virtual TreatmentPlanDomain TreatmentPlanDomainBindings() {
    return (TreatmentPlanDomain) bindingFor(Treatment_Plan__c.SObjectType, TreatmentPlanDomain.class);
}
```

## Services
Service classes purpose is to handle complex logic for a specific sObject. Methods within a Service class process 
`ServiceRequest` 
and return `ServiceResponse`.

*Example* - Process ServiceRequest
```apex
Account account = new Account();
ServiceRequest request = new ServiceRequest();
request.Name = 'ExampleRequest';
request.Action = 'handleRequest';
request.WithParams('record', account);

AccountService service = new AccountService();

ServiceResponse serviceResponse = service.process(request);
System.debug(serviceResponse);

________________________________________________

public with sharing class AccountService {
    public static ServiceResponse process(ServiceRequest req) {
        switch on req.Action {
            when 'handleRequest' {
                return handleRequest(req);
            }when else {
                return null;
            }
        }
    private static ServiceResponse handleRequest(ServiceRequest request) {
        Account account = (Account) request.Parameters.get('record');
        
        account.Description = 'Handle Request executed';
        
        ServiceResponse response = new ServiceResponse(request);
        return response;
    }
}
```

## Selector

Selector class exist to query sObject fields for an sObject. Its purpose is to handle common queries related to a 
specific sObject. It performs optimally when used on common queries that return a List of records, though it can be 
configured to return single records.

*Example*

```apex
public with sharing class AccountSelector extends SObjectSelector {
    public AccountSelector() {
        super(Account.SObjectType);
    }

    public override Set<SObjectField> GetDefaultFields() {
        return new Set<SObjectField>{
                Account.Id,
                Account.Name,
                Account.Description,
                Account.BillingAddress
        };
    }

    public override List<iOrderBy> GetDefaultOrderBy() {
        return new List<iOrderBy>{
                OrderBy.Ascending(Account.Name),
                OrderBy.Ascending(Account.Id)
        };
    }
    /**
     * Inherits default queries from SOBjectSelector class
     * Constructor
     * @param ids Set<Id> Set of Ids to query by
     * @return List<sObject> list of sObjects queryied
     * In Example below it returns Account
     */
    

    public List<Account> GetById(Set<Id> ids) {
        return queryById(ids); 
    }
    /**
     * Returns all records with specified String in Name field
     * @param String name    String literal to query by
     * @return List<Account> list of records to return
     */
    
    public List<Account> GetByName(String name) { 
        return queryByName(name); 
    }

    /**
     * Returns all sObjects from an sObject
     */
    public List<Account> GetAll() {
        return queryAll();
    }

    /**
     * IReturns all sObjects limited by row Limit
     * @param Integer rowLimit 
     * @return    List<SOBject>
     */ 
    
    public List<Account> GetSome(Integer rowLimit) {
        return querySome(rowLimit);
    }
}
```

## Domain

Domain classes handle trigger logic for a specific sObject. Current itteration of Trigger Framework requires a 
domain calss to be structure like so.

```apex
public with sharing class AccountDomain extends DomainActionBase{
    public override void ProcessAction(TriggerRequest request) {
        if (request.targetSObject == Treatment_Plan__c.SObjectType) {
            String triggerAction = request.action + request.process;

            switch on triggerAction {
                when 'BeforeInsert' { beforeInsert(request); }
                when 'BeforeUpdate' { beforeUpdate(request); }
                when 'BeforeDelete' { beforeDelete(request);}
                when 'AfterInsert' { afterInsert(request);}
                when 'AfterUpdate' { afterUpdate(request);}
                when 'AfterDelete' { afterDelete(request);}
            }
        }
        return;
    }
    
    public void beforeInsert(TriggerRequest request) {
        List<Account> accounts = request.newRecords;
        
        for(Account account : accounts) {
            //ADD LOGIC FOR BEFORE INSERT HERE
        }
        
    }
}
```
The Trigger for the Account sObject will look like this:

```apex
trigger accountTrigger on Acount(before insert, before update, before delete, after insert, after update, after 
        delete, after undelete) {
    Trigger_Confic__c config = Trigger_Config__c.getInstance();
    if(!config.Disable_Triggers__c) {
        TriggerRequest request = new TriggerRequest(Account.SObjectType);
        AccountDomain domain = new AccountDomain();
        domain.ProcessAction(request);
    }
}
```

The Domain class inherits the `ProcessAction` method which is overriden in the `ProcessAction` method in 
AccountDomain. A Custom setting exist called `Trigger_Config__c` that can be used to disable and enable Triggers in 
the org. So long as all Triggers look for this setting prior to executing all Triggers can be turned on and off from 
Setup.

Anytime a 'before insert'