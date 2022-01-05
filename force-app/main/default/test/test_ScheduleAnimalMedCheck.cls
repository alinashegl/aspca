@isTest
private class test_ScheduleAnimalMedCheck {
    @isTest
    static void checkDayOfWeek() {
        test.startTest();
            String day = ScheduleAnimalMedCheck.checkDayOfWeek(1);
        test.stopTest();

        System.assertEquals('Monday', day);
    }

    @isTest
    static void checkDayOfWeekDefault() {
        test.startTest();
            String day = ScheduleAnimalMedCheck.checkDayOfWeek(10);
        test.stopTest();

        System.assertEquals('Sunday', day);
    }

    @isTest
    static void getTreatmentTasksSuccess(){
        Animal__c anim1 = TestDataFactory.createAnimalWithName('anim1');
        Task treatmentTask1 = insertTask(false, anim1);

        Animal__c anim2 = TestDataFactory.createAnimalWithName('anim2');
        Task treatmentTask2 = insertTask(true, anim2);

        test.startTest();
            Task[] taskList = ScheduleAnimalMedCheck.getTreatmentTasks();
        test.stopTest();

        System.assert(!taskList.isEmpty(), 'returned list was empty');
        System.assertEquals(2, taskList.size());
    }

    @isTest
    static void getTreatmentTasksNoTasks(){
        test.startTest();
            Task[] taskList = ScheduleAnimalMedCheck.getTreatmentTasks();
        test.stopTest();

        System.assert(taskList.isEmpty(), 'returned list should be empty');
    }

    @isTest
    static void prepTaskSuccess(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');
        createGenericContact(anim);
        Task treatmentTask = insertTask(false, anim);
        treatmentTask = [SELECT Id, Animal__c, Animal__r.Animal_Name_ID__c, Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c, Animal__r.Current_Recent_Shelter_Location__c, Animal_Exam_Sheet_Lookup__c, Medication__c FROM Task WHERE Id =: treatmentTask.Id LIMIT 1];

        test.startTest();
            Task newTask = ScheduleAnimalMedCheck.prepTask(treatmentTask, date.today().addDays(3));
        test.stopTest();

        System.assert(newTask != null);
    }

    @isTest
    static void prepTaskNoTreatmentTask(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');
        createGenericContact(anim);

        test.startTest();
            Task newTask = ScheduleAnimalMedCheck.prepTask(null, date.today().addDays(3));
        test.stopTest();

        System.assert(newTask == null);
    }

    @isTest
    static void calculateTaskDateNotRecurringSuccess(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');
        createGenericContact(anim);
        Task treatmentTask = insertTask(false, anim);
        treatmentTask = [SELECT Id, IsRecurrence, RecurrenceStartDateOnly, ActivityDate FROM Task WHERE Id =: treatmentTask.Id LIMIT 1];

        test.startTest();
            Date d = ScheduleAnimalMedCheck.calculateTaskDate(treatmentTask);
        test.stopTest();

        system.assert(d != null, 'Date was null, expected a date');
        system.assert(d > date.today(), 'expected a future date, but was: ' + d);
    }

    @isTest
    static void calculateTaskDateRecurringSuccess(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');
        createGenericContact(anim);
        Task treatmentTask = insertTask(true, anim);
        treatmentTask = [SELECT Id, IsRecurrence, RecurrenceStartDateOnly, ActivityDate FROM Task WHERE Id =: treatmentTask.Id LIMIT 1];

        test.startTest();
            Date d = ScheduleAnimalMedCheck.calculateTaskDate(treatmentTask);
        test.stopTest();

        system.assert(d != null, 'Date was null, expected a date');
        system.assert(d > date.today(), 'expected a future date, but was: ' + d);
    }

    @isTest
    static void scheduleMedCheckSuccess(){        
        Animal__c anim1 = TestDataFactory.createAnimalWithName('anim1');
        Task treatmentTask1 = insertTask(false, anim1);
        createGenericContact(anim1);

        Animal__c anim2 = TestDataFactory.createAnimalWithName('anim2');
        Task treatmentTask2 = insertTask(true, anim2);
        createGenericContact(anim2);

        test.startTest();
            Task[] taskList = ScheduleAnimalMedCheck.scheduleMedCheck();
        test.stopTest();

        system.assert(!taskList.isEmpty());
    }

    @isTest
    static void scheduleMedCheckNoTasks(){        
        test.startTest();
            Task[] taskList = ScheduleAnimalMedCheck.scheduleMedCheck();
        test.stopTest();

        system.assert(taskList.isEmpty());
    }    

    private static void createGenericContact(Animal__c anim){
        User u = [SELECT Id FROM User WHERE Division =: anim.Current_Recent_Shelter_Location__c AND isActive = true LIMIT 1];
        Contact con = new Contact(
            LastName = 'generic',
            User__c = u.Id,
            Is_Generic_Contact__c = true
        );
        insert con;
    }

    private static Task insertTask(Boolean recurring, Animal__c anim){
        Medication_Drug__c med = new Medication_Drug__c(
            RecordTypeId = Util.getRecordTypeId('Medication_Drug__c', 'Medication'),
            Behavior_Medication__c = true,
            Name = 'test drug'
        );
        insert med;

        Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.TREATMENT_TASK_RECORD_TYPE_NAME);
        Task newTask = new Task(
            Animal__c = anim.Id,
            RecordTypeId = recordTypeId,
            Description = 'test Treatment Task',
            IsReminderSet = false,
            Status = 'Not Started',
            Subject = 'Treatment',
            Species__c = 'Dog',
            Medication__c = med.Id
        );

        if(recurring == true){
            newTask.IsRecurrence = true;
            newTask.RecurrenceStartDateOnly = date.today();
            newTask.RecurrenceEndDateOnly = date.today().addDays(21);
            newTask.RecurrenceType = 'RecursWeekly';
            newTask.RecurrenceInterval = 1;
            newTask.RecurrenceDayOfWeekMask = 8;
        } else {
            newTask.ActivityDate = date.today().addDays(6);
        }
        insert newTask;

        return newTask;
    }
}
