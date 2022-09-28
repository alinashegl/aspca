@isTest
private class TestCreateActionItem_Obj{
/*    static testMethod void testIncident(){
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u4 = new User();
        u4.Username='bakul@gmail.com';
        u4.email = 'dileep.kumar@aspiresoftwareconsultancy.com';
        u4.lastname = 'tester';
        u4.firstname = 'u4user';
        u4.emailencodingkey='UTF-8';
        u4.alias = 'u4user';
        u4.languagelocalekey='en_US';  
        u4.localesidkey='en_US';
        u4.timezonesidkey='America/Los_Angeles';
        u4.profileid = pf.Id;
        u4.isactive = True;
        insert u4;
        
        List<Contact> coList = new List<Contact>();
        Contact c1 = new Contact();
        c1.FirstName = 'Dileep';
        c1.LastName = 'Kumar';
        c1.MailingStreet = 'Btm';
        c1.MailingCity = 'Bangalore';
        c1.MailingState = 'NY'; 
        c1.County__c = 'India';
        c1.Contact_Type__c = 'Abc';
        coList.add(c1);
        //insert c1;
        Contact c2 = new Contact();
        c2.FirstName = 'Dileep';
        c2.LastName = 'Kumar';
        c2.MailingStreet = 'Btm';
        c2.MailingCity = 'Bangalore';
        c2.MailingState = 'NY'; 
        c2.County__c = 'India';
        c2.Contact_Type__c = 'Abc';
        coList.add(c2);
        insert coList;

        List<Contact> contactList = [select Id,Name,FirstName,LastName,Contact_Type__c,MailingCity,MailingState,MailingStreet,Account.Name from Contact where Id IN:coList];
        system.debug('@@contactList@@'+contactList);
        
        Action_Item__c c = new Action_Item__c();
        c.Complaint_Summary__c = 'hello'; 
        c.Case_Origin__c = 'Email';
		c.Date_Received__c = System.today();        
        insert c;
		
        List<Action_Item_Scene_Location__c>  sceneList = new List<Action_Item_Scene_Location__c> ();
        Action_Item_Scene_Location__c scene = new  Action_Item_Scene_Location__c();
        scene.Action_Item__c = c.Id;
        scene.Name = 'SceneOne';
        scene.Address_Line_1__c = 'Btm';
        scene.City__c = 'Bangalore';
        scene.State__c = 'NY';
        scene.Zipcode__c = '123456';
        scene.County__c = 'India';
        scene.Description__c = 'Welcome';
        scene.Primary_Incident_Location__c =true;
        sceneList.add(scene);
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = 'Dileep';
        con.LastName = 'Kumar';
        con.MailingStreet = 'Btm';
        con.MailingCity = 'Bangalore';
        con.MailingState = 'Karnataka'; 
        con.County__c = 'India';
        con.Contact_Type__c = 'Abc';
        
        Contact conOne = new Contact();
        conOne.FirstName = 'Manohar';
        conOne.LastName = 'Kumar';
        conOne.MailingStreet = 'Btm';
        conOne.MailingCity = 'Bangalore';
        conOne.MailingState = 'Karnataka'; 
        conOne.County__c = 'India';
        conOne.Contact_Type__c = 'Abc';
        
        List<Action_Item_Role__c> cRoleList = new List<Action_Item_Role__c>(); 
        Action_Item_Role__c  ccRole = new Action_Item_Role__c ();
        ccRole.Action_Item__c = c.Id;
        ccRole.Role__c = 'Officer'; 
        Action_Item_Role__c  ccRoleThree = new Action_Item_Role__c ();
        ccRoleThree.Action_Item__c = c.Id;
        ccRoleThree.Role__c = 'Officer';
        
        
        List<SelectOption> searchResults = new List<SelectOption>();
        List<SelectOption> searchResult = new List<SelectOption>();
        for(Contact cont :contactList ){
        	searchResult.add(new SelectOption(cont.Id,cont.Name + ' - ' + cont.MailingStreet +' , '+ cont.MailingCity +' , '+ cont.MailingState +' - '+ ' Account: ' + cont.Account.Name + ' - ' + 'Contact Type' + ': ' + cont.Contact_Type__c));
        	system.debug('@@searchResult@@'+searchResult);
        }
        for(Contact contac : contactList){
        	searchResults.add(new SelectOption(contac.Id,contac.Name + ' - ' + contac.MailingStreet +' , '+ contac.MailingCity +' , '+ contac.MailingState +' - '+ ' Account: ' + contac.Account.Name + ' - ' + 'Contact Type' + ': ' + contac.Contact_Type__c));
        	system.debug('@@searchResults@@'+searchResults);
        }
        string useOrAddContact;
        useOrAddContact='Add';
        string useOrAddContactOne;
        useOrAddContactOne='Use';
        
        string useOrAddContactTwo;
        useOrAddContactTwo='Add';
        string useOrAddContactThree;
        useOrAddContactThree='Use';
        CreateActionItem_Obj ci = new CreateActionItem_Obj();
        ci.sceneList = sceneList; 
        ci.complainants[0].con=con;
        ci.complainants[0].conSearchText ='k';
        ci.subjects[0].con=conOne;
        
        ci.conList = conList;   
       	//ci.ccRole= ccRole; 
         
        
        ci.complainants[0].useOrAddContact = useOrAddContact;
        ci.complainants[0].useOrAddContact = useOrAddContactOne;
        ci.complainants[0].searchResults = searchResult;
        ci.complainants[0].ccRole.Contact__c = con.Id;
        ci.complainants[0].ccRole.Role__c ='we';
        ci.complainants[0].ccRole.Action_Item__c = c.Id;
        ci.complainants[0].ccRole = ccRole;
        ci.cRoleList =cRoleList;
        
        
        ci.subjects[0].useOrAddContact = useOrAddContactTwo;
        //ci.subjects[0].useOrAddContact = useOrAddContactThree;
        ci.subjects[0].searchResults = searchResults;
        ci.subjects[0].ccRole.Contact__c = con.Id;
        ci.subjects[0].ccRole.Role__c ='';
        ci.subjects[0].ccRole.Action_Item__c = c.Id;
        ci.subjects[0].ccRole = ccRole;
        //ci.subjects[0].cRoleList = cRoleList;
        ci.cRoleList = cRoleList;
        ci.addComplainant();
        ci.addSubject(); 
        Apexpages.currentPage().getParameters().put('index', '1');
        Apexpages.currentPage().getParameters().put('type', '');
        ci.searchContact(); 
        ci.addNewLocation();
         system.runAs(u4){
        	ci.saveData();
        } 
    }
    static testMethod void testIncidentOne(){
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u4 = new User();
        u4.Username='bakul@gmail.com';
        u4.email = 'dileep.kumar@aspiresoftwareconsultancy.com';
        u4.lastname = 'tester';
        u4.firstname = 'u4user';
        u4.emailencodingkey='UTF-8';
        u4.alias = 'u4user';
        u4.languagelocalekey='en_US';  
        u4.localesidkey='en_US';
        u4.timezonesidkey='America/Los_Angeles';
        u4.profileid = pf.Id;
        u4.isactive = True;
        insert u4;
         
        Action_Item__c c = new Action_Item__c();
        c.Complaint_Summary__c = 'hello';
        c.Case_Origin__c = 'Email';
        c.Date_Received__c = Date.newInstance(2016, 12, 9);
        insert c;
		
        List<Action_Item_Scene_Location__c>  sceneList = new List<Action_Item_Scene_Location__c> ();
        Action_Item_Scene_Location__c scene = new  Action_Item_Scene_Location__c();
        scene.Action_Item__c = c.Id;
        scene.Name = 'SceneOne';
        scene.Address_Line_1__c = 'Btm';
        scene.City__c = 'Bangalore';
        scene.State__c = 'NY';
        scene.Zipcode__c = '123456';
        scene.County__c = 'India';
        scene.Description__c = 'Welcome';
        scene.Primary_Incident_Location__c =true;
        sceneList.add(scene);
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = 'Dileep';
        con.LastName = 'Kumar';
        con.MailingStreet = 'Btm';
        con.MailingCity = 'Bangalore';
        con.MailingState = 'NY'; 
        con.County__c = 'India';
        con.Contact_Type__c = 'Abc';
        conList.add(con);
        
        Contact conOne = new Contact();
        conOne.FirstName = 'Manohar';
        conOne.LastName = 'Kumar';
        conOne.MailingStreet = 'Btm';
        conOne.MailingCity = 'Bangalore';
        conOne.MailingState = 'NY'; 
        conOne.County__c = 'India';
        conOne.Contact_Type__c = 'Abc';
        conList.add(conOne);
        
        List<Action_Item_Role__c> cRoleList = new List<Action_Item_Role__c>(); 
        Action_Item_Role__c  ccRole = new Action_Item_Role__c ();
        ccRole.Action_Item__c = c.Id;
        ccRole.Role__c = 'Officer';
        cRoleList.add(ccRole);
        Action_Item_Role__c  ccRoleThree = new Action_Item_Role__c ();
        ccRoleThree.Action_Item__c = c.Id;
        ccRoleThree.Role__c = 'Officer';
        cRoleList.add(ccRoleThree);
        
        List<Contact> contactList = [select Id,Name,FirstName,LastName,Contact_Type__c,MailingCity,MailingState,MailingStreet,Account.Name from Contact];
        List<SelectOption> searchResults = new List<SelectOption>();
        List<SelectOption> searchResult = new List<SelectOption>();
        for(Contact cont :contactList ){
        	searchResult.add(new SelectOption(cont.Id,cont.Name + ' - ' + cont.MailingStreet +' , '+ cont.MailingCity +' , '+ cont.MailingState +' - '+ ' Account: ' + cont.Account.Name + ' - ' + 'Contact Type' + ': ' + cont.Contact_Type__c));
        }
        for(Contact contac : contactList){
        	searchResults.add(new SelectOption(contac.Id,contac.Name + ' - ' + contac.MailingStreet +' , '+ contac.MailingCity +' , '+ contac.MailingState +' - '+ ' Account: ' + contac.Account.Name + ' - ' + 'Contact Type' + ': ' + contac.Contact_Type__c));
        }
        
        string useOrAddContact;
        useOrAddContact='Add';
        string useOrAddContactOne;
        useOrAddContactOne='Use';
         
        CreateActionItem_Obj ci = new CreateActionItem_Obj();
        ci.sceneList = sceneList; 
        
        
        // ci.complainants[0].con=con; 
        ci.subjects[0].con=con;
        ci.conList = conList;   
       	//ci.ccRole= ccRole; 
         
        
        ci.subjects[0].useOrAddContact = useOrAddContact;
        ci.subjects[0].useOrAddContact = useOrAddContactOne;
        ci.subjects[0].searchResults = searchResult;
        ci.subjects[0].ccRole.Contact__c = con.Id;
        ci.subjects[0].ccRole.Role__c='we';
        ci.subjects[0].ccRole.Action_Item__c= c.Id;
        ci.subjects[0].ccRole = ccRole;
        ci.cRoleList =cRoleList;
        
        
        ci.addComplainant();
        ci.addSubject();
        Apexpages.currentPage().getParameters().put('index', '1');
        Apexpages.currentPage().getParameters().put('type', '');
        ci.searchContact(); 
        ci.addNewLocation();
        
        system.runAs(u4){
        	ci.saveData();
        } 
    }*/
    static testMethod void testIncidentTwo(){
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u4 = new User();
        u4.Username='bakul@gmail.com';
        u4.email = 'dileep.kumar@aspiresoftwareconsultancy.com';
        u4.lastname = 'tester';
        u4.firstname = 'u4user';
        u4.emailencodingkey='UTF-8';
        u4.alias = 'u4user';
        u4.languagelocalekey='en_US';  
        u4.localesidkey='en_US';
        u4.timezonesidkey='America/Los_Angeles';
        u4.profileid = pf.Id;
        u4.isactive = True;
        insert u4;
        
        Action_Item__c c = new Action_Item__c();
        c.Complaint_Summary__c = 'hello';
        c.Case_Origin__c = 'Social Media';
        c.Date_Received__c = Date.newInstance(2018, 12, 9);
        insert c;
		
        List<Action_Item_Scene_Location__c>  sceneList = new List<Action_Item_Scene_Location__c> ();
        Action_Item_Scene_Location__c scene = new  Action_Item_Scene_Location__c();
        scene.Action_Item__c = c.Id;
        scene.Name = 'SceneOne';
        scene.Address_Line_1__c = 'Btm';
        scene.City__c = 'Bangalore';
        scene.State__c = 'NY';
        scene.Zipcode__c = '123456';
        scene.County__c = 'India';
        scene.Description__c = 'Welcome';
        scene.Primary_Incident_Location__c =true;
        sceneList.add(scene);
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = 'Dileep';
        con.LastName = 'Kumar';
        con.MailingStreet = 'Btm';
        con.MailingCity = 'Bangalore';
        con.MailingState = 'NY'; 
        con.County__c = 'India';
        con.Contact_Type__c = 'Abc';
        conList.add(con);
        
        Contact conOne = new Contact();
        conOne.FirstName = 'Manohar';
        conOne.LastName = 'Kumar';
        conOne.MailingStreet = 'Btm';
        conOne.MailingCity = 'Bangalore';
        conOne.MailingState = 'NY'; 
        conOne.County__c = 'India';
        conOne.Contact_Type__c = 'Abc';
        conList.add(conOne);
        
        List<Action_Item_Role__c> cRoleList = new List<Action_Item_Role__c>(); 
        Action_Item_Role__c  ccRole = new Action_Item_Role__c ();
        ccRole.Action_Item__c = c.Id;
        ccRole.Role__c = 'Officer';
        cRoleList.add(ccRole);
        Action_Item_Role__c  ccRoleThree = new Action_Item_Role__c ();
        ccRoleThree.Action_Item__c = c.Id;
        ccRoleThree.Role__c = 'Officer';
        cRoleList.add(ccRoleThree);
         
        CreateActionItem_Obj ci = new CreateActionItem_Obj();
        ci.sceneList = sceneList; 
        
        system.runAs(u4){
        	ci.saveData();
        }
        
         
        CreateActionItem_Obj.ContactWrapper aa = new CreateActionItem_Obj.ContactWrapper();
        ci.addComplainant();
        ci.addSubject();
        Apexpages.currentPage().getParameters().put('index', '1');
        Apexpages.currentPage().getParameters().put('type', '');
        ci.searchContact(); 
        ci.addNewLocation(); 
    }
    static testMethod void testIncidentThree(){
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u4 = new User();
        u4.Username='bakul@gmail.com';
        u4.email = 'dileep.kumar@aspiresoftwareconsultancy.com';
        u4.lastname = 'tester';
        u4.firstname = 'u4user';
        u4.emailencodingkey='UTF-8';
        u4.alias = 'u4user';
        u4.languagelocalekey='en_US';  
        u4.localesidkey='en_US';
        u4.timezonesidkey='America/Los_Angeles';
        u4.profileid = pf.Id;
        u4.isactive = True;
        insert u4;
        
        Action_Item__c c = new Action_Item__c();
        c.Complaint_Summary__c = 'hello';
        c.Case_Origin__c = 'Social Media';
        c.Date_Received__c = Date.newInstance(2019, 12, 9);
        insert c;
		
        List<Action_Item_Scene_Location__c>  sceneList = new List<Action_Item_Scene_Location__c> ();
        Action_Item_Scene_Location__c scene = new  Action_Item_Scene_Location__c();
        scene.Action_Item__c = c.Id;
        scene.Name = 'SceneOne';
        scene.Address_Line_1__c = 'Btm';
        scene.City__c = 'Bangalore';
        scene.State__c = 'NY';
        scene.Zipcode__c = '123456';
        scene.County__c = 'India';
        scene.Description__c = 'Welcome';
        scene.Primary_Incident_Location__c =true;
        sceneList.add(scene);
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = 'Dileep';
        con.LastName = 'Kumar';
        con.MailingStreet = 'Btm';
        con.MailingCity = 'Bangalore';
        con.MailingState = 'NY'; 
        con.County__c = 'India';
        con.Contact_Type__c = 'Abc';
        conList.add(con);
        
        Contact conOne = new Contact();
        conOne.FirstName = 'Manohar';
        conOne.LastName = 'Kumar';
        conOne.MailingStreet = 'Btm';
        conOne.MailingCity = 'Bangalore';
        conOne.MailingState = 'NY'; 
        conOne.County__c = 'India';
        conOne.Contact_Type__c = 'Abc';
        conList.add(conOne);
        
        List<Action_Item_Role__c> cRoleList = new List<Action_Item_Role__c>(); 
        Action_Item_Role__c  ccRole = new Action_Item_Role__c ();
        ccRole.Action_Item__c = c.Id;
        ccRole.Role__c = 'Officer';
        cRoleList.add(ccRole);
        Action_Item_Role__c  ccRoleThree = new Action_Item_Role__c ();
        ccRoleThree.Action_Item__c = c.Id;
        ccRoleThree.Role__c = 'Officer';
        cRoleList.add(ccRoleThree);
         
        CreateActionItem_Obj ci = new CreateActionItem_Obj();
        ci.sceneList = sceneList; 
        
        system.runAs(u4){
        	ci.saveData();
        }
        
        CreateActionItem_Obj.ContactWrapper aa = new CreateActionItem_Obj.ContactWrapper();
        ci.addComplainant();
        ci.addSubject();
        Apexpages.currentPage().getParameters().put('index', '1');
        Apexpages.currentPage().getParameters().put('type', '');
        ci.searchContact(); 
        ci.addNewLocation(); 
    }
    static testMethod void testIncidentFour(){
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u4 = new User();
        u4.Username='bakul@gmail.com';
        u4.email = 'dileep.kumar@aspiresoftwareconsultancy.com';
        u4.lastname = 'tester';
        u4.firstname = 'u4user';
        u4.emailencodingkey='UTF-8';
        u4.alias = 'u4user';
        u4.languagelocalekey='en_US';  
        u4.localesidkey='en_US';
        u4.timezonesidkey='America/Los_Angeles';
        u4.profileid = pf.Id;
        u4.isactive = True;
        insert u4;
        
        Action_Item__c c = new Action_Item__c();
        c.Complaint_Summary__c = 'hello';
        c.Case_Origin__c = 'Social Media';
        c.Date_Received__c = System.today();
        insert c;     
		
        List<Action_Item_Scene_Location__c>  sceneList = new List<Action_Item_Scene_Location__c> ();
        Action_Item_Scene_Location__c scene = new  Action_Item_Scene_Location__c();
        scene.Action_Item__c = c.Id;
        scene.Name = 'SceneOne';
        scene.Address_Line_1__c = 'Btm';
        scene.City__c = 'Bangalore';
        scene.State__c = 'NY';
        scene.Zipcode__c = '123456';
        scene.County__c = 'India';
        scene.Description__c = 'Welcome';
        scene.Primary_Incident_Location__c =true;
        sceneList.add(scene);
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = 'Dileep';
        con.LastName = 'Kumar';
        con.MailingStreet = 'Btm';
        con.MailingCity = 'Bangalore';
        con.MailingState = 'NY'; 
        con.County__c = 'India';
        con.Contact_Type__c = 'Abc';
        conList.add(con);
        
        Contact conOne = new Contact();
        conOne.FirstName = 'Manohar';
        conOne.LastName = 'Kumar';
        conOne.MailingStreet = 'Btm';
        conOne.MailingCity = 'Bangalore';
        conOne.MailingState = 'NY'; 
        conOne.County__c = 'India';
        conOne.Contact_Type__c = 'Abc';
        conList.add(conOne);
        
        List<Action_Item_Role__c> cRoleList = new List<Action_Item_Role__c>(); 
        Action_Item_Role__c  ccRole = new Action_Item_Role__c ();
        ccRole.Action_Item__c = c.Id;
        ccRole.Role__c = 'Officer';
        cRoleList.add(ccRole);
        Action_Item_Role__c  ccRoleThree = new Action_Item_Role__c ();
        ccRoleThree.Action_Item__c = c.Id;
        ccRoleThree.Role__c = 'Officer';
        cRoleList.add(ccRoleThree);
         
        CreateActionItem_Obj ci = new CreateActionItem_Obj();
        ci.sceneList = sceneList; 
        
        system.runAs(u4){
        	ci.saveData();
        }
        
         
        CreateActionItem_Obj.ContactWrapper aa = new CreateActionItem_Obj.ContactWrapper();
        ci.addComplainant();
        ci.addSubject();
        Apexpages.currentPage().getParameters().put('index', '1');
        Apexpages.currentPage().getParameters().put('type', '');
        ci.searchContact(); 
        ci.addNewLocation(); 
    }
    static testMethod void testIncidentFive(){
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u4 = new User();
        u4.Username='bakul@gmail.com';
        u4.email = 'dileep.kumar@aspiresoftwareconsultancy.com';
        u4.lastname = 'tester';
        u4.firstname = 'u4user';
        u4.emailencodingkey='UTF-8';
        u4.alias = 'u4user';
        u4.languagelocalekey='en_US';  
        u4.localesidkey='en_US';
        u4.timezonesidkey='America/Los_Angeles';
        u4.profileid = pf.Id;
        u4.isactive = True;
        insert u4;
        
        Action_Item__c c = new Action_Item__c();
        c.Complaint_Summary__c = 'hello';
        c.Case_Origin__c = 'Social Media'; 
        c.Date_Received__c = System.today();
        insert c;
		
        List<Action_Item_Scene_Location__c>  sceneList = new List<Action_Item_Scene_Location__c> ();
        Action_Item_Scene_Location__c scene = new  Action_Item_Scene_Location__c();
        scene.Action_Item__c = c.Id;
        scene.Name = 'SceneOne';
        scene.Address_Line_1__c = 'Btm';
        scene.City__c = 'Bangalore';
        scene.State__c = 'NY';
        scene.Zipcode__c = '123456';
        scene.County__c = 'India';
        scene.Description__c = 'Welcome';
        scene.Primary_Incident_Location__c =true;
        sceneList.add(scene);
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = 'Dileep';
        con.LastName = 'Kumar';
        con.MailingStreet = 'Btm';
        con.MailingCity = 'Bangalore';
        con.MailingState = 'NY'; 
        con.County__c = 'India';
        con.Contact_Type__c = 'Abc';
        conList.add(con);
        
        Contact conOne = new Contact();
        conOne.FirstName = 'Manohar';
        conOne.LastName = 'Kumar';
        conOne.MailingStreet = 'Btm';
        conOne.MailingCity = 'Bangalore';
        conOne.MailingState = 'NY'; 
        conOne.County__c = 'India';
        conOne.Contact_Type__c = 'Abc';
        conList.add(conOne);
        
        List<Action_Item_Role__c> cRoleList = new List<Action_Item_Role__c>(); 
        Action_Item_Role__c  ccRole = new Action_Item_Role__c ();
        ccRole.Action_Item__c = c.Id;
        ccRole.Role__c = 'Officer';
        cRoleList.add(ccRole);
        Action_Item_Role__c  ccRoleThree = new Action_Item_Role__c ();
        ccRoleThree.Action_Item__c = c.Id;
        ccRoleThree.Role__c = 'Officer';
        cRoleList.add(ccRoleThree);
         
        CreateActionItem_Obj ci = new CreateActionItem_Obj();
        ci.sceneList = sceneList; 
        
        system.runAs(u4){
        	ci.saveData();
        }
        
         
        CreateActionItem_Obj.ContactWrapper aa = new CreateActionItem_Obj.ContactWrapper();
        ci.addComplainant();
        ci.addSubject();
        Apexpages.currentPage().getParameters().put('index', '1');
        Apexpages.currentPage().getParameters().put('type', '');
        ci.searchContact(); 
        ci.addNewLocation(); 
    }
    static testMethod void testIncidentSix(){
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u4 = new User();
        u4.Username='bakul@gmail.com';
        u4.email = 'dileep.kumar@aspiresoftwareconsultancy.com';
        u4.lastname = 'tester';
        u4.firstname = 'u4user';
        u4.emailencodingkey='UTF-8';
        u4.alias = 'u4user';
        u4.languagelocalekey='en_US';  
        u4.localesidkey='en_US';
        u4.timezonesidkey='America/Los_Angeles';
        u4.profileid = pf.Id;
        u4.isactive = True;
        insert u4;
        
        Action_Item__c c = new Action_Item__c();
        c.Complaint_Summary__c = 'hello';
        c.Case_Origin__c = 'Social Media';
        c.Date_Received__c = System.today();
        insert c;
        
        List<Action_Item_Scene_Location__c>  sceneList = new List<Action_Item_Scene_Location__c> ();
        Action_Item_Scene_Location__c scene = new  Action_Item_Scene_Location__c();
        scene.Action_Item__c = c.Id;
        scene.Name = 'SceneOne';
        scene.Address_Line_1__c = 'Btm';
        scene.City__c = 'Bangalore';
        scene.State__c = 'NY';
        scene.Zipcode__c = '123456';
        scene.County__c = 'India';
        scene.Description__c = 'Welcome';
        scene.Primary_Incident_Location__c =true;
        sceneList.add(scene);
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = 'Dileep';
        con.LastName = 'Kumar';
        con.MailingStreet = 'Btm';
        con.MailingCity = 'Bangalore';
        con.MailingState = 'NY'; 
        con.County__c = 'India';
        con.Contact_Type__c = 'Abc';
        conList.add(con);
        
        Contact conOne = new Contact();
        conOne.FirstName = 'Manohar';
        conOne.LastName = 'Kumar';
        conOne.MailingStreet = 'Btm';
        conOne.MailingCity = 'Bangalore';
        conOne.MailingState = 'NY'; 
        conOne.County__c = 'India';
        conOne.Contact_Type__c = 'Abc';
        conList.add(conOne);
        insert conList;
         
        CreateActionItem_Obj ci = new CreateActionItem_Obj();
        ci.sceneList = sceneList; 
        
        ci.complainants[0].conSearchText = 'Kumar';
        Apexpages.currentPage().getParameters().put('index', '1');
        Apexpages.currentPage().getParameters().put('type', 'complainant');
        ci.searchContact();
        ci.complainants[0].selectedConId = ci.complainants[0].searchResults[0].getValue();
        ci.complainants[0].useOrAddContact = 'Use';
        ci.complainants[0].ccRole.Role__c = 'Alternative Contact/Relative';
        
        ci.subjects[0].conSearchText = 'Kumar';
        Apexpages.currentPage().getParameters().put('index', '1');
        Apexpages.currentPage().getParameters().put('type', 'subject');
        ci.searchContact(); 
        ci.subjects[0].con = new Contact(LastName='sdfds', FirstName = 'sfdsf', Email = 'sadrr@kdfj.com', MailingCountry = 'United States', MailingCity = 'sdfd',MailingState = 'NY', County__c = 'dfd',Contact_Type__c = 'Complainant');
        ci.subjects[0].useOrAddContact = 'Add';
        ci.subjects[0].ccRole.Role__c = 'Alternative Contact/Relative';
        
        ci.saveData(); 
    }
}