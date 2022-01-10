@RestResource(urlMapping='/resources/*')
global with sharing class DaybackRest {
    public static Set<String> folderNames = new Set<String>();
    public static String sfObject;
    public static String[] location{
        get{
            if(location == null){
                String tempLocation = getUserLocation();
                location = (tempLocation == 'ARC/CARE') ? 
                    new String[]{'ARC', 'CARE'} : 
                    new String[]{'CRC', 'MRC'};
            }
            return location;
        }
        set{
            String tempLocation = getUserLocation();
            location = (tempLocation == 'ARC/CARE') ? 
                new String[]{'ARC', 'CARE'} : 
                new String[]{'CRC', 'MRC'};
        }
    }

    @HttpGet
    global static DaybackResponse getResources() {
        RestRequest restReq = RestContext.request;
        sfObject = restReq.params.get('sfObject');
        

        DaybackResponse resp = new DaybackResponse();

        if(location != null){
            resp.resources = prepContactResources();
            resp.resources.addAll(getAnimalList());
            resp.folders = new String[folderNames];
            resp.folderInfos = prepFolderInfos();
            resp.sfObject = sfObject;
        }
        return resp;
    }

    private static String getUserLocation(){
        User u = [SELECT Id, Location__c FROM User WHERE Id =: userInfo.getUserId()];
        return u.Location__c;
    }

    public static ResourceInfo[] prepContactResources(){
        ResourceInfo[] infos = new ResourceInfo[0];
        Set<Id> managerIds = new Set<Id>();
        Id currentUserId = UserInfo.getUserId();
        Contact[] contactList = queryContacts();
        //first loop through the contacts to pull out any contacts that have direct reports
        for(Contact con : contactList){
            if(con.ReportsToId != null && !managerIds.contains(con.ReportsToId)){
                ResourceInfo managerRes = new ResourceInfo();
                managerRes.type = 'Contacts';
                managerRes.resourceName = con.ReportsTo.Name;
                managerRes.folderName = 'Managers';
                folderNames.add('Managers');
                managerIds.add(con.ReportsToId);
                infos.add(managerRes);
            }
        }

        //loop through the contacts again to create the direct reports for current user and the rest as Behavior Case Workers
        for(Contact con : contactList){
            if(con.ReportsTo.User__c == currentUserId){
                ResourceInfo res = new ResourceInfo();
                res.type = 'Contacts';
                res.resourceName = con.Name;
                res.folderName = 'Direct Reports';
                folderNames.add('Direct Reports');
                infos.add(res);
                continue;
            }
            
            if(!managerIds.contains(con.Id)){
                ResourceInfo res = new ResourceInfo();
                res.type = 'Contacts';
                res.resourceName = con.Name;
                res.folderName = con.Contact_Type__c;
                folderNames.add(con.Contact_Type__c);
                infos.add(res);
            }
        }
        return infos;
    }

    private static Contact[] queryContacts(){
        return [
            SELECT Id, Name, ReportsToId, ReportsTo.Name, ReportsTo.User__c, Contact_Type__c, User__c
            FROM Contact 
            WHERE Active__c = true
            AND User__r.Location__c IN: location
            AND Is_Generic_Contact__c = false
            AND Contact_Type__c = 'Behavior Case Worker'
            ORDER BY LastName, FirstName
        ];
    }

    private static ResourceInfo[] getAnimalList(){
        ResourceInfo[] conResources = new ResourceInfo[0];
        for(Animal__c animal :[
                SELECT Id, Animal_Name_Id__c, Current_Location__c, Current_Recent_Shelter_Location__c 
                FROM Animal__c 
                WHERE Type_of_Animal__c = 'Dog' 
                AND Current_Recent_Shelter_Location__c 
                IN :location 
                ORDER BY Current_Recent_Shelter_Location__c, Animal_Name_Id__c
            ]){
            ResourceInfo res = new ResourceInfo();
            res.type = animal.Current_Recent_Shelter_Location__c;
            res.resourceName = animal.Animal_Name_Id__c;
            res.folderName = animal.Current_Recent_Shelter_Location__c;

            folderNames.add(animal.Current_Recent_Shelter_Location__c);

            conResources.add(res);
        }

        return conResources;
    }

    // private static ResourceInfo[] getLocationList(){
    //     ResourceInfo[] conResources = new ResourceInfo[0];

    //     Schema.SObjectField fieldInfo = SchemaHelper.DetermineSObjectFieldByLabel('Playgroup_Session__c', 'Playgroup Location');
    //     for(String value : SchemaHelper.GetPicklistValues(fieldInfo)){
    //         ResourceInfo res = new ResourceInfo();
    //         res.type = 'Location';
    //         res.resourceName = value;
    //         res.folderName = 'Location';

    //         conResources.add(res);
    //     }

    //     folderNames.add('Location');

    //     return conResources;
    // }

    private static folderInfo[] prepFolderInfos(){
        folderInfo[] infos = new folderInfo[0];
        for(String folderName : folderNames){
            folderInfo info = new folderInfo();
            info.name = folderName;
            info.selected = getFolderSelected(folderName);
            infos.add(info);
        }
        return infos;
    }

    private static Boolean getFolderSelected(String name){
        Boolean selected = false;
        if(sfObject == 'default'){
            selected = true;
            if(AutoScheduleTasksUtil.dogPopulations.contains(name)){
                selected = false;
            }
        }
        return selected;
    }

    global class DaybackResponse{
        public ResourceInfo[] resources;
        public folderInfo[] folderInfos;
        public String[] folders;
        public String sfObject;
    }

    global class folderInfo{
        public String name;
        public Boolean selected;
    }

    global class ResourceInfo{
        public String type;
        public String resourceName;
        public String folderName;
        public String shortName;
        public String selected;
    }
}


    // private static Contact[] queryContacts(Id[] reportIds){
        // if(reportIds != null){
        //     return [
        //         SELECT Id, Name, Contact_Type__c,
        //         (SELECT Id FROM ReportsTo)
        //         FROM Contact 
        //         WHERE (
        //                 (Active__c = true AND User__r.Location__c =: location) OR Id IN: reportIds
        //             ) 
        //         ORDER BY LastName, FirstName];
        // }
        // return null;
        // else {
        //     return [
        //         SELECT Id, Name, Contact_Type__c,
        //         (SELECT Id FROM ReportsTo__r)
        //         FROM Contact 
        //         WHERE Active__c = true AND User__r.Location__c =: location
        //         ORDER BY LastName, FirstName
        //     ];
        // }
    // }

    // private static ResourceInfo[] getContactList(){
    //     ResourceInfo[] conResources = new ResourceInfo[0];
    //     Id[] reportIds = getContactReportIds();
        
    //     for(Contact con :queryContacts(reportIds)){

    //         ResourceInfo res = new ResourceInfo();
    //         res.type = 'Contacts';
    //         res.resourceName = con.Name;
    //         res.resource = con;

    //         if(reportIds != null && reportIds.contains(con.Id)){
    //             res.folderName = 'Direct Reports';
    //             folderNames.add('Direct Reports');
    //         }
    //         else {
    //             res.folderName = con.Contact_Type__c;
    //             folderNames.add(con.Contact_Type__c);
    //         }

    //         conResources.add(res);
    //     }

    //     return conResources;
    // }

    // private static Id[] getContactReportIds(){
    //     Set<Id> reportIds = new Set<Id>();
    //     for(Contact con : [SELECT Id FROM Contact WHERE Active__c = true AND User__r.Location__c =: location AND ReportsTo.User__c =: UserInfo.getUserId()]){
    //         reportIds.add(con.Id);
    //     }

    //     return reportIds.isEmpty() ? null : new Id[reportIds];
    // }