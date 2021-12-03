@RestResource(urlMapping='/resources/*')
global with sharing class DaybackRest {
    public static Set<String> folderNames = new Set<String>();

    @HttpGet
    global static DaybackResponse getResources() {
            DaybackResponse resp = new DaybackResponse();
            resp.resources = new ResourceInfo[0];
            resp.resources.addAll(getContactList());
            resp.resources.addAll(getAnimalList());
            resp.folders = new String[folderNames];
            resp.folderInfos = prepFolderInfos();
            
        return resp;
    }

    private static ResourceInfo[] getContactList(){
        ResourceInfo[] conResources = new ResourceInfo[0];
        for(Contact con :[SELECT Id, Name, Contact_Type__c FROM Contact WHERE Title = 'stevenDev']){
            ResourceInfo res = new ResourceInfo();
            res.type = 'Contacts';
            res.resourceName = con.Name;
            res.folderName = con.Contact_Type__c;
            res.resource = con;

            folderNames.add(con.Contact_Type__c);

            conResources.add(res);
        }

        return conResources;
    }

    private static ResourceInfo[] getAnimalList(){
        ResourceInfo[] conResources = new ResourceInfo[0];
        for(Animal__c animal :[SELECT Id, Animal_Name_Id__c, Current_Location__c, Current_Recent_Shelter_Location__c FROM Animal__c WHERE Type_of_Animal__c = 'Dog' AND Current_Recent_Shelter_Location__c IN('MRC', 'CRC')]){
            ResourceInfo res = new ResourceInfo();
            res.type = animal.Current_Recent_Shelter_Location__c;
            res.resourceName = animal.Animal_Name_Id__c;
            res.folderName = animal.Current_Recent_Shelter_Location__c;
            res.resource = animal;

            folderNames.add(animal.Current_Recent_Shelter_Location__c);

            conResources.add(res);
        }

        return conResources;
    }

    private static ResourceInfo[] getLocationList(){
        ResourceInfo[] conResources = new ResourceInfo[0];

        Schema.SObjectField fieldInfo = SchemaHelper.DetermineSObjectFieldByLabel('Playgroup_Session__c', 'Playgroup Location');
        for(String value : SchemaHelper.GetPicklistValues(fieldInfo)){
            ResourceInfo res = new ResourceInfo();
            res.type = 'Location';
            res.resourceName = value;
            res.folderName = 'Location';

            conResources.add(res);
        }

        folderNames.add('Location');

        return conResources;
    }

    private static folderInfo[] prepFolderInfos(){
        folderInfo[] infos = new folderInfo[0];
        for(String folder : folderNames){
            folderInfo info = new folderInfo();
            info.name = folder;
            info.color = getFolderColor(folder);
            info.selected = getFolderSelected(folder);
            infos.add(info);
        }
        return infos;
    }

    private static String getFoldercolor(String name){
        String color = 'rgba(244, 244, 244, 0.85)';
        if(name == 'CRC' || name == 'MRC'){
            color = 'rgba(245, 39, 39, 0.8)';
        }
        return color;
    }

    private static Boolean getFolderSelected(String name){
        Boolean selected = true;
        if(name == 'CRC' || name == 'MRC'){
            selected = false;
        }
        return selected;
    }

    global class DaybackResponse{
        public ResourceInfo[] resources;
        public folderInfo[] folderInfos;
        public String[] folders;
    }

    global class folderInfo{
        public String name;
        public String color;
        public Boolean selected;
    }

    global class ResourceInfo{
        public String type;
        public String resourceName;
        public String folderName;
        public String shortName;
        public SObject resource;
    }
}
