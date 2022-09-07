/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public without sharing class TriggerRequest {
    public SObjectType targetSObject { get; set; }
    public Boolean isBefore { get; set; }
    public Boolean isAfter { get; set; }
    public Boolean isInsert { get; set; }
    public Boolean isUpdate { get; set; }
    public Boolean isDelete { get; set; }
    public List<SObject> newRecords { get; set; }
    public List<SObject> oldRecords { get; set; }
    public Map<Id, SObject> newRecordMap { get; set; }
    public Map<Id, SObject> oldRecordMap { get; set; }
    public String action { get { return isBefore ? 'Before' : 'After'; } }
    public String process {
        get {
            return isInsert ? 'Insert'
                    : isUpdate ? 'Update'
                            : isDelete ? 'Delete'
                                    : 'Unknown';
        }
    }

    public TriggerRequest(SObjectType target) {
        targetSObject = target;
        isBefore = false;
        isAfter = false;
        isInsert = false;
        isUpdate = false;
        isDelete = false;
        if (!Trigger.isExecuting) { return; }
        isBefore = Trigger.isBefore;
        isAfter = Trigger.isAfter;
        isInsert = Trigger.isInsert;
        isUpdate = Trigger.isUpdate;
        isDelete = Trigger.isDelete;
        newRecords = Trigger.new;
        newRecordMap = Trigger.newMap;
        if (Trigger.isInsert) { return; }
        oldRecords = Trigger.old;
        oldRecordMap = Trigger.oldMap;
    }

    public TriggerRequest SetBefore(Boolean state) { isBefore = state; return this; }
    public TriggerRequest SetAfter(Boolean state) { isAfter = state; return this; }
    public TriggerRequest SetInsert(Boolean state) { isInsert = state; return this; }
    public TriggerRequest SetUpdate(Boolean state) { isUpdate = state; return this; }
    public TriggerRequest SetDelete(Boolean state) { isDelete = state; return this; }
    public TriggerRequest SetNewRecords(List<SObject> data) { newRecords = data; return this; }
    public TriggerRequest SetNewRecordMap(Map<Id, SObject> data) { newRecordMap = data; return this; }
    public TriggerRequest SetOldRecords(List<SObject> data) { oldRecords = data; return this; }
    public TriggerRequest SetOldRecordMap(Map<Id, SObject> data) { oldRecordMap = data; return this; }


    public static TriggerRequest FromSvcRequest(ServiceRequest svc) {
        if (!svc.Parameters.containsKey('TriggerRequest')) { return null; }
        Object val = svc.Parameters.get('TriggerRequest');
        if (val instanceOf TriggerRequest) { return (TriggerRequest) val; }
        return null;
    }

}