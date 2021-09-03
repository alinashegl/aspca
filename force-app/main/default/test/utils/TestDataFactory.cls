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
                    UserName = (uid + '@' +  (String)USER_PATTERN.get('domain'))
            );
            users.add(u);
        }

        insert users;
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
                    Shelter_Location2__c = 'MRC'
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
            Animal__c = a.Id,
            Scribe_Initials__c = 'SI',
            Tester_Initials__c = 'TI',
            Handler_Initials__c = 'HI',
            Comments_BIK__c = 'Test Comments for Unit Test',
            Comments_BOL__c = 'Other Test Comments for Unit Test',
            Comments_SSD_P1__c = 'Goodish dog',
            Evaluation_Subtype__c = isDogFighting ? 'Dog Fighting' : 'Adult Animal',
            Potential_Behavior_Issues__c = 'Aggression to People;Other'
        );
        insert be;
        return be;
    }

    private static final Integer PROTOCOLCOUNT = 10;
    private static final String PROTCOLNAMEPATTERN = 'Protocol ';

    public static Treatment_Plan__c createPlan(){
        Treatment_Plan__c plan = new Treatment_Plan__c(IsActive__c = true, Description__c = 'Test');
        insert plan;
        return plan;
    }

    public static Treatment_Session__c createSession(){
        Treatment_Session__c session = new Treatment_Session__c();
        Treatment_Plan__c plan = createPlan();
        session.Treatment_Plan__c = plan.Id;
        insert session;
        return session;
    }

    public static List<Protocol__c> createProtocols() {
        List<Protocol__c> protocols = new List<Protocol__c>();
        Integer i = 0;
        while(i != 9) {
            Protocol__c protocol = new Protocol__c();
            protocol.Name = 'Test Protocol ' + i;
            protocol.IsActive__c = true;
            protocols.add(protocol);
            i++;
        }
        insert protocols;
        return protocols;
    }
    public static List<Session_Protocol__c> createSessionProtocols() {
        List<Protocol__c> protocols = createProtocols();
        Treatment_Session__c session = createSession();
        List<Session_Protocol__c> sessionProtocols = new List<Session_Protocol__c>();
        for (Protocol__c protocol : protocols) {
            Session_Protocol__c sessionProtocol = new Session_Protocol__c();
            sessionProtocol.TreatmentSessionId__c = session.Id;
            sessionProtocol.ProtocolId__c = protocol.Id;
            sessionProtocols.add(sessionProtocol);
        }
        insert sessionProtocols;
        return sessionProtocols;
    }
}