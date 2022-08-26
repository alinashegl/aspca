/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */
@isTest
public without sharing class TestDataFactory {

    public static final String DATE_FORMAT = 'yyyy-MM-dd';

    public static final String DATE_START_WITHOUT_TIMESHEETS = '2020-01-06';
    public static final String DATE_END_WITHOUT_TIMESHEETS = '2020-01-12';


    public static final Integer USERS_COUNT = 10;//300
    public static final String USER_NAME_PATTERN = 'user%';
    public static final Map<String, Object> USER_PATTERN = new Map<String, Object>{
            'alias' => '',
            'email' => '',
            'emailEncodingKey' => 'UTF-8',
            'languageLocaleKey' => 'en_US',
            'localeSidKey' => 'en_US',
            'name' => 'user',
            'lastName' => 'lastname',
            'communityNickname' => '',
            'profileId' => '',
            'timeZoneSidKey' => 'America/Los_Angeles',
            'userName' => '',
            'domain' => 'domain.com'//local variable

    };
    public static List<Map<String, Object>> users = new List<Map<String, Object>>();

    public static final Integer ACCOUNTS_COUNT = 10;//300
    public static final String ACCOUNT_NAME_PATTERN = 'company%';
    public static final String ACCOUNT_STATUS_ACTIVE = 'Activated';
    public static final Map<String, Object> ACCOUNT_PATTERN = new Map<String, Object>{
            'name' => 'company'
    };
    public static List<Map<String, Object>> accounts = new List<Map<String, Object>>();

    public static final Integer CONTACTS_COUNT = 10;//300
    public static final String CONTACT_NAME_PATTERN = 'contact%';
    public static final Map<String, Object> CONTACT_PATTERN = new Map<String, Object>{
            'name' => 'contact',
            'firstName' => 'contact_f',
            'lastName' => 'contact_l',
            'email' => null,
            'accountid' => null,
            'domain' => 'domain.com'
    };
    public static List<Map<String, Object>> contacts = new List<Map<String, Object>>();


    public static final Integer PRODUCTS_COUNT = 10;//300
    public static final String PRODUCT_NAME_PATTERN = 'development%';
    public static final Map<String, Object> PRODUCT_PATTERN = new Map<String, Object>{
            'name' => 'Development',
            'isActive' => true
    };
    public static List<Map<String, Object>> products = new List<Map<String, Object>>();


    public static final Integer PRICEBOOKS_COUNT = 10;//300
    public static final String PRICEBOOK_NAME_PATTERN = 'pricebook%';
    public static final Map<String, Object> PRICEBOOK_PATTERN = new Map<String, Object>{
            'name' => 'pricebook',
            'isActive' => true,
            'isStandart' => false
    };
    public static List<Map<String, Object>> pricebooks = new List<Map<String, Object>>();


    public static final Integer PRICEBOOK_ENTRIES_COUNT = 10;//300
    public static final Decimal PRICEBOOK_ENTRY_UNIT_PRICE = 50.00;
    public static final Map<String, Object> PRICEBOOK_ENTRY_PATTERN = new Map<String, Object>{
            'isActive' => true,
            'unitPrice' => PRICEBOOK_ENTRY_UNIT_PRICE,
            'pricebook2Id' => null,
            'product2Id' => null,
            'useStandardPrice' => false
    };
    public static List<Map<String, Object>> pricebookEntries = new List<Map<String, Object>>();

    public static final Integer CONTRACTS_COUNT = 10;//300
    public static final String CONTRACT_NAME_PATTERN = 'contract%';
    public static final String CONTRACT_STATUS_IN_Approval_Process = 'In Approval Process';
    public static final String CONTRACT_STATUS_DRAFT = 'Draft';
    public static final String CONTRACT_STATUS_ACTIVED = 'Activated';
    public static final Map<String, Object> CONTRACT_PATTERN = new Map<String, Object>{
            'accountId' => null,
            'status' => CONTRACT_STATUS_DRAFT,
            'startDate' => null,
            'contractTerm' => null,
            'pricebook2Id' => null,
            'name' => 'contract'
    };
    public static List<Map<String, Object>> contracts = new List<Map<String, Object>>{
            new Map<String, Object> {
                    'count' => 3,//100
                    'useParentId' => true,
                    'useDiffParentId' => true,
                    'contractTerm' => 8,
                    'starDate' => Datetime.newInstance(2019, 6, 1)
            },
            new Map<String, Object> {
                    'count' => 6,//150
                    'useParentId' => true,
                    'useDiffParentId' => true,
                    'contractTerm' => 4,
                    'startDate' => Datetime.newInstance(2019, 11, 1)
            },
            new Map<String, Object> {
                    'count' => 1,//50
                    'useParentId' => true,
                    'useDiffParentId' => false,
                    'contractTerm' => 1,
                    'startDate' => Datetime.newInstance(2019, 12, 1)
            }
    };

    public static final Map<String, Object> TIMESHEET_ENTRY_PATTERN = new Map<String, Object>{
            'contractResource' => null,//String:Contract_Resource__c
            'product' => null,//String:Product__c
            'date' => null,//Date:Date__c
            'minutes' => null,//Decimal:Minutes__c
            'employee' => null,//String:Employee__c
            'approved' => null//Boolean:Is_Approved__c
    };
    public static List<Map<String, Object>> timesheetEntries = new List<Map<String, Object>>{};

    public static final String TIMESHEET_STATUS_NEW = 'New';
    public static final String TIMESHEET_STATUS_PENDING = 'Pending';
    public static final String TIMESHEET_STATUS_APPROVED = 'Approved';
    public static final String TIMESHEET_STATUS_PAID = 'Paid';

    public static final String TIME_REPORTS_STATUS_APPROVED = 'Approved';
    public static final String TIME_REPORTS_STATUS_NEW = 'New';
    public static final String TIME_REPORTS_STATUS_UNLOCKED = 'unlocked';

    public static final String EXPENSE_TYPE_AIRFARE = 'Airfare';
    public static final String EXPENSE_TYPE_HOTEL_ROOM = 'Hotel Room';
    public static final String EXPENSE_TYPE_MEAL = 'Meal';
    public static final String EXPENSE_TYPE_RENTAL_CAR = 'Rental Car';

    public static final Map<String, Object> configDateRanges = new Map<String, Object>{
            /*'2019-06-03_2019-06-09' => new Map<String, Object>{
              'startDate' => '2019-06-03',
              'endDate' => '2019-06-09',
              'status' => 'approved'
            },
            '2019-06-10_2019-06-16' => new Map<String, Object>{
              'startDate' => '2019-06-10',
              'endDate' => '2019-06-16',
              'status' => 'approved'
            },
            '2019-06-17_2019-06-23' => new Map<String, Object>{
              'startDate' => '019-06-17',
              'endDate' => '2019-06-23',
              'status' => 'approved'
            },
            '2019-06-24_2019-06-30' => new Map<String, Object>{
              'startDate' => '2019-06-24',
              'endDate' => '2019-06-30',
              'status' => 'approved'
            },
            '2019-07-01_2019-07-07' => new Map<String, Object>{
              'startDate' => '2019-07-01',
              'endDate' => '2019-07-07',
              'status' => 'new'
            },
            '2019-07-08_2019-07-14' => new Map<String, Object>{
              'startDate' => '2019-07-08',
              'endDate' => '2019-07-14',
              'status' => 'new'
            },
            '2019-07-15_2019-07-21' => new Map<String, Object>{
              'startDate' => '2019-07-15',
              'endDate' => '2019-07-21',
              'status' => 'new'
            },
            '2019-07-22_2019-07-28' => new Map<String, Object>{
              'startDate' => '2019-07-22',
              'endDate' => '2019-07-28',
              'status' => 'new'
            },
            '2019-07-29_2019-08-04' => new Map<String, Object>{
              'startDate' => '2019-07-29',
              'endDate' => '2019-08-04',
              'status' => 'new'
            },
            '2019-08-05_2019-08-11' => new Map<String, Object>{
              'startDate' => '2019-08-05',
              'endDate' => '2019-08-11',
              'status' => 'pending'
            },
            '2019-08-12_2019-08-18' => new Map<String, Object>{
              'startDate' => '2019-08-12',
              'endDate' => '2019-08-18',
              'status' => 'pending'
            },
            '2019-08-19_2019-08-25' => new Map<String, Object>{
              'startDate' => '2019-08-19',
              'endDate' => '2019-08-25',
              'status' => 'pending'
            },
            '2019-08-26_2019-09-01' => new Map<String, Object>{
              'startDate' => '2019-08-26',
              'endDate' => '2019-09-01',
              'status' => 'pending'
            },
            '2019-09-02_2019-09-08' => new Map<String, Object>{
              'startDate' => '2019-09-02',
              'endDate' => '2019-09-08',
              'status' => 'approved'
            },
            '2019-09-09_2019-09-15' => new Map<String, Object>{
              'startDate' => '2019-09-09',
              'endDate' => '2019-09-15',
              'status' => 'new'
            },
            '2019-09-16_2019-09-22' => new Map<String, Object>{
              'startDate' => '2019-09-16',
              'endDate' => '2019-09-22',
              'status' => 'pending'
            },
            '2019-09-23_2019-09-29' => new Map<String, Object>{
              'startDate' => '2019-09-23',
              'endDate' => '2019-09-29',
              'status' => 'approved'
            },
            '2019-09-30_2019-10-06' => new Map<String, Object>{
              'startDate' => '2019-09-30',
              'endDate' => '2019-10-06',
              'status' => 'approved'
            },
            '2019-10-07_2019-10-13' => new Map<String, Object>{
              'startDate' => '2019-10-07',
              'endDate' => '2019-10-13',
              'status' => 'new'
            },
            '2019-10-14_2019-10-20' => new Map<String, Object>{
              'startDate' => '2019-10-14',
              'endDate' => '2019-10-20',
              'status' => 'pending'
            },
            '2019-10-21_2019-10-27' => new Map<String, Object>{
              'startDate' => '2019-10-21',
              'endDate' => '2019-10-27',
              'status' => 'approved'
            },
            '2019-10-28_2019-11-03' => new Map<String, Object>{
              'startDate' => '2019-10-28',
              'endDate' => '28_2019-11-03',
              'status' => 'new'
            },
            '2019-11-04_2019-11-10' => new Map<String, Object>{
              'startDate' => '2019-11-04',
              'endDate' => '2019-11-10',
              'status' => 'pending'
            },
            '2019-11-11_2019-11-17' => new Map<String, Object>{
              'startDate' => '2019-11-11',
              'endDate' => '11_2019-11-17',
              'status' => 'pending'
            },
            '2019-11-18_2019-11-24' => new Map<String, Object>{
              'startDate' => '2019-11-18',
              'endDate' => '2019-11-24',
              'status' => 'pending'
            },
            '2019-11-25_2019-12-01' => new Map<String, Object>{
              'startDate' => '2019-11-25',
              'endDate' => '2019-12-01',
              'status' => 'pending'
            },*/
            '2019-12-02_2019-12-08' => new Map<String, Object>{
                    'startDate' => '2019-12-02',
                    'endDate' => '2019-12-08',
                    'status' => 'approved',
                    'createTimesheet' => true
            },
            '2019-12-09_2019-12-15' => new Map<String, Object>{
                    'startDate' => '2019-12-09',
                    'endDate' => '2019-12-15',
                    'status' => 'approved',
                    'createTimesheet' => true
            },
            '2019-12-16_2019-12-22' => new Map<String, Object>{
                    'startDate' => '2019-12-16',
                    'endDate' => '2019-12-22',
                    'status' => 'approved',
                    'createTimesheet' => true
            },
            '2019-12-23_2019-12-29' => new Map<String, Object>{
                    'startDate' => '2019-12-23',
                    'endDate' => '2019-12-29',
                    'status' => 'pending',
                    'createTimesheet' => true
            },
            '2019-12-30_2020-01-05' => new Map<String, Object>{
                    'startDate' => '2019-12-30',
                    'endDate' => '2020-01-05',
                    'status' => 'new',
                    'createTimesheet' => true
            },
            DATE_START_WITHOUT_TIMESHEETS + '_' + DATE_END_WITHOUT_TIMESHEETS => new Map<String, Object>{
                    'startDate' => DATE_START_WITHOUT_TIMESHEETS,
                    'endDate' => DATE_END_WITHOUT_TIMESHEETS,
                    'status' => 'new',
                    'createTimesheet' => false
            }
    };

    public static final List<Map<String, String>> FILES = new List<Map<String, String>>{
            new Map<String, String>{
                    'id' => null,
                    'type' =>'text/plain',
                    'name' => 'file-unit-test.txt',
                    'content' => 'dGVzdCBjb250ZW50IGZvciB1bml0IHRlc3QuIGZpbGUgdXBsb2FkCg==',
                    'recordId' => null
            }
    };

    public static void init() {
        insertUsers();
        insertAccounts();
        insertContacts();
    }

    public static void insertUsers() {
        List<User> users = new List<User>();

        Profile p = getProfileFromDb('Standard User');

        for(Integer i = 0; i < USERS_COUNT; i++) {
            String name = (String)USER_PATTERN.get('name') + '_' + i;
            String lastname = (String)USER_PATTERN.get('lastName') + '_' + i;
            String uid = (String)USER_PATTERN.get('name') + '_' + i;

            User u = new User(
                    Alias = uid,
                    Email = uid + '@' + (String)USER_PATTERN.get('domain'),
                    EmailEncodingKey = (String)USER_PATTERN.get('emailEncodingKey'),
                    //Name = name,
                    LastName = lastname,
                    LanguageLocaleKey = (String)USER_PATTERN.get('languageLocaleKey'),
                    LocaleSidKey = (String)USER_PATTERN.get('localeSidKey'),
                    ProfileId = p.Id,
                    TimeZoneSidKey = (String)USER_PATTERN.get('timeZoneSidKey'),
                    UserName = (uid + '@' +  (String)USER_PATTERN.get('domain')),
                    Location__c = 'CRC/MRC'
            );
            users.add(u);
        }

        insert users;
    }

    public static User createUserWithProfile(String profile){
        Profile p = getProfileFromDb(profile);
        String name = (String)USER_PATTERN.get('name') + '_' + 0;
          String lastname = (String)USER_PATTERN.get('lastName') + '_' + 0;
          String uid = (String)USER_PATTERN.get('name') + '_' + String.valueOf(Integer.valueof((Math.random() * 1000)));

          User u = new User(
                  Alias = uid,
                  Email = uid + '@' + (String)USER_PATTERN.get('domain'),
                  EmailEncodingKey = (String)USER_PATTERN.get('emailEncodingKey'),
                  LastName = lastname,
                  LanguageLocaleKey = (String)USER_PATTERN.get('languageLocaleKey'),
                  LocaleSidKey = (String)USER_PATTERN.get('localeSidKey'),
                  ProfileId = p.Id,
                  TimeZoneSidKey = (String)USER_PATTERN.get('timeZoneSidKey'),
                  UserName = (uid + '@' +  (String)USER_PATTERN.get('domain'))
          );
        return u;
    }
    
    public static User[] createUsersWithoutInserting(Integer count) {
      Integer userCount = count != null ? count : USERS_COUNT;
      
      List<User> users = new List<User>();

      Profile p = getProfileFromDb('Standard User');

      for(Integer i = 0; i < USERS_COUNT; i++) {
          String name = (String)USER_PATTERN.get('name') + '_' + i;
          String lastname = (String)USER_PATTERN.get('lastName') + '_' + i;
          String uid = (String)USER_PATTERN.get('name') + '_' + i;

          User u = new User(
                  Alias = uid,
                  Email = uid + '@' + (String)USER_PATTERN.get('domain'),
                  EmailEncodingKey = (String)USER_PATTERN.get('emailEncodingKey'),
                  //Name = name,
                  LastName = lastname,
                  LanguageLocaleKey = (String)USER_PATTERN.get('languageLocaleKey'),
                  LocaleSidKey = (String)USER_PATTERN.get('localeSidKey'),
                  ProfileId = p.Id,
                  TimeZoneSidKey = (String)USER_PATTERN.get('timeZoneSidKey'),
                  UserName = (uid + '@' +  (String)USER_PATTERN.get('domain'))
          );
          users.add(u);
      }
      return users;
  }
    public static List<User> getUsersFromDb() {
        Set<String> standardUsers = new Set<String> {
                'User',
                'User User',
                'Automated Process',
                'Data.com Clean',
                'Integration User',
                'Security User',
                'Chatter Expert'
        };

        return [SELECT Id, Alias, Email, Name FROM User WHERE Name NOT IN :standardUsers AND Email LIKE :USER_NAME_PATTERN];
    }

    public static List<User> getStandartUsersFromDb() {
        Set<String> standardUsers = new Set<String> {
                'Automated Process',
                'Data.com Clean',
                'Integration User',
                'Security User',
                'Chatter Expert'
        };

        return [SELECT Id FROM User WHERE Name NOT IN :standardUsers];
    }

    public static Profile getProfileFromDb(String name) {
        return [SELECT Id FROM Profile WHERE Name = :name LIMIT 1];
    }

    public static void insertAccounts() {
        List<Account> accounts = new List<Account>();

        String name = (String)ACCOUNT_PATTERN.get('name');

        for(Integer i = 0; i < ACCOUNTS_COUNT; i++) {
            Account account = new Account(Name = (name + '_' + i));
            accounts.add(account);
        }

        insert accounts;
    }

    public static List<Account> getAccountsFromDb() {
        return [SELECT Id, Name FROM Account];
    }

    public static void insertContacts() {
        List<Account> accounts = getAccountsFromDb();
        Integer totalNumberAccounts = accounts.size();
        List<Contact> contacts = new List<Contact>();

        String name = (String)CONTACT_PATTERN.get('name');
        String firstName = (String)CONTACT_PATTERN.get('firstName');
        String lastName = (String)CONTACT_PATTERN.get('lastName');
        String domain = (String)CONTACT_PATTERN.get('domain');

        for(Integer i = 0; i < CONTACTS_COUNT; i++) {
            Contact contact = new Contact();

            if(i > totalNumberAccounts) {
                contact.AccountId = accounts.get(totalNumberAccounts).Id;
            } else {
                contact.AccountId = accounts.get(i).Id;
            }

            contact.FirstName = (firstName + '_' + i);
            contact.LastName = (lastName + '_' + i);
            contact.Email = (name + '_' + i + '@' + domain);
            contacts.add(contact);
        }

        insert contacts;
    }

    public static List<Contact> getContactsFromDb() {
        return [SELECT Id, Name, AccountId FROM Contact WHERE Email LIKE :CONTACT_NAME_PATTERN];
    }



    public static Set<String> getAccountsNames() {
        Set<String> names = new Set<String>();

        String namePattern = (String)ACCOUNT_PATTERN.get('name');

        for(Integer i = 0; i < ACCOUNTS_COUNT; i++) {
            names.add(namePattern + '_' + i);
        }

        return names;
    }
    public static Contact getContactFromDb() {
        return [SELECT Id FROM Contact LIMIT 1];
    }


    public static String getUserId() {
        List<User> users = getUsersFromDb();
        return users.get(0).Id;
    }

    public static Set<String> getUsersIds() {
        Set<String> ids = new Set<String>();

        List<User> users = getUsersFromDb();

        for(User u : users) {
            ids.add((String)u.Id);
        }

        return ids;
    }

    public static String convertDateToString(Datetime d) {
        DateTime dt = DateTime.newInstanceGMT(d.year(), d.month(), d.day());
        return dt.formatGmt(TestDataFactory.DATE_FORMAT);
    }

    public static Case createCase() {
        Case c = new Case(Case_Type__c = 'Other',
                            Category__c = 'Sheltering Services',
                            Type = 'Problem');
        insert c;
        return c;
    }

    public static Animal__c createAnimal() {
        Case c = createCase();
        Animal__c a = new Animal__c(
                    Name = 'Doggo',
                    Case__c = c.Id,
                    Type_of_Animal__c = 'Dog',
                    Color__c = 'Black',
                    Age__c = 'Unknown At Intake',
                    Breed__c = 'Mix',
                    Animal_Age__c = 8,
                    Gender__c = 'MN',
                    Animal_Name__c = 'Doggo123',
                    Shelter_Location2__c = 'MRC',
                    Current_Location__c = 'MRC',
                    Current_Recent_Shelter_Location__c = 'CRC/MRC',
                    Play_Category__c = 'Unspecified'
        );
        insert a;
        
        User u = createUserWithProfile('ASPCA - Behavior (CRC)');
        u.Location__c = u.Division = a.Current_Recent_Shelter_Location__c;
        insert u;
        
        return a;
    }

    //adding this to avoid creating duplicate animals
    public static Animal__c createAnimalWithName(String name) {
      Case c = createCase();
      Animal__c a = new Animal__c(
                  Name = name,
                  Case__c = c.Id,
                  Type_of_Animal__c = 'Dog',
                  Color__c = 'Black',
                  Age__c = 'Unknown At Intake',
                  Breed__c = 'Mix',
                  Animal_Age__c = 8,
                  Gender__c = 'MN',
                  Animal_Name__c = name,
                  Shelter_Location2__c = 'MRC',
                  Current_Location__c = 'MRC',
                  Current_Recent_Shelter_Location__c = 'MRC'
      );
      insert a;
      return a;
  }

    public static Behavior_Evaluation__c createPuppyBehaviorEvaluation() {
        Animal__c a = createAnimal();
        Behavior_Evaluation__c be = new Behavior_Evaluation__c(
            Puppy_Behavior_in_Kennel__c = 'Social;Excited',
            Puppy_Behavior_on_Leash__c = 'Mildly fearful;Panicked',
            Animal__c = a.Id,
            Scribe_Initials__c = 'SI',
            Tester_Initials__c = 'TI',
            Handler_Initials__c = 'HI',
            Comments_BIK__c = 'Test Comments for Unit Test',
            Comments_BOL__c = 'Other Test Comments for Unit Test',
            Puppy_Skipped_DI_P1__c = 'Skipped not necessary',
            Puppy_Skipped_DI_P2__c = 'Skipped not necessary',
            Puppy_Skipped_DI_P3__c = 'Skipped not necessary',
            Evaluation_Subtype__c = 'Puppy',
            Potential_Behavior_Issues__c = 'Aggression to People;Other'
        );
        insert be;
        return be;
    }

    public static Behavior_Evaluation__c createAdultBehaviorEvaluation(Boolean isDogFighting) {
        Animal__c a = createAnimal();
        Behavior_Evaluation__c be = new Behavior_Evaluation__c(
            Behavior_in_Kennel__c = 'Social;Excited',
            Behavior_on_Leash__c = 'Mildly fearful;Panicked',
            Same_Sex_P1__c = 'Friendly;Neutral;Tense/assertive',
            Resource_Guarding_P1_Push_Face__c = 'Remained relaxed;Ate but seemed nervous',
            Resource_Guarding_P1_Touch_Body__c = 'Remained relaxed',
            Animal__c = a.Id,
            Scribe_Initials__c = 'SI',
            Tester_Initials__c = 'TI',
            Handler_Initials__c = 'HI',
            Comments_BIK__c = 'Test Comments for Unit Test',
            Comments_BOL__c = 'Other Test Comments for Unit Test',
            Comments_SSD_P1__c = 'Goodish dog',
            Evaluation_Subtype__c = isDogFighting ? 'Dog Fighting' : 'Adult Animal',
            Muzzled_SSD_P3__c = isDogFighting,
            Potential_Behavior_Issues__c = 'Aggression to People;Other'
        );
        insert be;
        return be;
    }

    public static Behavior_Evaluation__c createDogOnlyBehaviorEvaluation() {
        Animal__c a = createAnimal();
        Behavior_Evaluation__c be = new Behavior_Evaluation__c(
            Same_Sex_P1__c = 'Friendly;Neutral;Tense/assertive',
            Animal__c = a.Id,
            Scribe_Initials__c = 'SI',
            Tester_Initials__c = 'TI',
            Handler_Initials__c = 'HI',
            Comments_SSD_P1__c = 'Goodish dog',
            Evaluation_Subtype__c = 'Dog/Dog Only',
            Potential_Behavior_Issues__c = 'Aggression to People;Other'
        );
        insert be;
        return be;
    }

    public static List<Behavior_Evaluation__c> createMultipleBehaviorEvaluation(Integer numRecords, String type) {
        Animal__c a = createAnimal();
        List<Behavior_Evaluation__c> evalList = new List<Behavior_Evaluation__c>();
        for (Integer i = 0; i < numRecords; i++) {
            Behavior_Evaluation__c be = new Behavior_Evaluation__c(
                Animal__c = a.Id,
                Scribe_Initials__c = 'S'+String.valueOf(i),
                Tester_Initials__c = 'T'+String.valueOf(i),
                Handler_Initials__c = 'H'+String.valueOf(i),
                Evaluation_Subtype__c = type
            );
            evalList.add(be);
        }
        insert evalList;
        return evalList;
    }

    private static final Integer PROTOCOLCOUNT = 10;
    private static final String PROTCOLNAMEPATTERN = 'Protocol ';

    public static Treatment_Plan__c createPlan(){
        Animal__c a = createAnimal();
        Treatment_Bundle__c masterbundle = createMasterBundle();
        Treatment_Bundle__c planBundle = createTreatmentBundle();
        List<Bundle_Entry__c> planBundleEntries = assignEntries(planBundle, createProtocols());
        Treatment_Plan__c plan = new Treatment_Plan__c(
          IsActive__c = true, 
          Description__c = 'Test', 
          Animal__c = a.Id, 
          AssignedTreatmentBundleId__c = planBundle.Id,
          Problem_Behavior__c = 'Fear of People - Mild'
        );
        insert plan;
        return plan;
    }

    public static Contact createContact() {
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'test@contact.com');
        insert c;
        return c;
    }
    
    public static Contact createBehaviorCaseWorkerContact() {
        Contact c = new Contact(FirstName = 'Test', LastName = 'BCW', Email = 'test@contactbcw.com', Contact_Type__c = 'Behavior Case Worker');
        insert c;
        return c;
    }

    public static Treatment_Session__c createSession(){
        Treatment_Session__c session = new Treatment_Session__c();
        Treatment_Plan__c plan = createPlan();
        Contact contact = createBehaviorCaseWorkerContact();
        session.Treatment_Plan__c = plan.Id;
        session.Session_Contact__c = contact.Id;
        session.Animal__c = plan.Animal__c;
        insert session;
        return session;
    }

    public static List<Protocol__c> createProtocols() {
        createProtocolScales();
        List<Protocol__c> protocols = new List<Protocol__c>();
        for(Integer i = 0; i< 9; i++) {
            Protocol__c protocol = new Protocol__c();
            protocol.Name = 'Test Protocol ' + i;
            protocol.IsActive__c = true;
            protocol.Protocol_Categories__c = 'Non Fear Protocols';
            protocols.add(protocol);
        }
        
        insert protocols;
        return protocols;
    }

    public static Protocol_Scale__c[] createProtocolScales(Integer count){
      Protocol_Scale__c[] pScales = new Protocol_Scale__c[0];
      count = count == null ? 3 : count;
      for(Integer i = 0; i < count; i++){
        pScales.add(new Protocol_Scale__c(
          isActive__c = true,
          isDefault__c = true,
          Name = i == 0 ? 'Overall Score' : 'pScale' + i,
          Column_Order__c = 10 * i,
          Options__c = '1. Beginning/Acquisition;2. Catching On/ Fluency',
          Fields_to_Include__c = 'Duration__c'
        ));
      }

      insert pScales;
      return pScales;
    }

    public static Protocol_Scale__c[] createProtocolScales(){
      Protocol_Scale__c[] pScales = new Protocol_Scale__c[]{
        new Protocol_Scale__c(
          Name =  'Fear - Sociability Best',
          isActive__c =  true,
          Category__c =  'Sociability',
          Column_Order__c =  10,
          Fields_to_include__c =  null,
          isDefault__c =  true,
          Options__c =  '1. Solicitation, sustained proximity;\n2. Solicitation, short proximity;\n3. Solicitation, no proximity;\n4. No Solicitation, sustained proximity;\n5. No Solicitation, short proximity;\n6. No Solicitation, no proximity;\nNot Applicable',
          Required__c =  true
        ),
        new Protocol_Scale__c(
          Name =  'Fear Walking - Worst',
          isActive__c =  true,
          Category__c =  'Leashing',
          Column_Order__c =  50,
          Fields_to_include__c =  null,
          isDefault__c =  false,
          Options__c =  '1. Excited/energetic;\n2. Walks and pulls;\n3. Walks calmly;\n4. Walks, nervous body language;\n5. Crawls, hesitates, balks;\n6. Does not walk, immobile;\n7. Gator rolls or flees',
          Required__c =  false
        ),
        new Protocol_Scale__c(
          Name =  'Overall Score',
          isActive__c =  true,
          Category__c =  'Other',
          Column_Order__c =  80,
          Fields_to_include__c =  null,
          isDefault__c =  true,
          Options__c =  '1. Beginning/Acquisition;\n2. Catching On/ Fluency;\n3. Almost There/ Generalization;\n4. Maintenance',
          Required__c =  true
        ),
        new Protocol_Scale__c(
          Name =  'Arousal - Worst',
          isActive__c =  true,
          Category__c =  'Arousal',
          Column_Order__c =  20,
          Fields_to_include__c =  null,
          isDefault__c =  true,
          Options__c =  '1. Low/Neutral;\n2. Mild;\n3. Moderate;\n4. Extreme;\nNot Applicable',
          Required__c =  true
        ),
        new Protocol_Scale__c(
          Name =  'Arousal - Best',
          isActive__c =  true,
          Category__c =  'Arousal',
          Column_Order__c =  10,
          Fields_to_include__c =  null,
          isDefault__c =  true,
          Options__c =  '1. Low/Neutral;\n2. Mild;\n3. Moderate;\n4. Extreme;\nNot Applicable',
          Required__c =  true
        ),
        new Protocol_Scale__c(
          Name =  'Solicitation - Non-Fearful Treatment',
          isActive__c =  true,
          Category__c =  'Sociability',
          Column_Order__c =  20,
          Fields_to_include__c =  null,
          isDefault__c =  true,
          Options__c =  '1. No;\n2. Yes;\nNot Applicable',
          Required__c =  true
        ),
        new Protocol_Scale__c(
          Name =  'Aggression - Movement',
          isActive__c =  true,
          Category__c =  'Aggressive',
          Column_Order__c =  20,
          Fields_to_include__c =  null,
          isDefault__c =  true,
          Options__c =  '1. Stayed in place;\n2. Retreated or leaned away;\n3. Moved toward target;\nNot Applicable',
          Required__c =  true
        ),
        new Protocol_Scale__c(
          Name =  'Fear Walking - Best',
          isActive__c =  true,
          Category__c =  'Leashing',
          Column_Order__c =  40,
          Fields_to_include__c =  null,
          isDefault__c =  false,
          Options__c =  '1. Excited/energetic;\n2. Walks and pulls;\n3. Walks calmly;\n4. Walks, nervous body language;\n5. Crawls, hesitates, balks;\n6. Does not walk, immobile;\n7. Gator rolls or flees;',
          Required__c =  false
        ),
        new Protocol_Scale__c(
          Name =  'Aggressive - Worst',
          isActive__c =  true,
          Category__c =  'Aggressive',
          Column_Order__c =  10,
          Fields_to_include__c =  null,
          isDefault__c =  true,
          Options__c =  '1. None Observed;\n2. Hard stare, whale eye, rigid, freezes;\n3. Head whips, lifts lip, growls or alarm barks;\n4. Air snaps or muzzle punches;\n5. Tries to bite or bites;',
          Required__c =  true
        ),
        new Protocol_Scale__c(
          Name =  'Fear - Best',
          isActive__c =  true,
          Category__c =  'Fear',
          Column_Order__c =  10,
          Fields_to_include__c =  null,
          isDefault__c =  true,
          Options__c =  '1. Excited, playful, interested;\n2. Neutral;\n2. Mildly fearful;\n3. Moderately fearful;\n4. Extremely fearful;\nNot Applicable',
          Required__c =  true
        ),
        new Protocol_Scale__c(
          Name =  'Fear - Containment Method Used',
          isActive__c =  true,
          Category__c =  'Fear',
          Column_Order__c =  60,
          Fields_to_include__c =  'Duration__c',
          isDefault__c =  false,
          Options__c =  '1. Willingly went in;\n2. Lured;\n3. Blocked;\n4. Lifted;\n5. Leash pressure',
          Required__c =  false
        ),
        new Protocol_Scale__c(
          Name =  'Fear - Worst',
          isActive__c =  true,
          Category__c =  'Fear',
          Column_Order__c =  20,
          Fields_to_include__c =  null,
          isDefault__c =  true,
          Options__c =  '1. Excited, playful, interested;\n2. Neutral;\n2. Mildly fearful;\n3. Moderately fearful;\n4. Extremely fearful;\nNot Applicable',
          Required__c =  true
        ),
        new Protocol_Scale__c(
          Name =  'Leash – How Attached',
          isActive__c =  true,
          Category__c =  'Leashing',
          Column_Order__c =  30,
          Fields_to_include__c =  null,
          isDefault__c =  false,
          Options__c =  '1. Dog stayed near or approached (handler stands);2. Dog stayed near or approached (handler squats);\n3. Tester walked forward normally;\n4. Tester crept slowly forward;\n5. Tester crept slowly backward;\n6. With stealth (dog evasive or aggressive);\n7. Leashing attempts failed. Dog not moved;\n8. Leashing attempts failed. Dog moved in crate, chute, or carried;\n9. No leashing attempt made. Dog moved in crate, chute, or carried;',
          Required__c =  false
        )
    };
    insert pScales;
    return pScales;
  }

    public static List<Session_Protocol__c> createSessionProtocols() {
        List<Protocol__c> protocols = createProtocols();
        Treatment_Session__c session = createSession();
        Session_Protocol__c[] sessionProtocols = [SELECT Id, TreatmentSessionId__c, TreatmentSessionId__r.Treatment_Plan__c, ProtocolId__c FROM Session_Protocol__c WHERE TreatmentSessionId__c =: session.Id];
        return sessionProtocols;
    }

    public static Session_Protocol_Scale__c[] createSessionProtocolScales(){
      Protocol_Scale__c[] pScales = createProtocolScales(3);
      Session_Protocol__c[] sessionProtocols = createSessionProtocols();
      Session_Protocol_Scale__c[] sessionProtoScales = new Session_Protocol_Scale__c[0];
      for(Session_Protocol__c sessionProto : sessionProtocols){
        for(Protocol_Scale__c protoScale : pScales){
          sessionProtoScales.add(new Session_Protocol_Scale__c(
            Protocol_Scale__c = protoScale.Id,
            Session_Protocol__c = sessionProto.Id
          ));
        }
      }
      insert sessionProtoScales;
      return sessionProtoScales;
    }

    public static Treatment_Bundle__c createTreatmentBundle() {
        Treatment_Bundle__c bundle = new Treatment_Bundle__c();
        bundle.Name = 'Test';
        bundle.IsActive__c = true;
        bundle.Enrichment_Activities__c = 'Nose Work;Snuffle mat;Tug pully';
        insert bundle;
        return bundle;
    }

    public static Treatment_Bundle__c createMasterBundle() {
        Treatment_Bundle__c bundle = new Treatment_Bundle__c();
        bundle.Name = 'Master';
        bundle.IsActive__c = true;
        bundle.IsMaster__c = true;
        insert bundle;
        return bundle;
    }

    public static List<Protocol__c> createProtocols(Integer count) {
        Integer i = 0;
        List<Protocol__c> protocols = new List<Protocol__c>();
        while (i != count) {
            Protocol__c protocol = new Protocol__c();
            protocol.Name = 'Test ' + i;
            protocol.IsActive__c = true;
            protocol.Description__c = 'This is a Test Protocol';
            protocols.add(protocol);
            i++;
        }
        insert protocols;
        return protocols;
    }

    public static List<Bundle_Entry__c> assignEntries(Treatment_Bundle__c bundle, List<Protocol__c> protocols) {
        List<Bundle_Entry__c> entries = new List<Bundle_Entry__c>();
        for (Protocol__c pro : protocols) {
            Bundle_Entry__c entry = new Bundle_Entry__c();
            entry.Treatment_Bundle__c = bundle.Id;
            entry.Protocol__c = pro.Id;
            entries.add(entry);
        }
        insert entries;
        return entries;
    }
    
    public static List<Plan_Protocol__c> createPlanProtocols(Integer numRecords) {
        List<Plan_Protocol__c> planProtocolList = new List<Plan_Protocol__c>();
        Treatment_Plan__c plan = createPlan();
        // List<Protocol__c> protocolList = createProtocols(numRecords);
        List<Protocol__c> protocolList = createProtocols();
        for (Integer i = 0; i < numRecords; i++) {
            Plan_Protocol__c newProtocol = new Plan_Protocol__c(Treatment_Plan__c = plan.Id, Protocol__c = protocolList[i].Id, IsRemoved__c = Math.mod(i, 2) != 0);
            planProtocolList.add(newProtocol);
        }
        insert planProtocolList;
        return planProtocolList;
    }

    public static Session_Protocol_Contact__c[] createSessionProtocolContact(){
      Session_Protocol__c[] protocolList = createSessionProtocols();
        Session_Protocol_Contact__c[] sContacts = new Session_Protocol_Contact__c[0];
        Contact con = new Contact(
          LastName = 'Foo'
        );
        insert con;
        for(Session_Protocol__c protocol : protocolList){
          Session_Protocol_Contact__c sCon = new Session_Protocol_Contact__c(
            Session_Protocol__c = protocol.Id,
            Contact__c = con.Id,
            Novel_Not_Novel__c = 'Familiar'
          );
          sContacts.add(sCon);
        }
        insert sContacts;
        return sContacts;
    }

    public static Additional_Dog_Present__c[] createAdditionalDogs(){
      Session_Protocol__c[] protocolList = createSessionProtocols();
      Additional_Dog_Present__c[] aDogs = new Additional_Dog_Present__c[0];
        Animal__c dog = [SELECT Id FROM Animal__c LIMIT 1];
        dog.Potential_Helper_Dog__c = true;
        update dog;
        for(Session_Protocol__c protocol : protocolList){
          Additional_Dog_Present__c aDog = new Additional_Dog_Present__c(
            Session_Protocol__c = protocol.Id,
            Additional_Dog__c = dog.Id
          );
          aDogs.add(aDog);
        }
        insert aDogs;
        return aDogs;
    }

    public static Observation__c[] createObservations(){
      Animal__c animal = createAnimal();
      String[] observationTypes = new String[]{'Happy Tail', 'Observation', 'Concern'};
      Observation__c[] newObservations = new Observation__c[0];
      for(String type : observationTypes){
        Observation__c observation = new Observation__c(
          Animal__c = animal.Id,
          Observation_Type__c = type,
          Observation_Notes__c = 'test Notes',
          Observation_Reported_By__c = 'TN'
        );
        newObservations.add(observation);
      }
      insert newObservations;
      return newObservations;
    }

    public static Daily_Enrichment__c createEnrichment() {
        Animal__c a = createAnimal();
        Daily_Enrichment__c enrichment = new Daily_Enrichment__c(
            Animal__c = a.Id,
            Notes__c = 'Test notes for test data factory',
            DE_Date__c = System.today(),
            Enrichment_Coordinator__c = 'Hailey Kohl'
        );
        insert enrichment;
        return enrichment;
    }

    public static List<Medical_Conditions__c> createMedicalConditions(Animal__c a) {
        List<Medical_Conditions__c> medConditions = new List<Medical_Conditions__c>{
            new Medical_Conditions__c(
                Animal__c = a.Id,
                Medical_Condition__c = 'Babesia',
                Date_Diagnosed__c = System.today()),
            new Medical_Conditions__c(
                Animal__c = a.Id,
                Medical_Condition__c = 'Dermatitis',
                Date_Diagnosed__c = System.today())
        };
        insert medConditions;
        return medConditions;
    }

    public static List<Play_Pause__c> createPlayPauses(Animal__c a) {
        List<Play_Pause__c> playPauses = new List<Play_Pause__c>{
            new Play_Pause__c(
                Animal__c = a.Id,
                Type__c = 'Medical',
                Play_Pause_Reason__c = 'In Heat',
                Start_Date__c = System.today()),
            new Play_Pause__c(
                Animal__c = a.Id,
                Type__c = 'Behavioral',
                Play_Pause_Reason__c = 'Needs a Break',
                Start_Date__c = System.today())
        };
        insert playPauses;
        return playPauses;
    }

    public static Playgroup_Session__c createPlaygroupSessionWithAnimals() {
        Animal__c a = createAnimal();
        Contact c = createContact();
        Playgroup_Session__c session = new Playgroup_Session__c(
            Playgroup_Location__c = 'MRC Indoor Play Yard',
            Population__c = 'MRC',
            Playgroup_Leader__c = c.Id,
            Contact_Ids__c = c.Id
        );
        insert session;
        Animal_Playgroup__c animalPlaygroup = new Animal_Playgroup__c(
            Animal__c = a.Id,
            Playgroup_Session__c = session.Id,
            Common_Playgroup_Note_Sections__c = 'Greeting',
            Common_Playgroup_Notes__c = 'Airhorn',
            Play_Rating__c = 'Green',
            Playgroup_Individual_Notes__c = 'Individual note'
        );
        insert animalPlaygroup;
        Playgroup_Contact__c playgroupContact = new Playgroup_Contact__c(
            Contact__c = c.Id,
            Novel_Not_Novel__c = 'PG Leader',
            Playgroup__c = animalPlaygroup.Id
        );
        Playgroup_Contact__c playgroupLeaderContact = new Playgroup_Contact__c(
          Contact__c = createContact().Id,
          Novel_Not_Novel__c = 'Novel',
          Playgroup__c = animalPlaygroup.Id
      );
        insert new Playgroup_Contact__c[]{playgroupContact, playgroupLeaderContact};
        return session;
    }

    public static Facility_Outcome__c createFacilityOutcome() {
        Animal__c a = createAnimal();
        Contact c = createContact();
        Facility_Outcome__c facility = new Facility_Outcome__c(
            Animal__c = a.Id,
            Facility_or_Outcome__c = 'Facility',
            Facility_Outcome__c = 'Foster Home',
            Point_of_Contact__c = c.Id,
            Start_Date__c = System.today()
        );
        insert facility;
        return facility;
    }

    public static List<Facility_Outcome__c> createWeeklyMonthlyFacilityOutcomes() {
        Contact c = createContact();
        List<Facility_Outcome__c> fosterList = new List<Facility_Outcome__c>{
            new Facility_Outcome__c(
                Animal__c = createAnimalWithName('Dog1').Id,
                Facility_or_Outcome__c = 'Facility',
                Facility_Outcome__c = 'Foster Home',
                Point_of_Contact__c = c.Id,
                Start_Date__c = System.today().addDays(-7)),
            new Facility_Outcome__c(
                Animal__c = createAnimalWithName('Dog2').Id,
                Facility_or_Outcome__c = 'Facility',
                Facility_Outcome__c = 'Foster Home',
                Point_of_Contact__c = c.Id,
                Start_Date__c = System.today().addDays(-14)),
            new Facility_Outcome__c(
                Animal__c = createAnimalWithName('Dog3').Id,
                Facility_or_Outcome__c = 'Facility',
                Facility_Outcome__c = 'Foster Home',
                Point_of_Contact__c = c.Id,
                Start_Date__c = System.today().addDays(-21)),
            new Facility_Outcome__c(
                Animal__c = createAnimalWithName('Dog4').Id,
                Facility_or_Outcome__c = 'Facility',
                Facility_Outcome__c = 'Foster Home',
                Point_of_Contact__c = c.Id,
                Start_Date__c = System.today().addDays(-28)),
            new Facility_Outcome__c(
                Animal__c = createAnimalWithName('Dog5').Id,
                Facility_or_Outcome__c = 'Facility',
                Facility_Outcome__c = 'Foster Home',
                Point_of_Contact__c = c.Id,
                Start_Date__c = System.today().addDays(-56)),
            new Facility_Outcome__c(
                Animal__c = createAnimalWithName('Dog6').Id,
                Facility_or_Outcome__c = 'Facility',
                Facility_Outcome__c = 'Foster Home',
                Point_of_Contact__c = c.Id,
                Start_Date__c = System.today().addDays(-5)),
            new Facility_Outcome__c(
                Animal__c = createAnimalWithName('Dog7').Id,
                Facility_or_Outcome__c = 'Facility',
                Facility_Outcome__c = 'Foster Home',
                Point_of_Contact__c = c.Id,
                Start_Date__c = System.today().addDays(-33)),
            new Facility_Outcome__c(
                Animal__c = createAnimalWithName('Dog8').Id,
                Facility_or_Outcome__c = 'Facility',
                Facility_Outcome__c = 'Foster Home',
                Point_of_Contact__c = c.Id,
                Start_Date__c = System.today().addDays(-26))
        };
        insert fosterList;
        return fosterList;
    }

    public static Daily_Care__c createDailyCareWithAnimalDailyCares(Integer animalCount){
      Animal__c[] animals = new Animal__c[0];
      for(Integer i = 0; i < animalCount; i++){
        animals.add(createAnimalWithName('name' + i));
      }
      Daily_Care__c dc = createDailyCare();
      Animal_Daily_Care__c[] adcs = new Animal_Daily_Care__c[0];
      for(Animal__c a : animals){
        adcs.add(new Animal_Daily_Care__c(
          Animal__c = a.Id,
          Daily_Care__c = dc.Id
        ));
      }

      insert adcs;
      return dc;
    }

    public static Daily_Care__c createDailyCare(){
      Daily_Care__c dc = new Daily_Care__c(
        Date__c = date.today()
      );
      insert dc;
      return dc;
    }

    public static Task[] createBehaviorTreatmentTasks(){
      Animal__c dog = createAnimal();

      Date startDate = AutoScheduleTasksUtil.startOfASPCAWeek(date.today());
      Date activityDate1 = startDate.addDays(1);
      Date activityDate2 = startDate.addDays(3);
      Date activityDate3 = startDate.addDays(5);

      Id rtId = Util.getRecordTypeId('Task', AutoScheduleTasksUtil.BEH_TREATMENT_TASK_RECORD_TYPE_NAME);

      Task[] tasks = new Task[0];

      Task t1 = new Task(
        ActivityDate = activityDate1,
        Animal__c = dog.Id,
        RecordTypeId = rtId
      );
      tasks.add(t1);

      Task t2 = new Task(
        ActivityDate = activityDate2,
        Animal__c = dog.Id,
        RecordTypeId = rtId
      );
      tasks.add(t2);

      Task t3 = new Task(
        ActivityDate = activityDate3,
        Animal__c = dog.Id,
        RecordTypeId = rtId
      );
      tasks.add(t3);

      insert tasks;
      return tasks;

    }

    public static task createMedicationTask(Id animalId){
      Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.TREATMENT_TASK_RECORD_TYPE_NAME);

      Medication_Drug__c drug = new Medication_Drug__c(
        Name = 'testDrug'
      ); 

      insert drug;

      Task t = new Task(
        Animal__c = animalId,
        RecordTypeId = recordTypeId,
        ActivityDate = date.today().addDays(2),
        Medication__c = drug.Id
      );

      insert t;
      return t;
    }
}