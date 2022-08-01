@isTest
private class test_ScheduleAnimalMedCheck {
    @isTest
    static void checkDayOfWeekToInteger() {
        test.startTest();
            Integer dayNumber = ScheduleAnimalMedCheck.dayOfWeekToInteger('Wednesday');
        test.stopTest();

        System.assertEquals(1, dayNumber);
    }

    @isTest
    static void checkDayOfWeekToIntegerDefault() {
        test.startTest();
            Integer dayNumber = ScheduleAnimalMedCheck.dayOfWeekToInteger('Tuesday');
        test.stopTest();

        System.assertEquals(0, dayNumber);
    }

    @isTest
    static void getTreatmentTasksSuccess(){
        Animal__c anim1 = TestDataFactory.createAnimalWithName('anim1');
        Task treatmentTask1 = insertTask(false, anim1);

        Animal__c anim2 = TestDataFactory.createAnimalWithName('anim2');
        Task treatmentTask2 = insertTask(true, anim2);

        test.startTest();
            Task[] taskList = ScheduleAnimalMedCheck.getTreatmentTasks(null);
        test.stopTest();

        System.assert(!taskList.isEmpty(), 'returned list was empty');
        System.assertEquals(2, taskList.size());
    }

    @isTest
    static void getTreatmentTasksNoTasks(){
        test.startTest();
            Task[] taskList = ScheduleAnimalMedCheck.getTreatmentTasks(null);
        test.stopTest();

        System.assert(taskList.isEmpty(), 'returned list should be empty');
    }

    @isTest
    static void prepTaskSuccess(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');
        User u = TestDataFactory.createUserWithProfile('ASPCA - Behavior (CRC)');
        u.Division = anim.Current_Recent_Shelter_Location__c;
        u.Location__c = 'CRC/MRC';
        insert u;
        createGenericContact(anim);
        Task treatmentTask = insertTask(false, anim);
        treatmentTask = [SELECT Id, Animal__c, Animal__r.Animal_Name_ID__c, Animal__r.Behavior_Case_Worker__r.Is_Generic_Contact__c, Animal__r.Current_Recent_Shelter_Location__c, Animal_Exam_Sheet_Lookup__c, Medication__c FROM Task WHERE Id =: treatmentTask.Id LIMIT 1];

        test.startTest();
            Task[] newTasks = ScheduleAnimalMedCheck.prepTask(treatmentTask, new Date[]{date.today().addDays(3)});
        test.stopTest();

        System.assert(!newTasks.isEmpty(), 'should have returned tasks, but instead was an empty list');
    }

    @isTest
    static void prepTaskNoTreatmentTask(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');
        User u = TestDataFactory.createUserWithProfile('ASPCA - Behavior (CRC)');
        u.Division = anim.Current_Recent_Shelter_Location__c;
        u.Location__c = 'CRC/MRC';
        insert u;
        createGenericContact(anim);
        test.startTest();
            Task[] newTasks = ScheduleAnimalMedCheck.prepTask(null, new Date[]{date.today().addDays(3)});
        test.stopTest();

        System.assert(newTasks.isEmpty(), 'should not have returned any tasks, instead was: ' + newTasks);
    }

    @isTest
    static void calculateTaskDateNotRecurringSuccess(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');
        User u = TestDataFactory.createUserWithProfile('ASPCA - Behavior (CRC)');
        u.Division = anim.Current_Recent_Shelter_Location__c;
        u.Location__c = 'CRC/MRC';
        insert u;
        createGenericContact(anim);
        Task treatmentTask = insertTask(false, anim);
        treatmentTask = [SELECT Id, IsRecurrence, RecurrenceStartDateOnly, ActivityDate FROM Task WHERE Id =: treatmentTask.Id LIMIT 1];

        test.startTest();
            Date[] dates = ScheduleAnimalMedCheck.calculateTaskDates(treatmentTask);
        test.stopTest();

        system.assert(!dates.isEmpty(), 'Date was null, expected a date');
        system.assert(dates[0] > date.today(), 'expected a future date, but was: ' + dates[0]);
    }

    @isTest
    static void calculateTaskDateRecurringSuccess(){
        Animal__c anim = TestDataFactory.createAnimalWithName('anim');
        User u = TestDataFactory.createUserWithProfile('ASPCA - Behavior (CRC)');
        u.Division = anim.Current_Recent_Shelter_Location__c;
        u.Location__c = 'CRC/MRC';
        insert u;
        createGenericContact(anim);
        Task treatmentTask = insertTask(true, anim);
        treatmentTask = [SELECT Id, IsRecurrence, RecurrenceStartDateOnly, ActivityDate FROM Task WHERE Id =: treatmentTask.Id LIMIT 1];

        test.startTest();
            Date[] dates = ScheduleAnimalMedCheck.calculateTaskDates(treatmentTask);
        test.stopTest();

        system.assert(!dates.isEmpty(), 'Date was null, expected a date');
        system.assert(dates[0] > date.today(), 'expected a future date, but was: ' + dates[0]);
    }

    @isTest
    static void scheduleMedCheckSuccess(){        
        Animal__c anim1 = TestDataFactory.createAnimalWithName('anim1');
        Task treatmentTask1 = insertTask(false, anim1);
        User u = TestDataFactory.createUserWithProfile('ASPCA - Behavior (CRC)');
        u.Division = anim1.Current_Recent_Shelter_Location__c;
        u.Location__c = 'CRC/MRC';
        insert u;
        createGenericContact(anim1);

        Animal__c anim2 = TestDataFactory.createAnimalWithName('anim2');
        User u2 = TestDataFactory.createUserWithProfile('ASPCA - Behavior (CRC)');
        u2.Division = anim2.Current_Recent_Shelter_Location__c;
        u2.Location__c = 'CRC/MRC';
        insert u2;
        Task treatmentTask2 = insertTask(true, anim2);
        createGenericContact(anim2);

        test.startTest();
            Task[] taskList = ScheduleAnimalMedCheck.scheduleMedCheck(null);
        test.stopTest();

        system.assert(!taskList.isEmpty());
    }

    @isTest
    static void scheduleMedCheckNoTasks(){        
        test.startTest();
            Task[] taskList = ScheduleAnimalMedCheck.scheduleMedCheck(null);
        test.stopTest();

        system.assert(taskList.isEmpty());
    }

    @isTest
    static void scheduleMedCheckSpecificDogSuccess(){        
        Animal__c anim1 = TestDataFactory.createAnimalWithName('anim1');
        Task treatmentTask1 = insertTask(false, anim1);
        User u = TestDataFactory.createUserWithProfile('ASPCA - Behavior (CRC)');
        u.Division = anim1.Current_Recent_Shelter_Location__c;
        u.Location__c = 'CRC/MRC';
        insert u;
        createGenericContact(anim1);

        Animal__c anim2 = TestDataFactory.createAnimalWithName('anim2');
        User u2 = TestDataFactory.createUserWithProfile('ASPCA - Behavior (CRC)');
        u2.Division = anim2.Current_Recent_Shelter_Location__c;
        u2.Location__c = 'CRC/MRC';
        insert u2;
        Task treatmentTask2 = insertTask(true, anim2);
        createGenericContact(anim2);

        test.startTest();
            Task[] toInsert = ScheduleAnimalMedCheck.scheduleMedCheck(new Id[]{anim1.Id});
        test.stopTest();

        system.assert(!toInsert.isEmpty());

        //one task for anim1 and no tasks for anim2 should be created
        Map<Id, Task[]> taskMap = new Map<Id, Task[]>();
        for(Task t : toInsert){
            if(taskMap.containsKey(t.Animal__c)){
                taskMap.get(t.Animal__c).add(t);
            }
            else {
                taskMap.put(t.Animal__c, new Task[]{t});
            }
        }
        System.debug('taskMap = ' + taskMap);

        System.assertEquals(1, taskMap.get(anim1.Id).size());
        System.assert(!taskMap.containsKey(anim2.Id));
    }

    private static void createGenericContact(Animal__c anim){
        User u = [SELECT Id FROM User WHERE Division =: anim.Current_Recent_Shelter_Location__c AND isActive = true LIMIT 1];
        Contact con = new Contact(
            LastName = 'generic',
            User__c = u.Id,
            Is_Generic_Contact__c = true,
            Active__c = true
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