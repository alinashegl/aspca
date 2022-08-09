@isTest
private class test_ScheduleBoardAndTrainTask {
    @TestSetup
    static void testSetup(){
        Animal__c animal1 = TestDataFactory.createAnimalWithName('test1');
        Animal__c animal2 = TestDataFactory.createAnimalWithName('test2');
        
        // User u = [SELECT Id FROM User Where Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        // User u2 = [SELECT Id FROM User Where Division = 'MRC' AND isActive = true LIMIT 1];

        User[] userList = TestDataFactory.createUsersWithoutInserting(2);
        User u = userList[0];
        u.Location__c = 'All';

        User u2 = userList[1];
        u2.Location__c = 'CRC/MRC';

        insert userList;


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

        Facility_Outcome__c loc1 = new Facility_Outcome__c(
            Animal__c = animal1.Id,
            Facility_or_Outcome__c = 'Facility',
            Facility_Outcome__c = 'Board and Train'
        );
        Facility_Outcome__c loc2 = new Facility_Outcome__c(
            Animal__c = animal2.Id,
            Facility_or_Outcome__c = 'Facility',
            Facility_Outcome__c = 'Board and Train'
        );
        insert new Facility_Outcome__c[]{loc1, loc2};
        
    }

    @isTest
    static void scheduleFollowups_success() {
        test.startTest();
            Task[] toInsert = ScheduleBoardAndTrainTask.scheduleFollowUps(null);
        test.stopTest();

        //one task for each animal should be created
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

        /*
        this assert loop takes into account the number of days on the custom meta data records may change.
        it also takes into account the day of the week the test is ran to make sure only those tasks need through the
        following tuesday are created
        */
        
        Facility_Outcome__c[] locs = [SELECT Id, Animal__c, Animal__r.Current_Recent_Shelter_Location__c, Follow_Up_Days__c, Follow_Up_Frequency__c FROM Facility_Outcome__c];
        for(Facility_Outcome__c loc : locs){
            Integer count = taskCount(loc);
            System.debug('count = ' + count);
            if(taskMap.containsKey(loc.Animal__c)){
                System.assertEquals(count, taskMap.get(loc.Animal__c).size());
            }
            else {
                System.assertEquals(0, count);
            }
        }
    }

    @isTest
    static void scheduleFollowups_withExistingTask() {
        Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BOARD_AND_TRAIN_RECORD_TYPE_NAME);
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
            Task[] toInsert = ScheduleBoardAndTrainTask.scheduleFollowUps(null);
        test.stopTest();

        //with default frequency new tasks should still be created for each animal
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

        /*
        this assert loop takes into account the number of days on the custom meta data records may change.
        it also takes into account the day of the week the test is ran to make sure only those tasks need through the
        following tuesday are created
        */

        Facility_Outcome__c[] locs = [SELECT Id, Animal__c, Animal__r.Current_Recent_Shelter_Location__c, Follow_Up_Days__c, Follow_Up_Frequency__c FROM Facility_Outcome__c];
        for(Facility_Outcome__c loc : locs){
            Integer count = taskCount(loc);
            System.debug('count = ' + count);
            if(taskMap.containsKey(loc.Animal__c)){
                System.assertEquals(count, taskMap.get(loc.Animal__c).size());
            }
            else {
                System.assertEquals(0, count);
            }
        }
    }

    @isTest
    static void scheduleFollowups_customSchedule() {
        Facility_Outcome__c[] locs = [SELECT Id, Animal__c, Animal__r.Current_Recent_Shelter_Location__c, Follow_Up_Days__c, Follow_Up_Frequency__c FROM Facility_Outcome__c];
        locs[0].Follow_Up_Days__c = 'Wednesday;Friday';
        locs[1].Follow_Up_Frequency__c = 'Every Other Week';

        update locs;

        test.startTest();
            Task[] toInsert = ScheduleBoardAndTrainTask.scheduleFollowUps(null);
        test.stopTest();

        //two tasks for locs[0] and one task for locs[1]
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

        /*
        * the first check takes into account the number of days on the custom meta data records may change.
        * it also takes into account the day of the week the test is ran to make sure only those tasks needed through the
        * following tuesday are created
        */
        Integer count = taskCount(locs[0]);
        System.assertEquals(count, taskMap.get(locs[0].Animal__c).size());

        //because the follow up frequency for this loc is set to every other week a task should not be created at this time
        System.assert(!taskMap.containsKey(locs[1].Animal__c), 'taskMap should not have contained tasks for this animal, instead was: ' + taskMap.get(locs[1].Animal__c));
    }

    @isTest
    static void scheduleFollowups_customScheduleWithExistingTasks() {
        Facility_Outcome__c[] locs = [SELECT Id, Animal__c, Animal__r.Current_Recent_Shelter_Location__c, Follow_Up_Days__c, Follow_Up_Frequency__c FROM Facility_Outcome__c];
        locs[0].Follow_Up_Days__c = 'Wednesday;Friday';
        locs[0].Follow_Up_Frequency__c = 'Every Other Week';
        locs[1].Follow_Up_Days__c = 'Wednesday;Friday';
        locs[1].Follow_Up_Frequency__c = 'Every Other Week';
        update locs;

        Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BOARD_AND_TRAIN_RECORD_TYPE_NAME);
        Task[] existingTasks = new Task[0];
        Animal__c[] animals = [SELECT Id FROM Animal__c];

        Task t1 = new Task(
            recordTypeId = recordTypeId,
            Animal__c = animals[0].Id,
            WhatId = locs[0].Id,
            ActivityDate = date.today().addDays(-8),
            Subject = 'Board and Train Follow Up'
        );
        existingTasks.add(t1);

        Task t2 = new Task(
            recordTypeId = recordTypeId,
            Animal__c = animals[1].Id,
            WhatId = locs[1].Id,
            ActivityDate = date.today().addDays(2),
            Subject = 'Board and Train Follow Up'
        );
        existingTasks.add(t2);

        insert existingTasks;

        test.startTest();
            Task[] toInsert = ScheduleBoardAndTrainTask.scheduleFollowUps(null);
        test.stopTest();

        Map<Id, Task[]> taskMap = new Map<Id, Task[]>();
        for(Task t : toInsert){
            if(taskMap.containsKey(t.Animal__c)){
                taskMap.get(t.Animal__c).add(t);
            }
            else {
                taskMap.put(t.Animal__c, new Task[]{t});
            }
        }

        Integer count = taskCount(locs[0]);
        System.assertEquals(count, taskMap.get(locs[0].Animal__c).size());
        System.assert(!taskMap.containsKey(locs[1].Animal__c), 'Task should not have been created for this animal since the last task is less than a week old');
    }

    @isTest
    static void scheduleFollowupsSpecificDog_success() {
        Animal__c dog = [SELECT Id FROM Animal__c LIMIT 1];
        test.startTest();
            Task[] toInsert = ScheduleBoardAndTrainTask.scheduleFollowUps(new Id[]{dog.Id});
        test.stopTest();

        System.debug('toInsert: ' + toInsert);

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

        /*
        * this assert loop takes into account the number of days on the custom meta data records may change.
        * it also takes into account the day of the week the test is ran to make sure only those tasks need through the
        * following tuesday are created
        */
        
        Facility_Outcome__c[] locs = [SELECT Id, Animal__c, Animal__r.Current_Recent_Shelter_Location__c, Follow_Up_Days__c, Follow_Up_Frequency__c FROM Facility_Outcome__c];
        for(Facility_Outcome__c loc : locs){
            if(loc.Animal__c == dog.Id){
                system.debug('this is the dog');
                Integer count = taskCount(loc);
                System.assertEquals(count, taskMap.get(loc.Animal__c).size());
            }
            else {
                system.assert(!taskMap.containsKey(loc.Animal__c));
            }
        }
    }

    //need to calculate the number of tasks needed from today through tuesday
    private static Integer taskCount(Facility_Outcome__c loc){
        Date[] dateList = new Date[0];
        if(loc.Follow_Up_Days__c != null){
            dateList = AutoScheduleTasksUtil.getDateList(loc.Follow_Up_Days__c);
        } else {
            Calendar_Schedule_Config__mdt config = [
                SELECT Frequency__c, Population__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c, Sunday__c
                FROM Calendar_Schedule_Config__mdt 
                WHERE Task_Type__c = 'Board And Train'
            ];

            dateList = AutoScheduleTasksUtil.getDateList(config);
        }

        return !dateList.isEmpty() ? dateList.size() : 0;
    }    
}