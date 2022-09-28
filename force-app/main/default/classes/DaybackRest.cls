@RestResource(urlMapping='/resources/*')
global with sharing class DaybackRest {
    public static Set<String> folderNames = new Set<String>();
    public static String sfObject;
    public static String[] locationGroup = BehaviorUtil.locationGroup;
    public static String userLocation = BehaviorUtil.userLocation;

    @HttpGet
    global static DaybackResponse getResources() {
        RestRequest restReq = RestContext.request;
        /*
         * The sfObject comes from Dayback, if the value id 'default' we are on the default Dayback tab and not a specific object
         * if the object is 'Animal__c' (currently the only other one that is set up) then we make sure the only resource selected
         * by default is the current animal
        */
        sfObject = restReq.params.get('sfObject');
        

        DaybackResponse resp = new DaybackResponse();

        if(locationgroup != null){
            /* 
             * The generic resources are generic contacts created for each of the population groups.  We assign tasks to the
             * generic contacts when a Behavior Case Worker has not yet been assigned to the dog
            */
            resp.genResources = prepGenericResources();
            resp.resources = prepContactResources();
            resp.resources.addAll(getAnimalList());
            resp.folders = new String[folderNames];
            resp.folderInfos = prepFolderInfos();
            resp.sfObject = sfObject;
        }
        return resp;
    }

    @testVisible
    private static GenericResource[] prepGenericResources(){
        GenericResource[] genResources = new GenericResource[0];
        if(userLocation == 'All'){
            genResources.add(mrcGenericResource());
            genResources.add(crcGenericResource());
            genResources.add(arcCareGenericResource());
        }
        else if(userLocation == 'ARC/CARE'){
            genResources.add(arcCareGenericResource());
        }
        else {
            genResources.add(mrcGenericResource());
            genResources.add(crcGenericResource());
        }

        return genResources;
    }

    public static ResourceInfo[] prepContactResources(){
        ResourceInfo[] infos = new ResourceInfo[0];
        Set<Id> managerIds = new Set<Id>();
        Id currentUserId = UserInfo.getUserId();
        Contact[] contactList = queryContacts();
        //first loop through the contacts to pull out any contacts that have direct reports
        //ARC/CARE doesn't want to have their resources broken out so we skip this part for them
        if(userLocation != 'ARC/CARE'){
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
        }

        //loop through the contacts again to create the direct reports for current user and the rest as Behavior Case Workers
        for(Contact con : contactList){
            if(con.ReportsTo.User__c == currentUserId && userLocation != 'ARC/CARE'){
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
            AND Is_Generic_Contact__c = false
            AND Contact_Type__c = 'Behavior Case Worker'
            AND User_Location__c IN: locationGroup
            ORDER BY LastName, FirstName
        ];
    }

    @testVisible
    private static ResourceInfo[] getAnimalList(){
        ResourceInfo[] animalResources = new ResourceInfo[0];
        for(Animal__c animal :[
                SELECT Id, Animal_Name_Id__c, Current_Location__c, Current_Recent_Shelter_Location__c 
                FROM Animal__c 
                WHERE Type_of_Animal__c = 'Dog' 
                AND Current_Recent_Shelter_Location__c IN :locationgroup
                AND Active_Animal__c = true
                ORDER BY Current_Recent_Shelter_Location__c, Animal_Name_Id__c
        ]){
            ResourceInfo res = new ResourceInfo();
            res.type = animal.Current_Recent_Shelter_Location__c;
            res.resourceName = animal.Animal_Name_Id__c;
            res.folderName = animal.Current_Recent_Shelter_Location__c;

            folderNames.add(animal.Current_Recent_Shelter_Location__c);

            animalResources.add(res);
        }

        return animalResources;
    }

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

    private static GenericResource arcCareGenericResource(){
        GenericResource resource = new GenericResource();
        resource.id = 'ARC CARE BehaviorMgmt';
        resource.name = 'ARC CARE BehaviorMgmt';
        resource.nameSafe = 'ac';
        resource.shortName = 'a/c';
        resource.statusSelected = 'default';

        return resource;
    }

    private static GenericResource crcGenericResource(){
        GenericResource resource = new GenericResource();
        resource.id = 'CRC BehaviorMgmt';
        resource.name = 'CRC BehaviorMgmt';
        resource.nameSafe = 'crc';
        resource.shortName = 'crc';
        resource.statusSelected = 'default';

        return resource;
    }

    private static GenericResource mrcGenericResource(){
        GenericResource resource = new GenericResource();
        resource.id = 'MRC BehaviorMgmt';
        resource.name = 'MRC BehaviorMgmt';
        resource.nameSafe = 'mrc';
        resource.shortName = 'mrc';
        resource.statusSelected = 'default';

        return resource;
    }

    global class DaybackResponse{
        public ResourceInfo[] resources;
        public folderInfo[] folderInfos;
        public String[] folders;
        public String sfObject;
        public GenericResource[] genResources;
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

    global class GenericResource{
        public String id;
        public String name;
        public String nameSafe;
        public String shortName;
        public String statusSelected;
    }
}