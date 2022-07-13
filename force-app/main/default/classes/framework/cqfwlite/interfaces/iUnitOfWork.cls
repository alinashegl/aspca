/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public interface iUnitOfWork {
    // void OnRegisterType(Schema.SObjectType sObjectType);
    // void OnCommitWorkStarting();
    // void OnPublishBeforeEventsStarting();
    // void OnPublishBeforeEventsFinished();
    // void OnDMLStarting();
    // void OnDMLFinished();
    // void OnDoWorkStarting();
    // void OnDoWorkFinished();
    // void OnPublishAfterSuccessEventsStarting();
    // void OnPublishAfterSuccessEventsFinished();
    // void OnPublishAfterFailureEventsStarting();
    // void OnPublishAfterFailureEventsFinished();
    // void OnCommitWorkFinishing();
    // void OnCommitWorkFinished(Boolean wasSuccessful);

    // /**
    //  * Register a generic peace of work to be invoked during the commitWork phase
    //  *
    //  * @param   work    iWorker The work class which executes the requested sobject actions
    //  **/
    // void RegisterWork(iWorker work);

    // /**
    //  * Registers the given email to be sent during the commitWork
    //  *
    //  * @param   email   Messaging.Email
    //  **/
    // void RegisterEmail(Messaging.Email email);

    // /**
    //  * Register an deleted record to be removed from the recycle bin during the commitWork method
    //  *
    //  * @param   record  SObject An deleted record
    //  **/
    // void RegisterEmptyRecycleBin(SObject record);

    // /**
    //  * Register deleted records to be removed from the recycle bin during the commitWork method
    //  *
    //  * @param   records List<SObject>   Deleted records
    //  **/
    // void RegisterEmptyRecycleBin(List<SObject> records);

    // /**
    //  * Register a newly created SObject instance to be inserted when commitWork is called
    //  *
    //  * @param   record  SObject A newly created SObject instance to be inserted during commitWork
    //  **/
    // void RegisterNew(SObject record);

    // /**
    //  * Register a list of newly created SObject instances to be inserted when commitWork is called
    //  *
    //  * @param   records List<SObject>   A list of newly created SObject instances to be inserted during commitWork
    //  **/
    // void RegisterNew(List<SObject> records);

    // /**
    //  * Register a newly created SObject instance to be inserted when commitWork is called,
    //  *   you may also provide a reference to the parent record instance (should also be registered as new separately)
    //  *
    //  * @param   record                  SObject             A newly created SObject instance to be inserted during commitWork
    //  * @param   relatedToParentField    Schema.sObjectField A SObjectField reference to the child field that associates the child record with its parent
    //  * @param   relatedToParentRecord   SObject             A SObject instance of the parent record (should also be registered as new separately)
    //  **/
    // void RegisterNew(SObject record, Schema.sObjectField relatedToParentField, SObject relatedToParentRecord);

    // /**
    //  * Register a relationship between two records that have yet to be inserted to the database. This information will be
    //  *  used during the commitWork phase to make the references only when related records have been inserted to the database.
    //  *
    //  * @param   record          SObject             An existing or newly created record
    //  * @param   relatedToField  Schema.sObjectField A SObjectField reference to the lookup field that relates the two records together
    //  * @param   relatedTo       SObject             A SObject instance (yet to be committed to the database)
    //  **/
    // void RegisterRelationship(SObject record, Schema.sObjectField relatedToField, SObject relatedTo);

    // /**
    //  * Registers a relationship between a record and a Messaging.Email where the record has yet to be inserted
    //  *  to the database.  This information will be
    //  *  used during the commitWork phase to make the references only when related records have been inserted to the database.
    //  *
    //  * @param email     Messaging.SingleEmailMessage    A single email message instance
    //  * @param relatedTo SObject                         A SObject instance (yet to be committed to the database)
    //  */
    // void RegisterRelationship(Messaging.SingleEmailMessage email, SObject relatedTo);

    // /**
    //  * Registers a relationship between a record and a lookup value using an external ID field and a provided value. This
    //  * information will be used during the commitWork phase to make the lookup reference requested when inserted to the database.
    //  *
    //  * @param record            SObject             An existing or newly created record
    //  * @param relatedToField    Schema.sObjectField A SObjectField reference to the lookup field that relates the two records together
    //  * @param externalIdField   Schema.sObjectField A SObjectField reference to a field on the target SObject that is marked as isExternalId
    //  * @param externalId        Object              A Object representing the targetted value of the externalIdField in said lookup
    //  *
    //  * Usage Example: uow.registerRelationship(recordSObject, record_sobject__c.relationship_field__c, lookup_sobject__c.external_id__c, 'abc123');
    //  * Wraps putSObject, creating a new instance of the lookup sobject using the external id field and value.
    //  **/
    // void RegisterRelationship(SObject record, Schema.sObjectField relatedToField, Schema.sObjectField externalIdField, Object externalId);

    // /**
    //  * Register an existing record to be updated during the commitWork method
    //  *
    //  * @param   record  SObject An existing record
    //  **/
    // void RegisterDirty(SObject record);

    // /**
    //  * Register an existing record to be updated during the commitWork method
    //  *
    //  * @param   record      SObject                     An existing record
    //  * @param   dirtyFields List<Schema.SObjectField>   List of fields with data changes
    //  **/
    // void RegisterDirty(SObject record, List<Schema.SObjectField> dirtyFields);

    // /**
    //  * Register an existing record to be updated when commitWork is called,
    //  *   you may also provide a reference to the parent record instance (should also be registered as new separately)
    //  *
    //  * @param   record                  SObject             A newly created SObject instance to be inserted during commitWork
    //  * @param   relatedToParentField    Schema.sObjectField A SObjectField reference to the child field that associates the child record with its parent
    //  * @param   relatedToParentRecord   SObject             A SObject instance of the parent record (should also be registered as new separately)
    //  **/
    // void RegisterDirty(SObject record, Schema.sObjectField relatedToParentField, SObject relatedToParentRecord);

    // /**
    //  * Register a list of existing records to be updated during the commitWork method
    //  *
    //  * @param   records List<SObject>   A list of existing records
    //  **/
    // void RegisterDirty(List<SObject> records);

    // /**
    //  * Register a new or existing record to be inserted/updated during the commitWork method
    //  *
    //  * @param   record  SObject A new or existing record
    //  **/
    // void RegisterUpsert(SObject record);

    // /**
    //  * Register a list of mix of new and existing records to be inserted updated during the commitWork method
    //  *
    //  * @param   records List<SObject>   A list of mix of new and existing records
    //  **/
    // void RegisterUpsert(List<SObject> records);

    // /**
    //  * Register an existing record to be deleted during the commitWork method
    //  *
    //  * @param   record  SObject An existing record
    //  **/
    // void RegisterDeleted(SObject record);

    // /**
    //  * Register a list of existing records to be deleted during the commitWork method
    //  *
    //  * @param   records List<SObject>   A list of existing records
    //  **/
    // void RegisterDeleted(List<SObject> records);

    // /**
    //  * Register a list of existing records to be deleted and removed from the recycle bin during the commitWork method
    //  *
    //  * @param   records List<SObject>   A list of existing records
    //  **/
    // void RegisterPermanentlyDeleted(List<SObject> records);

    // /**
    //  * Register a list of existing records to be deleted and removed from the recycle bin during the commitWork method
    //  *
    //  * @param   record  SObject A record to be deleted
    //  **/
    // void RegisterPermanentlyDeleted(SObject record);

    // /**
    //  * Register a newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param   record  SObject A newly created SObject (Platform Event) instance to be inserted during commitWork
    //  **/
    // void RegisterPublishBeforeTransaction(SObject record);

    // /**
    //  * Register a list of newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param   records List<SObject>   A list of existing records
    //  **/
    // void RegisterPublishBeforeTransaction(List<SObject> records);

    // /**
    //  * Register a newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param   record  SObject A newly created SObject (Platform Event) instance to be inserted during commitWork
    //  **/
    // void registerPublishAfterSuccessTransaction(SObject record);

    // /**
    //  * Register a list of newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param records   List<SObject>   A list of existing records
    //  **/
    // void RegisterPublishAfterSuccessTransaction(List<SObject> records);

    // /**
    //  * Register a newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param record    SObject A newly created SObject (Platform Event) instance to be inserted during commitWork
    //  **/
    // void RegisterPublishAfterFailureTransaction(SObject record);

    // /**
    //  * Register a list of newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param records   List<SObject>   A list of existing records
    //  **/
    // void RegisterPublishAfterFailureTransaction(List<SObject> records);

    // /**
    //  * Takes all the work that has been registered with the UnitOfWork and commits it to the database
    //  **/
    // void CommitWork();

    // /**
    //  * Generates mock Id values for all SObjects in the stack, and handles their relations.
    //  */
    // void MockAllIdentities();

    // /**
    //  * Clears data that has been registered thus far. Used predominantly in mocking operations.
    //  */
    // void ClearRegisteredData();
}