@isTest
private class KennelSignageControllerTest {
    @isTest
    static void KennelSignageController_animalName() {
        Animal__c a = TestDataFactory.createAnimal();
        a.Animal_Field_ID__c = a.Id;
        update a;

        test.startTest();
            PageReference kennelSignage = Page.KennelSignage;
            kennelSignage.getParameters().put('id', a.Id);

            KennelSignageController cont = new KennelSignageController();
            cont.currentAnimal = a;

            system.assertEquals(a.Animal_Name__c, cont.m_animalName());
            system.assertEquals(a.Animal_Field_ID__c, cont.m_animalId());
            system.assertEquals(a.Breed__c, cont.m_animalBreed());
            system.assertEquals(a.Age__c, cont.m_animalAge());
            system.assertEquals(a.Gender__c, cont.m_animalSex());
            system.assertEquals(a.Color__c, cont.m_animalColor());
        test.stopTest();        
    }

    @isTest
    static void KennelSignageController_behaviorConcern() {
        Animal__c a = TestDataFactory.createAnimal();
        KennelSignageController cont = new KennelSignageController();
        cont.currentAnimal = a;

        test.startTest();
        KennelSignageController.behaviorConcern concern = new KennelSignageController.behaviorConcern('test', true);
        test.stopTest();

        System.assertEquals('test', concern.value);
        System.assertEquals(true, concern.isSelected);
    }

    @isTest
    static void KennelSignageController_getBehaviorConcerns() {
        Animal__c a = TestDataFactory.createAnimal();
        a.Behavior_Concerns__c = 'Shy in Kennel;Mouthy';
        KennelSignageController cont = new KennelSignageController();
        cont.currentAnimal = a;

        test.startTest();
        KennelSignageController.behaviorConcern[] concerns = new KennelSignageController.behaviorConcern[0];
        concerns = cont.getBehaviorConcerns();
        test.stopTest();

        System.assertEquals(false, concerns.isEmpty());
    }

    @isTest
    static void walkingEquipment() {
        test.startTest();
        KennelSignageController.walkingEquipment equip = new KennelSignageController.walkingEquipment('test', true);
        test.stopTest();

        System.assertEquals('test', equip.value);
        System.assertEquals(true, equip.isSelected);
    }

    @isTest
    static void KennelSignageController_getWalkingEquipment() {
        Animal__c a = TestDataFactory.createAnimal();
        a.Walking_Equipment__c = 'Easy Walk Harness;Prong';
        KennelSignageController cont = new KennelSignageController();
        cont.currentAnimal = a;

        test.startTest();
        KennelSignageController.walkingEquipment[] equipments = new KennelSignageController.walkingEquipment[0];
        equipments = cont.getWalkingEquipment();
        test.stopTest();

        System.assertEquals(false, equipments.isEmpty());
    }

    @isTest
    static void walkingStatus() {
        test.startTest();
        KennelSignageController.walkingStatus walking = new KennelSignageController.walkingStatus('test', true);
        test.stopTest();

        System.assertEquals('test', walking.value);
        System.assertEquals(true, walking.isSelected);
    }

    @isTest
    static void KennelSignageController_getWalkingStatus() {
        Animal__c a = TestDataFactory.createAnimal();
        a.Walking_Status__c = 'Terrace Walks;Inside Walks';
        KennelSignageController cont = new KennelSignageController();
        cont.currentAnimal = a;

        test.startTest();
        KennelSignageController.walkingStatus[] walkingStatuses = new KennelSignageController.walkingStatus[0];
        walkingStatuses = cont.getWalkingStatus();
        test.stopTest();

        System.assertEquals(false, walkingStatuses.isEmpty());
    }
}