@isTest
public class AnimalDiscoverPDFControllerTest {
    
    @isTest
    static void testDiscoverPDF(){
        TestDataFactory.createAdultBehaviorEvaluation(false);
        Animal__c anm = [Select Id from Animal__c LIMIT 1];
        Behavior_Evaluation__c beh = [SELECT Id, animal__c FROM Behavior_Evaluation__c LIMIT 1];
        Treatment_Plan__c plan = new Treatment_Plan__c();
        insert plan;

        Contact con = TestDataFactory.createBehaviorCaseWorkerContact();

        Treatment_Session__c session = new Treatment_Session__c(
            Treatment_Plan__c = plan.Id,
            Session_Contact__c = con.Id,
            Animal__c = anm.Id
        );
        insert session;
        
        Playgroup_Session__c pgs = createPlaygroupSession();
        Animal_Playgroup__c[] aPgs = createAnimalPlaygroups(pgs.Id, new Animal__c[]{anm});
        EntityHistory__c history = new EntityHistory__c(FieldName__c = 'Play Style Notes', 
                                                        NewValue__c = 'test1', 
                                                        OldValue__c = 'test2', 
                                                        ParentId__c = anm.Id,
                                                        ObjectId__c = anm.Id, 
                                                        ObjectName__c = 'Animal__c');
        insert history;
        EntityHistory__c history2 = new EntityHistory__c(FieldName__c = 'Overall Evaluation Grade', 
                                                        NewValue__c = 'test1', 
                                                        OldValue__c = 'test2', 
                                                        ParentId__c = beh.animal__c,
                                                        ObjectId__c = beh.Id, 
                                                        ObjectName__c = 'Behavior_Evaluation__c');
        insert history2;
        ApexPages.StandardController sc = new ApexPages.StandardController(anm);
        ApexPages.currentPage().getParameters().put('id',anm.Id);
        PageReference pageRef = sc.view();
		
        AnimalDiscoverPDFController apdf = new AnimalDiscoverPDFController(sc);                
		
        test.startTest();       
		Animal__c a = apdf.animalD;
        List<AnimalDiscoverPDFController.animalPlaySummary> aPlayGroups = apdf.aPlayGroups;
        List<SessionProtocol[]> aTreatmentSession = apdf.aTreatmentSession;
        List<AnimalDiscoverPDFController.AnimalGradeHistory>  gradeHistory = apdf.gradeHistory;
        List<AnimalDiscoverPDFController.BehaviorEvaluation> behaviorEvaluations = apdf.behaviorEvaluations;
        
        test.setCurrentPage(pageRef);                       

        test.stopTest();
        System.assertNotEquals(null, apdf.animalD);
        System.assertNotEquals(null, apdf.aPlayGroups);
        // System.assertNotEquals(null, apdf.aTreatmentSession);
        System.assertNotEquals(null, apdf.gradeHistory);
        System.assertNotEquals(null, apdf.behaviorEvaluations);
    }
    
    @isTest
    static void testDiscoverPDFPuppy(){
        TestDataFactory.createPuppyBehaviorEvaluation();
        Animal__c anm = [Select Id from Animal__c LIMIT 1];
        Behavior_Evaluation__c beh = [SELECT Id, animal__c FROM Behavior_Evaluation__c LIMIT 1];
        Treatment_Plan__c plan = new Treatment_Plan__c();
        insert plan;

        Contact con = TestDataFactory.createBehaviorCaseWorkerContact();

        Treatment_Session__c session = new Treatment_Session__c(
            Treatment_Plan__c = plan.Id,
            Session_Contact__c = con.Id,
            Animal__c = anm.Id
        );
        insert session;
        
        Playgroup_Session__c pgs = createPlaygroupSession();
        Animal_Playgroup__c[] aPgs = createAnimalPlaygroups(pgs.Id, new Animal__c[]{anm});
        EntityHistory__c history2 = new EntityHistory__c(FieldName__c = 'Overall Evaluation Grade', 
                                                        NewValue__c = 'test1', 
                                                        OldValue__c = 'test2', 
                                                        ParentId__c = beh.animal__c,
                                                        ObjectId__c = beh.Id, 
                                                        ObjectName__c = 'Behavior_Evaluation__c');
        insert history2;
        ApexPages.StandardController sc = new ApexPages.StandardController(anm);
        ApexPages.currentPage().getParameters().put('id',anm.Id);
        PageReference pageRef = sc.view();
		
        AnimalDiscoverPDFController apdf = new AnimalDiscoverPDFController(sc);                
		
        test.startTest();       
		Animal__c a = apdf.animalD;
        List<AnimalDiscoverPDFController.animalPlaySummary> aPlayGroups = apdf.aPlayGroups;
        List<SessionProtocol[]> aTreatmentSession = apdf.aTreatmentSession;
        List<AnimalDiscoverPDFController.AnimalGradeHistory>  gradeHistory = apdf.gradeHistory;
        List<AnimalDiscoverPDFController.BehaviorEvaluation> behaviorEvaluations = apdf.behaviorEvaluations;
        
        test.setCurrentPage(pageRef);                       

        test.stopTest();
        System.assertNotEquals(null, apdf.animalD);
        System.assertNotEquals(null, apdf.aPlayGroups);
        System.assertNotEquals(null, apdf.aTreatmentSession);
        System.assertNotEquals(null, apdf.gradeHistory);
        System.assertNotEquals(null, apdf.behaviorEvaluations);
    }
    
    private static Playgroup_Session__c createPlaygroupSession(){
        Contact con = TestDataFactory.createContact();
        Playgroup_Session__c playgroup = new Playgroup_Session__c(
            Playgroup_Leader__c = con.Id
        );
        insert playgroup;
        return playgroup;
    }

    private static Animal_Playgroup__c[] createAnimalPlaygroups(Id sessionid, Animal__c[] animals){
        Animal_Playgroup__c[] aPgList = new Animal_Playgroup__c[0];
        for(Animal__c anim : animals){
            aPgList.add(new Animal_Playgroup__c(
                Playgroup_Session__c = sessionId,
                Animal__c = anim.Id,
                Common_Playgroup_Note_Sections__c = 'Greeting',
                Common_Playgroup_Notes__c = 'Airhorn',
                Play_Rating__c = 'Green',
                Playgroup_Individual_Notes__c = 'Individual note'
            ));
        }
        insert aPgList;
        return aPgList;
    }
}