@isTest
private class test_ScheduleAnimalFoster {
    @TestSetUp
    static void testSetup(){
        Animal__c animal1 = TestDataFactory.createAnimalWithName('test1');
        Animal__c animal2 = TestDataFactory.createAnimalWithName('test2');
        Facility_Outcome__c loc1 = new Facility_Outcome__c(
            Animal__c = animal1.Id,
            Facility_or_Outcome__c = 'Facility',
            Facility_Outcome__c = 'Foster Home'
        );
        Facility_Outcome__c loc2 = new Facility_Outcome__c(
            Animal__c = animal2.Id,
            Facility_or_Outcome__c = 'Facility',
            Facility_Outcome__c = 'Foster Home'
        );
        insert new Facility_Outcome__c[]{loc1, loc2};
        
        User u = [SELECT Id FROM User Where Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        User u2 = [SELECT Id FROM User Where Division = 'MRC' AND isActive = true LIMIT 1];
        Contact con = TestDataFactory.createContact();
        con.User__c = u.Id;
        con.Contact_Type__c = 'Behavior Case Worker';
        con.Email = 'testEmail@testEmail.com';
        update con;

        Contact genericContact = new Contact(
            LastName = 'generic',
            Is_Generic_Contact__c = true,
            User__c = u2.Id
        );
        insert genericContact;

        animal1.Behavior_Case_Worker__c = con.Id;
        animal2.Behavior_Case_Worker__c = con.Id;
        update new Animal__c[]{animal1, animal2};
    }

    @isTest
    static void scheduleFollowups_success() {
        test.startTest();
            Task[] toInsert = ScheduleAnimalFoster.scheduleFollowUps();
        test.stopTest();

        //one task for each animal should be created
        System.assertEquals(2, toInsert.size());
    }

    @isTest
    static void scheduleFollowups_withExistingTask() {
        Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.FOSTER_TASK_RECORD_TYPE_NAME);
        Task[] existingTasks = new Task[0];
        for(Animal__c anim : [SELECT Id FROM Animal__c]){
            Task t = new Task(
                recordTypeId = recordTypeId,
                Animal__c = anim.Id,
                ActivityDate = date.today().addDays(-7)
            );
            existingTasks.add(t);
        }

        insert existingTasks;
        test.startTest();
            Task[] toInsert = ScheduleAnimalFoster.scheduleFollowUps();
        test.stopTest();

        //with default frequency new tasks should still be created for each animal
        System.assertEquals(2, toInsert.size());
    }

    @isTest
    static void scheduleFollowups_customSchedule() {
        Facility_Outcome__c[] locs = [SELECT Id, Follow_Up_Days__c, Follow_Up_Frequency__c FROM Facility_Outcome__c];
        locs[0].Follow_Up_Days__c = 'Wednesday;Friday';
        locs[1].Follow_Up_Frequency__c = 'Every Other Week';

        update locs;

        test.startTest();
            Task[] toInsert = ScheduleAnimalFoster.scheduleFollowUps();
        test.stopTest();

        //two tasks for locs[0] and one task for locs[1]
        System.assertEquals(3, toInsert.size());
    }

    @isTest
    static void scheduleFollowups_customScheduleWithExistingTasks() {
        Facility_Outcome__c[] locs = [SELECT Id, Follow_Up_Days__c, Follow_Up_Frequency__c FROM Facility_Outcome__c];
        locs[0].Follow_Up_Days__c = 'Wednesday;Friday';
        locs[0].Follow_Up_Frequency__c = 'Every Other Week';
        locs[1].Follow_Up_Days__c = 'Wednesday;Friday';
        locs[1].Follow_Up_Frequency__c = 'Every Other Week';
        update locs;

        Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.FOSTER_TASK_RECORD_TYPE_NAME);
        Task[] existingTasks = new Task[0];
        Animal__c[] animals = [SELECT Id FROM Animal__c];

        Task t1 = new Task(
            recordTypeId = recordTypeId,
            Animal__c = animals[0].Id,
            WhatId = locs[0].Id,
            ActivityDate = date.today().addDays(-8),
            Subject = 'Foster Follow Up'
        );
        existingTasks.add(t1);

        Task t2 = new Task(
            recordTypeId = recordTypeId,
            Animal__c = animals[1].Id,
            WhatId = locs[1].Id,
            ActivityDate = date.today().addDays(-5),
            Subject = 'Foster Follow Up'
        );
        existingTasks.add(t2);

        insert existingTasks;

        test.startTest();
            Task[] toInsert = ScheduleAnimalFoster.scheduleFollowUps();
        test.stopTest();

        //two tasks for locs[0] and no tasks for locs[1]
        System.assertEquals(2, toInsert.size());
    }
}
