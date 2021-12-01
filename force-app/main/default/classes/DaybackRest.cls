@RestResource(urlMapping='/resources/*')
global with sharing class DaybackRest {
    public static Set<String> folderNames = new Set<String>();

    @HttpGet
    global static DaybackResponse getResources() {
            DaybackResponse resp = new DaybackResponse();
            resp.resources = new ResourceInfo[0];
            resp.resources.addAll(getContactList());
            resp.resources.addAll(getAnimalList());
            resp.resources.addAll(getLocationList());
            resp.folders = new String[folderNames];
            
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
        for(Animal__c animal :[SELECT Id, Animal_Name_Id__c, Shelter_Location2__c FROM Animal__c WHERE Type_of_Animal__c = 'Dog' AND Shelter_Location2__c = 'MRC']){
            ResourceInfo res = new ResourceInfo();
            res.type = animal.Shelter_Location2__c;
            res.resourceName = animal.Animal_Name_Id__c;
            res.folderName = animal.Shelter_Location2__c;
            res.resource = animal;

            folderNames.add(animal.Shelter_Location2__c);

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

    global class DaybackResponse{
        public ResourceInfo[] resources;
        public String[] folders;
    }

    global class ResourceInfo{
        public String type;
        public String resourceName;
        public String folderName;
        public SObject resource;
    }
}
