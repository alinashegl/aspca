/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class UnitOfWork implements iUnitOfWork{
    // protected List<Schema.SObjectType> m_sObjectTypes = new List<Schema.SObjectType>();
    // protected Map<String, List<SObject>> m_newListByType = new Map<String, List<SObject>>();
    // protected Map<String, Map<Id, SObject>> m_dirtyMapByType = new Map<String, Map<Id, SObject>>();
    // protected Map<String, Map<Id, SObject>> m_deletedMapByType = new Map<String, Map<Id, SObject>>();
    // protected Map<String, Map<Id, SObject>> m_emptyRecycleBinMapByType = new Map<String, Map<Id, SObject>>();
    // protected Map<String, Relationships> m_relationships = new Map<String, Relationships>();
    // protected Map<String, List<SObject>> m_publishBeforeListByType = new Map<String, List<SObject>>();
    // protected Map<String, List<SObject>> m_publishAfterSuccessListByType = new Map<String, List<SObject>>();
    // protected Map<String, List<SObject>> m_publishAfterFailureListByType = new Map<String, List<SObject>>();
    // protected List<iWorker> m_workList = new List<iWorker>();

    // @TestVisible
    // protected iEmailWork m_emailWork = new SendEmailWork();

    // protected iDML m_dml;

    // public interface iDML {
    //     void dmlInsert(List<SObject> objList);
    //     void dmlUpdate(List<SObject> objList);
    //     void dmlDelete(List<SObject> objList);
    //     void eventPublish(List<SObject> objList);
    //     void emptyRecycleBin(List<SObject> objList);
    // }

    // public class SimpleDML implements iDML {
    //     public void dmlInsert(List<SObject> objList) { insert objList; }
    //     public void dmlUpdate(List<SObject> objList) { update objList; }
    //     public void dmlDelete(List<SObject> objList) { delete objList; }
    //     public void eventPublish(List<SObject> objList) { EventBus.publish(objList); }
    //     public void emptyRecycleBin(List<SObject> objList) {
    //         if (objList.isEmpty()) { return; }
    //         Database.emptyRecycleBin(objList);
    //     }
    // }

    // /**
    //  * Constructs a new UnitOfWork to support work against the given object list
    //  *
    //  * @param   sObjectTypes    List<Schema.SObjectType>    A list of objects given in dependency order (least dependent first)
    //  **/
    // public UnitOfWork(List<Schema.SObjectType> sObjectTypes) {
    //     this(sObjectTypes, new SimpleDML());
    // }

    // public UnitOfWork(List<Schema.SObjectType> sObjectTypes, iDML dml) {
    //     m_sObjectTypes = sObjectTypes.clone();
    //     for (Schema.SObjectType sObjectType : m_sObjectTypes) {
    //         // register the type
    //         handleRegisterType(sObjectType);
    //     }
    //     m_relationships.put(Messaging.SingleEmailMessage.class.getName(), new Relationships());
    //     m_dml = dml;
    // }

    // // default implementations for commitWork events
    // public virtual void OnRegisterType(Schema.SObjectType sObjectType) {}
    // public virtual void OnCommitWorkStarting() {}
    // public virtual void OnPublishBeforeEventsStarting() {}
    // public virtual void OnPublishBeforeEventsFinished() {}
    // public virtual void OnDMLStarting() {}
    // public virtual void OnDMLFinished() {}
    // public virtual void OnDoWorkStarting() {}
    // public virtual void OnDoWorkFinished() {}
    // public virtual void OnPublishAfterSuccessEventsStarting() {}
    // public virtual void OnPublishAfterSuccessEventsFinished() {}
    // public virtual void OnPublishAfterFailureEventsStarting() {}
    // public virtual void OnPublishAfterFailureEventsFinished() {}
    // public virtual void OnCommitWorkFinishing() {}
    // public virtual void OnCommitWorkFinished(Boolean wasSuccessful) {}

    // /**
    //  * Registers the type to be used for DML operations
    //  *
    //  * @param   sObjectType Schema.SObjectType  The type to register
    //  **/
    // private void handleRegisterType(Schema.SObjectType sObjectType) {
    //     String sObjectName = SchemaHelper.GetDescribe(sObjectType).getName();
    //     // add type to dml operation tracking
    //     m_newListByType.put(sObjectName, new List<SObject>());
    //     m_dirtyMapByType.put(sObjectName, new Map<Id, SObject>());
    //     m_deletedMapByType.put(sObjectName, new Map<Id, SObject>());
    //     m_emptyRecycleBinMapByType.put(sObjectName, new Map<Id, SObject>());
    //     m_relationships.put(sObjectName, new Relationships());
    //     m_publishBeforeListByType.put(sObjectName, new List<SObject>());
    //     m_publishAfterSuccessListByType.put(sObjectName, new List<SObject>());
    //     m_publishAfterFailureListByType.put(sObjectName, new List<SObject>());
    //     // give derived class opportunity to register the type
    //     onRegisterType(sObjectType);
    // }

    // /**
    //  * Register a generic peace of work to be invoked during the commitWork phase
    //  *
    //  * @param   work    iWorker The work class which executes the requested sobject actions
    //  **/
    // public void RegisterWork(iWorker work) {
    //     m_workList.add(work);
    // }

    // /**
    //  * Registers the given email to be sent during the commitWork
    //  *
    //  * @param   email   Messaging.Email
    //  **/
    // public void RegisterEmail(Messaging.Email email) {
    //     m_emailWork.registerEmail(email);
    // }

    // /**
    //  * Register an deleted record to be removed from the recycle bin during the commitWork method
    //  *
    //  * @param   record  SObject An deleted record
    //  **/
    // public void RegisterEmptyRecycleBin(SObject record) {
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     assertForSupportedSObjectType(m_emptyRecycleBinMapByType, sObjectType);
    //     m_emptyRecycleBinMapByType.get(sObjectType).put(record.Id, record);
    // }

    // /**
    //  * Register deleted records to be removed from the recycle bin during the commitWork method
    //  *
    //  * @param   records List<SObject>   Deleted records
    //  **/
    // public void RegisterEmptyRecycleBin(List<SObject> records) {
    //     for (SObject record : records) {
    //         registerEmptyRecycleBin(record);
    //     }
    // }

    // /**
    //  * Register a newly created SObject instance to be inserted when commitWork is called
    //  *
    //  * @param   record  SObject A newly created SObject instance to be inserted during commitWork
    //  **/
    // public void RegisterNew(SObject record) {
    //     registerNew(record, null, null);
    // }

    // /**
    //  * Register a list of newly created SObject instances to be inserted when commitWork is called
    //  *
    //  * @param   records List<SObject>   A list of newly created SObject instances to be inserted during commitWork
    //  **/
    // public void RegisterNew(List<SObject> records) {
    //     for (SObject record : records) {
    //         registerNew(record, null, null);
    //     }
    // }

    // /**
    //  * Register a newly created SObject instance to be inserted when commitWork is called,
    //  *   you may also provide a reference to the parent record instance (should also be registered as new separately)
    //  *
    //  * @param   record                  SObject             A newly created SObject instance to be inserted during commitWork
    //  * @param   relatedToParentField    Schema.sObjectField A SObjectField reference to the child field that associates the child record with its parent
    //  * @param   relatedToParentRecord   SObject             A SObject instance of the parent record (should also be registered as new separately)
    //  **/
    // public void RegisterNew(SObject record, Schema.sObjectField relatedToParentField, SObject relatedToParentRecord) {
    //     if (record.Id != null)
    //         throw new UnitOfWorkException('Only new records can be registered as new');
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     assertForNonEventSObjectType(sObjectType);
    //     assertForSupportedSObjectType(m_newListByType, sObjectType);
    //     m_newListByType.get(sObjectType).add(record);
    //     if (relatedToParentRecord!=null && relatedToParentField!=null)
    //         registerRelationship(record, relatedToParentField, relatedToParentRecord);
    // }

    // /**
    //  * Register a relationship between two records that have yet to be inserted to the database. This information will be
    //  *  used during the commitWork phase to make the references only when related records have been inserted to the database.
    //  *
    //  * @param   record          SObject             An existing or newly created record
    //  * @param   relatedToField  Schema.sObjectField A SObjectField reference to the lookup field that relates the two records together
    //  * @param   relatedTo       SObject             A SObject instance (yet to be committed to the database)
    //  **/
    // public void RegisterRelationship(SObject record, Schema.sObjectField relatedToField, SObject relatedTo) {
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     assertForNonEventSObjectType(sObjectType);
    //     assertForSupportedSObjectType(m_newListByType, sObjectType);
    //     m_relationships.get(sObjectType).add(record, relatedToField, relatedTo);
    // }

    // /**
    //  * Registers a relationship between a record and a Messaging.Email where the record has yet to be inserted
    //  *  to the database.  This information will be
    //  *  used during the commitWork phase to make the references only when related records have been inserted to the database.
    //  *
    //  * @param email     Messaging.SingleEmailMessage    A single email message instance
    //  * @param relatedTo SObject                         A SObject instance (yet to be committed to the database)
    //  */
    // public void RegisterRelationship(Messaging.SingleEmailMessage email, SObject relatedTo ) {
    //     m_relationships.get( Messaging.SingleEmailMessage.class.getName() ).add(email, relatedTo);
    // }

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
    // public void RegisterRelationship(SObject record, Schema.sObjectField relatedToField, Schema.sObjectField externalIdField, Object externalId) {
    //     // NOTE: Due to the lack of ExternalID references on Standard Objects, this method can not be provided a standardized Unit Test. - Rick Parker
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     if(!m_newListByType.containsKey(sObjectType))
    //         throw new UnitOfWorkException(String.format('SObject type {0} is not supported by this unit of work', new String[] { sObjectType }));
    //     m_relationships.get(sObjectType).add(record, relatedToField, externalIdField, externalId);
    // }

    // /**
    //  * Register an existing record to be updated during the commitWork method
    //  *
    //  * @param   record  SObject An existing record
    //  **/
    // public void RegisterDirty(SObject record) {
    //     registerDirty(record, new List<SObjectField>());
    // }

    // /**
    //  * Register an existing record to be updated during the commitWork method
    //  *
    //  * @param   record      SObject                     An existing record
    //  * @param   dirtyFields List<Schema.SObjectField>   List of fields with data changes
    //  **/
    // public void RegisterDirty(SObject record, List<Schema.SObjectField> dirtyFields) {
    //     if (record.Id == null) {
    //         throw new UnitOfWorkException('New records cannot be registered as dirty');
    //     }
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     assertForNonEventSObjectType(sObjectType);
    //     assertForSupportedSObjectType(m_dirtyMapByType, sObjectType);
    //     // If record isn't registered as dirty, or no dirty fields to drive a merge
    //     if (!m_dirtyMapByType.get(sObjectType).containsKey(record.Id) || dirtyFields.isEmpty()) {
    //         // Register the record as dirty
    //         m_dirtyMapByType.get(sObjectType).put(record.Id, record);
    //     } else {
    //         // Update the registered record's fields
    //         SObject registeredRecord = m_dirtyMapByType.get(sObjectType).get(record.Id);

    //         for (SObjectField dirtyField : dirtyFields) {
    //             registeredRecord.put(dirtyField, record.get(dirtyField));
    //         }

    //         m_dirtyMapByType.get(sObjectType).put(record.Id, registeredRecord);
    //     }
    // }

    // /**
    //  * Register an existing record to be updated when commitWork is called,
    //  *   you may also provide a reference to the parent record instance (should also be registered as new separately)
    //  *
    //  * @param   record                  SObject             A newly created SObject instance to be inserted during commitWork
    //  * @param   relatedToParentField    Schema.sObjectField A SObjectField reference to the child field that associates the child record with its parent
    //  * @param   relatedToParentRecord   SObject             A SObject instance of the parent record (should also be registered as new separately)
    //  **/
    // public void RegisterDirty(SObject record, Schema.sObjectField relatedToParentField, SObject relatedToParentRecord) {
    //     if (record.Id == null) {
    //         throw new UnitOfWorkException('New records cannot be registered as dirty');
    //     }
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     assertForNonEventSObjectType(sObjectType);
    //     assertForSupportedSObjectType(m_dirtyMapByType, sObjectType);
    //     m_dirtyMapByType.get(sObjectType).put(record.Id, record);
    //     if (relatedToParentRecord != null && relatedToParentField != null) {
    //         registerRelationship(record, relatedToParentField, relatedToParentRecord);
    //     }
    // }

    // /**
    //  * Register a list of existing records to be updated during the commitWork method
    //  *
    //  * @param   records List<SObject>   A list of existing records
    //  **/
    // public void RegisterDirty(List<SObject> records) {
    //     for (SObject record : records) {
    //         this.RegisterDirty(record);
    //     }
    // }

    // /**
    //  * Register a new or existing record to be inserted/updated during the commitWork method
    //  *
    //  * @param   record  SObject A new or existing record
    //  **/
    // public void RegisterUpsert(SObject record) {
    //     if (record.Id == null) {
    //         this.RegisterNew(record, null, null);
    //     } else {
    //         this.RegisterDirty(record, new List<SObjectField>());
    //     }
    // }

    // /**
    //  * Register a list of mix of new and existing records to be inserted updated during the commitWork method
    //  *
    //  * @param   records List<SObject>   A list of mix of new and existing records
    //  **/
    // public void RegisterUpsert(List<SObject> records) {
    //     for (SObject record : records) {
    //         this.RegisterUpsert(record);
    //     }
    // }

    // /**
    //  * Register an existing record to be deleted during the commitWork method
    //  *
    //  * @param   record  SObject An existing record
    //  **/
    // public void RegisterDeleted(SObject record) {
    //     if (record.Id == null) {
    //         throw new UnitOfWorkException('New records cannot be registered for deletion');
    //     }
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     assertForNonEventSObjectType(sObjectType);
    //     assertForSupportedSObjectType(m_deletedMapByType, sObjectType);
    //     m_deletedMapByType.get(sObjectType).put(record.Id, record);
    // }

    // /**
    //  * Register a list of existing records to be deleted during the commitWork method
    //  *
    //  * @param   records List<SObject>   A list of existing records
    //  **/
    // public void RegisterDeleted(List<SObject> records) {
    //     for (SObject record : records) {
    //         this.RegisterDeleted(record);
    //     }
    // }

    // /**
    //  * Register a list of existing records to be deleted and removed from the recycle bin during the commitWork method
    //  *
    //  * @param   records List<SObject>   A list of existing records
    //  **/
    // public void RegisterPermanentlyDeleted(List<SObject> records) {
    //     this.RegisterEmptyRecycleBin(records);
    //     this.RegisterDeleted(records);
    // }

    // /**
    //  * Register a list of existing records to be deleted and removed from the recycle bin during the commitWork method
    //  *
    //  * @param   record  SObject A record to be deleted
    //  **/
    // public void RegisterPermanentlyDeleted(SObject record) {
    //     this.RegisterEmptyRecycleBin(record);
    //     this.RegisterDeleted(record);
    // }

    // /**
    //  * Register a newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param   record  SObject A newly created SObject (Platform Event) instance to be inserted during commitWork
    //  **/
    // public void RegisterPublishBeforeTransaction(SObject record) {
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     assertForEventSObjectType(sObjectType);
    //     assertForSupportedSObjectType(m_publishBeforeListByType, sObjectType);
    //     m_publishBeforeListByType.get(sObjectType).add(record);
    // }

    // /**
    //  * Register a list of newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param   records List<SObject>   A list of existing records
    //  **/
    // public void RegisterPublishBeforeTransaction(List<SObject> records) {
    //     for (SObject record : records) {
    //         this.registerPublishBeforeTransaction(record);
    //     }
    // }

    // /**
    //  * Register a newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param   record  SObject A newly created SObject (Platform Event) instance to be inserted during commitWork
    //  **/
    // public void registerPublishAfterSuccessTransaction(SObject record) {
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     assertForEventSObjectType(sObjectType);
    //     assertForSupportedSObjectType(m_publishAfterSuccessListByType, sObjectType);
    //     m_publishAfterSuccessListByType.get(sObjectType).add(record);
    // }

    // /**
    //  * Register a list of newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param records   List<SObject>   A list of existing records
    //  **/
    // public void RegisterPublishAfterSuccessTransaction(List<SObject> records) {
    //     for (SObject record : records) {
    //         this.RegisterPublishAfterSuccessTransaction(record);
    //     }
    // }

    // /**
    //  * Register a newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param record    SObject A newly created SObject (Platform Event) instance to be inserted during commitWork
    //  **/
    // public void RegisterPublishAfterFailureTransaction(SObject record) {
    //     String sObjectType = SchemaHelper.GetDescribe(record.getSObjectType()).getName();
    //     assertForEventSObjectType(sObjectType);
    //     assertForSupportedSObjectType(m_publishAfterFailureListByType, sObjectType);
    //     m_publishAfterFailureListByType.get(sObjectType).add(record);
    // }

    // /**
    //  * Register a list of newly created SObject (Platform Event) instance to be published when commitWork is called
    //  *
    //  * @param records   List<SObject>   A list of existing records
    //  **/
    // public void RegisterPublishAfterFailureTransaction(List<SObject> records) {
    //     for (SObject record : records) {
    //         this.registerPublishAfterFailureTransaction(record);
    //     }
    // }

    // /**
    //  * Takes all the work that has been registered with the UnitOfWork and commits it to the database
    //  **/
    // public void CommitWork() {
    //     if (!allowCommitWork) { return; }
    //     Savepoint sp = Database.setSavePoint();
    //     Boolean wasSuccessful = false;
    //     try {
    //         doCommitWork();
    //         wasSuccessful = true;
    //     } catch (Exception e) {
    //         Database.rollback(sp);
    //         throw e;
    //     } finally {
    //         doAfterCommitWorkSteps(wasSuccessful);
    //     }
    // }

    // private void doCommitWork() {
    //     OnCommitWorkStarting();
    //     OnPublishBeforeEventsStarting();
    //     publishBeforeEventsStarting();
    //     OnPublishBeforeEventsFinished();

    //     OnDMLStarting();
    //     insertDmlByType();
    //     updateDmlByType();
    //     deleteDmlByType();
    //     emptyRecycleBinByType();
    //     resolveEmailRelationships();
    //     OnDMLFinished();

    //     OnDoWorkStarting();
    //     doWork();
    //     OnDoWorkFinished();
    //     OnCommitWorkFinishing();
    // }

    // private void doAfterCommitWorkSteps(Boolean wasSuccessful) {
    //     if (wasSuccessful) {
    //         doAfterCommitWorkSuccessSteps();
    //     } else {
    //         doAfterCommitWorkFailureSteps();
    //     }
    //     OnCommitWorkFinished(wasSuccessful);
    // }

    // private void doAfterCommitWorkSuccessSteps() {
    //     OnPublishAfterSuccessEventsStarting();
    //     publishAfterSuccessEvents();
    //     OnPublishAfterSuccessEventsFinished();
    // }

    // private void doAfterCommitWorkFailureSteps() {
    //     OnPublishAfterFailureEventsStarting();
    //     publishAfterFailureEvents();
    //     OnPublishAfterFailureEventsFinished();
    // }

    // private void publishBeforeEventsStarting() {
    //     for (Schema.SObjectType sObjectType : m_sObjectTypes) {
    //         m_dml.eventPublish(m_publishBeforeListByType.get(SchemaHelper.GetDescribe(sObjectType).getName()));
    //     }
    // }

    // private void insertDmlByType() {
    //     for (Schema.SObjectType sObjectType : m_sObjectTypes) {
    //         m_relationships.get(SchemaHelper.GetDescribe(sObjectType).getName()).resolve();
    //         if (SchemaHelper.IsSetupSObject(sObjectType)) {
    //             System.runAs ( new User(Id = UserInfo.getUserId()) ) {
    //                 m_dml.dmlInsert(m_newListByType.get(SchemaHelper.GetDescribe(sObjectType).getName()));
    //             }
    //         } else {
    //             m_dml.dmlInsert(m_newListByType.get(SchemaHelper.GetDescribe(sObjectType).getName()));
    //         }
    //     }
    // }

    // private void updateDmlByType() {
    //     for (Schema.SObjectType sObjectType : m_sObjectTypes) {
    //         if (SchemaHelper.IsSetupSObject(sObjectType)) {
    //             System.runAs ( new User(Id = UserInfo.getUserId()) ) {
    //                 m_dml.dmlUpdate(m_dirtyMapByType.get(SchemaHelper.GetDescribe(sObjectType).getName()).values());
    //             }
    //         } else {
    //             m_dml.dmlUpdate(m_dirtyMapByType.get(SchemaHelper.GetDescribe(sObjectType).getName()).values());
    //         }
    //     }
    // }

    // private void deleteDmlByType() {
    //     Integer objectIdx = m_sObjectTypes.size() - 1;
    //     while (objectIdx >= 0) {
    //         m_dml.dmlDelete(m_deletedMapByType.get(SchemaHelper.GetDescribe(m_sObjectTypes[objectIdx--]).getName()).values());
    //     }
    // }

    // private void emptyRecycleBinByType() {
    //     Integer objectIdx = m_sObjectTypes.size() - 1;
    //     while (objectIdx >= 0) {
    //         m_dml.emptyRecycleBin(m_emptyRecycleBinMapByType.get(SchemaHelper.GetDescribe(m_sObjectTypes[objectIdx--]).getName()).values());
    //     }
    // }

    // private void resolveEmailRelationships() {
    //     m_relationships.get(Messaging.SingleEmailMessage.class.getName()).resolve();
    // }

    // private void doWork() {
    //     m_workList.add(m_emailWork);
    //     for (iWorker work : m_workList) {
    //         work.DoWork();
    //     }
    // }

    // private void publishAfterSuccessEvents() {
    //     for (Schema.SObjectType sObjectType : m_sObjectTypes) {
    //         m_dml.eventPublish(m_publishAfterSuccessListByType.get(SchemaHelper.GetDescribe(sObjectType).getName()));
    //     }
    // }

    // private void publishAfterFailureEvents() {
    //     for (Schema.SObjectType sObjectType : m_sObjectTypes) {
    //         m_dml.eventPublish(m_publishAfterFailureListByType.get(SchemaHelper.GetDescribe(sObjectType).getName()));
    //     }
    // }

    // private void assertForNonEventSObjectType(String sObjectType) {
    //     if (sObjectType.length() > 3 && sObjectType.right(3)  == '__e') {
    //         throw new UnitOfWorkException(
    //                 String.format(
    //                         'SObject type {0} must use registerPublishBeforeTransaction or ' +
    //                                 'registerPublishAfterTransaction methods to be used within this unit of work',
    //                         new List<String> { sObjectType }
    //                 ));
    //     }
    // }

    // private void assertForEventSObjectType(String sObjectType) {
    //     if (sObjectType.length() > 3 && sObjectType.right(3) != '__e') {
    //         throw new UnitOfWorkException(
    //                 String.format(
    //                         'SObject type {0} is invalid for publishing within this unit of work',
    //                         new List<String> {sObjectType}
    //                 ));
    //     }
    // }

    // private void assertForSupportedSObjectType(Map<String, Object> theMap, String sObjectType) {
    //     if (!theMap.containsKey(sObjectType)) {
    //         throw new UnitOfWorkException(
    //                 String.format(
    //                         'SObject type {0} is not supported by this unit of work',
    //                         new List<String> { sObjectType }
    //                 ));
    //     }
    // }

    // private class Relationships {
    //     private List<iRelationship> m_relationships = new List<iRelationship>();

    //     public void resolve() {
    //         // Resolve relationships
    //         for (iRelationship relationship : m_relationships) {
    //             //relationship.Record.put(relationship.RelatedToField, relationship.RelatedTo.Id);
    //             relationship.resolve();
    //         }
    //     }

    //     public void add(SObject record, Schema.sObjectField relatedToField, Schema.SObjectField externalIdField, Object externalId) {
    //         if (relatedToField == null) {
    //             throw new UnitOfWorkException('Invalid argument: relatedToField.');
    //         }

    //         String relationshipName = SchemaHelper.GetDescribe(relatedToField).getRelationshipName();
    //         if (String.isBlank(relationshipName)) {
    //             throw new UnitOfWorkException('Invalid argument: relatedToField. Field supplied is not a relationship field.');
    //         }

    //         List<Schema.SObjectType> relatedObjects = SchemaHelper.GetDescribe(relatedToField).getReferenceTo();
    //         Schema.SObjectType relatedObject = relatedObjects[0];

    //         String externalIdFieldName = SchemaHelper.GetDescribe(externalIdField).getName();
    //         Boolean relatedHasExternalIdField = SchemaHelper.GetDescribe(relatedObject).fields.getMap().keySet().contains(externalIdFieldName.toLowerCase());
    //         Boolean externalIdFieldIsValid = SchemaHelper.GetDescribe(externalIdField).isExternalId();

    //         if (!relatedHasExternalIdField) {
    //             throw new UnitOfWorkException('Invalid argument: externalIdField. Field supplied is not a known field on the target sObject.');
    //         }

    //         if (!externalIdFieldIsValid) {
    //             throw new UnitOfWorkException('Invalid argument: externalIdField. Field supplied is not a marked as an External Identifier.');
    //         }

    //         RelationshipByExternalId relationship = new RelationshipByExternalId();
    //         relationship.Record = record;
    //         relationship.RelatedToField = relatedToField;
    //         relationship.RelatedTo = relatedObject;
    //         relationship.RelationshipName = relationshipName;
    //         relationship.ExternalIdField = externalIdField;
    //         relationship.ExternalId = externalId;
    //         m_relationships.add(relationship);
    //     }

    //     public void add(SObject record, Schema.sObjectField relatedToField, SObject relatedTo) {
    //         // Relationship to resolve
    //         Relationship relationship = new Relationship();
    //         relationship.Record = record;
    //         relationship.RelatedToField = relatedToField;
    //         relationship.RelatedTo = relatedTo;
    //         m_relationships.add(relationship);
    //     }

    //     public void add(Messaging.SingleEmailMessage email, SObject relatedTo) {
    //         EmailRelationship emailRelationship = new EmailRelationship();
    //         emailRelationship.email = email;
    //         emailRelationship.relatedTo = relatedTo;
    //         m_relationships.add(emailRelationship);
    //     }
    // }

    // private interface iRelationship {
    //     void resolve();
    // }

    // private class RelationshipByExternalId implements iRelationship {
    //     public SObject Record;
    //     public Schema.sObjectField RelatedToField;
    //     public Schema.SObjectType RelatedTo;
    //     public String RelationshipName;
    //     public Schema.sObjectField ExternalIdField;
    //     public Object ExternalId;

    //     public void resolve() {
    //         SObject relationshipObject = this.RelatedTo.newSObject();
    //         relationshipObject.put( SchemaHelper.GetDescribe(ExternalIdField).getName(), this.ExternalId );
    //         this.Record.putSObject( this.RelationshipName, relationshipObject );
    //     }
    // }

    // private class Relationship implements iRelationship {
    //     public SObject Record;
    //     public Schema.sObjectField RelatedToField;
    //     public SObject RelatedTo;

    //     public void resolve() {
    //         this.Record.put( this.RelatedToField, this.RelatedTo.Id);
    //     }
    // }

    // private class EmailRelationship implements iRelationship {
    //     public Messaging.SingleEmailMessage email;
    //     public SObject relatedTo;

    //     public void resolve() {
    //         this.email.setWhatId( this.RelatedTo.Id );
    //     }
    // }

    // /**
    //  * UnitOfWorkException
    //  **/
    // public class UnitOfWorkException extends Exception {}

    // /**
    //  * Internal implementation of Messaging.sendEmail, see outer class registerEmail method
    //  **/
    // public interface iEmailWork extends iWorker {
    //     void registerEmail(Messaging.Email email);
    // }

    // private class SendEmailWork implements iEmailWork {
    //     private List<Messaging.Email> emails;

    //     public SendEmailWork() {
    //         this.emails = new List<Messaging.Email>();
    //     }

    //     public void registerEmail(Messaging.Email email) {
    //         this.emails.add(email);
    //     }

    //     public void doWork() {
    //         if (emails.size() > 0) Messaging.sendEmail(emails);
    //     }
    // }

    // private Boolean allowCommitWork = true;

    // /**
    //  * Generates mock Id values for all SObjects in the stack, and handles their relations.
    //  */
    // public void MockAllIdentities() {
    //     allowCommitWork = false;
    //     m_dml = new MockDML();

    //     OnCommitWorkStarting();
    //     OnPublishBeforeEventsStarting();
    //     publishBeforeEventsStarting();
    //     OnPublishBeforeEventsFinished();

    //     OnDMLStarting();
    //     insertDmlByType();
    //     emptyRecycleBinByType();
    //     OnDMLFinished();

    //     OnDoWorkStarting();
    //     doWork();
    //     OnDoWorkFinished();
    //     OnCommitWorkFinishing();
    // }


    // private class MockDML implements iDML {
    //     public void dmlInsert(List<SObject> objList) {
    //         for (SObject target : objList) {
    //             target.Id = SchemaHelper.GenerateIdFor(target.getSObjectType());
    //         }
    //     }
    //     public void dmlUpdate(List<SObject> objList) { return; }
    //     public void dmlDelete(List<SObject> objList) { return; }
    //     public void eventPublish(List<SObject> objList) { return; }
    //     public void emptyRecycleBin(List<SObject> objList) {
    //         if (objList.isEmpty()) { return; }
    //         Database.emptyRecycleBin(objList);
    //     }
    // }


    // /**
    //  * Clears data that has been registered thus far. Used predominantly in mocking operations.
    //  */
    // public void ClearRegisteredData() {
    //     m_newListByType = new Map<String, List<SObject>>();
    //     m_dirtyMapByType = new Map<String, Map<Id, SObject>>();
    //     m_deletedMapByType = new Map<String, Map<Id, SObject>>();
    //     m_emptyRecycleBinMapByType = new Map<String, Map<Id, SObject>>();
    //     m_publishBeforeListByType = new Map<String, List<SObject>>();
    //     m_publishAfterSuccessListByType = new Map<String, List<SObject>>();
    //     m_publishAfterFailureListByType = new Map<String, List<SObject>>();
    //     allowCommitWork = true;
    // }
}