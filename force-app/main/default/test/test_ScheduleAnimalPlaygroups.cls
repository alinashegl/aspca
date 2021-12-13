@isTest
private class test_ScheduleAnimalPlaygroups {
    @TestSetUp
    static void testSetup(){
        Animal__c animalARC = TestDataFactory.createAnimalWithName('animalARC');
        animalARC.Playgroup_Priority_Level__c = 'Low – 2 days';
        animalARC.Current_Recent_Shelter_Location__c = 'ARC/CARE';

        Animal__c animalCRC = TestDataFactory.createAnimalWithName('animalCRC');
        animalCRC.Playgroup_Priority_Level__c = 'High – 4 days';
        animalCRC.Current_Recent_Shelter_Location__c = 'CRC';

        Animal__c animalMRC = TestDataFactory.createAnimalWithName('animalMRC');
        animalMRC.Playgroup_Priority_Level__c = 'Daily – 7 days';
        animalMRC.Current_Recent_Shelter_Location__c = 'MRC';

        User u = [SELECT Id FROM User Where Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        Contact con = TestDataFactory.createContact();
        con.User__c = u.Id;
        con.Contact_Type__c = 'Behavior Case Worker';
        con.Email = 'testEmail@testEmail.com';
        update con;

        User uMRC = [SELECT Id FROM User Where Division = 'MRC' AND isActive = true LIMIT 1];
        User uCRC = [SELECT Id FROM User Where Division = 'CRC' AND isActive = true LIMIT 1];
        User uARC = [SELECT Id FROM User Where Division = 'ARC/CARE' AND isActive = true LIMIT 1];

        Contact genericContactMRC = new Contact(
            LastName = 'genericContactMRC',
            Is_Generic_Contact__c = true,
            User__c = uMRC.Id
        );

        Contact genericContactCRC = new Contact(
            LastName = 'genericContactCRC',
            Is_Generic_Contact__c = true,
            User__c = uCRC.Id
        );

        Contact genericContactARC = new Contact(
            LastName = 'genericContactARC',
            Is_Generic_Contact__c = true,
            User__c = uARC.Id
        );
        insert new Contact[]{genericContactMRC, genericContactARC, genericContactCRC};

        animalARC.Behavior_Case_Worker__c = con.Id;
        animalCRC.Behavior_Case_Worker__c = con.Id;
        animalMRC.Behavior_Case_Worker__c = con.Id;
        update new Animal__c[]{animalARC, animalCRC, animalMRC};
    }

    @isTest 
    static void schedulePlaygroups_success(){
        Test.startTest();
            Task[] toInsert = ScheduleAnimalPlaygroups.schedulePlaygroups();
        Test.stopTest();

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
        Animal__c[] animals = [SELECT Id, Playgroup_Priority_Level__c, Name, Current_Recent_Shelter_Location__c FROM Animal__c];
        System.debug('Animals = ' + animals);
        for(Animal__c animal : animals){
            Integer count = taskCount(animal);
            System.debug('count = ' + count);
            if(taskMap.containsKey(animal.Id)){
                System.assertEquals(count, taskMap.get(animal.Id).size());
            }
            else {
                System.assertEquals(0, count);
            }
        }
    }

    //need to calculate the number of tasks needed from today through tuesday
    private static Integer taskCount(Animal__c animal){
        String priority = animal.Playgroup_Priority_Level__c.split(' ')[0];
        Calendar_Schedule_Config__mdt config = [
            SELECT Frequency__c, Population__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c, Sunday__c
            FROM Calendar_Schedule_Config__mdt 
            WHERE Task_Type__c = 'Playgroup' 
            AND Population__c =: animal.Current_Recent_Shelter_Location__c
            AND Frequency__c =: priority
        ];

        Map<String, Date> dateMap = AutoScheduleTasksUtil.getDateMap(config);

        return !dateMap.isEmpty() ? dateMap.size() : 0;
    }
}
