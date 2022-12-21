@isTest public class AnimalAgeTest {
    public static final Date TESTDOB1 = Date.newInstance(2016, 1, 15);
    // public static FINAL Date testDOB2 = Date.newInstance(2020, 4, 15);
    // static FINAL Date testDOB3 = Date.newInstance(2020, 12, 15);
    // public static FINAL Date testCurrentDate1 = Date.newInstance(2021, 1, 15);

    @testSetup static void setup() {
        // Create case
        Case testCase = new Case();
        insert testCase;

        // Create animals
        Animal__c[] testAnimals = new List<Animal__c>();
        for(Integer i = 1; i <= 12; i++) {
            Animal__c animal = new Animal__c(Animal_Name__c = 'Train' + i);
            animal.Animal_Name__c = 'Train';
            animal.Animal_Age__c = 1;
            switch on Math.mod(i,3) {
                when 1 { animal.Animal_Age_Units__c = 'Months'; }
                when 2 { animal.Animal_Age_Units__c = 'Years'; }
                when 3 { animal.Animal_Age_Units__c = 'Days'; }
            }
            animal.Estimated_Date_of_Birth__c =  i > 6 ? TESTDOB1 : null;
            animal.Type_of_Animal__c = 'Dog';
            animal.Case__c = testCase.Id;
            testAnimals.add(animal);
        }
        insert testAnimals;      
    }

    @isTest static void testInitalLastAnimalUnitsUpdate() {
        Animal__c[] animals= new List<Animal__c>([SELECT Id, CreatedDate, Current_Animal_Age_Formatted__c, Animal_Age_Units_Changed_Date__c	 FROM Animal__c]);

        for (Animal__c a : animals) {
            system.debug(a.Current_Animal_Age_Formatted__c);
            system.debug(a.Animal_Age_Units_Changed_Date__c);
        }
        // system.debug(animal.CreatedDate);
        // system.assertEquals(test1expected, animal.Current_Animal_Age_Formatted__c, test1def);
        // system.debug(animal);
    }



    @isTest static void testAgeUnitsLastUpdated() {

        // test1
        String test1def = 'no Estimated DOB, units=months, currentdateyear=different from birth year';
        // test2
        String test2def = 'no Estimated DOB, units=years, currentdateyear=different from birth year';        
        // test3
        String test3def = 'no Estimated DOB, units=days, currentdateyear=different from birth year';
        // test4
        String test4def = 'no Estimated DOB, units=months, currentdateyear=same from birth year';
        // test5
        String test5def = 'no Estimated DOB, units=years, currentdateyear=same from birth year';        
        // test6
        String test6def = 'no Estimated DOB, units=days, currentdateyear=same from birth year';
        // test7
        String test7def = 'Estimated DOB, units=months, currentdateyear=different from birth year';
        // test8
        String test8def = 'Estimated DOB, units=years, currentdateyear=different from birth year';        
        // test9
        String test9def = 'Estimated DOB, units=days, currentdateyear=different from birth year';
        // test10
        String test10def = 'Estimated DOB, units=months, currentdateyear=same from birth year';
        // test11
        String test11def = 'Estimated DOB, units=years, currentdateyear=same from birth year';        
        // test12
        String test12def = 'Estimated DOB, units=days, currentdateyear=same from birth year';


        Integer test1number = 5;
        String test1units = 'Months';
        String test1expected = '0 Years and 5 Months';
        Datetime test1CreatedDate = Datetime.newInstance(2021, 12, 16);
        Datetime testEDOB = Datetime.newInstance(2021, 6, 1);

        // Case testCase = new Case();
        // insert testCase;



        Animal__c animal = new Animal__c();
        // animal.Animal_Name__c = 'Train';
        // animal.Type_of_Animal__c = 'Cat';
        // animal.Color__c = 'Black';
        // animal.Case__c = testCase.ID;
        // animal.Animal_Age__c = test1number;
        // animal.Animal_Age_Units__c = test1units;
        // animal.Estimated_Date_of_Birth__c = null;
        insert animal;
        Test.setCreatedDate(animal.Id, test1CreatedDate);

        animal = [SELECT Id, CreatedDate, Current_Animal_Age_Formatted__c FROM Animal__c WHERE Id = :animal.Id];
        system.debug(animal.CreatedDate);
        system.assertEquals(test1expected, animal.Current_Animal_Age_Formatted__c, test1def);
        system.debug(animal);
    }
}