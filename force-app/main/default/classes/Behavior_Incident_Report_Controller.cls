public class Behavior_Incident_Report_Controller {

    public Incidents__c incident {get;set;}
    public Incidents__c MultiselectPicklist {get;set;}
    public Animal__c anim {get;set;}
    public Contact contact {get;set;}
    
    public Behavior_Incident_Report_Controller(ApexPages.StandardController controller){
        
        incident = [SELECT Id
                    , Additional_Comments__c
                    , Animal__c
                    , Behaviors_Exhibited_by_the_Dog__c
                    , Clothing_Worn_at_Bite_Site__c
                    , Damage_Done_by_the_Dog__c
                    , If_dog_did_not_bite__c
                    , Incident_Date_Time__c
                    , Incident_Description__c
                    , Name
                    , Number_of_bites__c
                    , Other_Damage_Done_by_the_Dog__c
                    , Person_Involved__c
                    , Please_explain_why_you_think_so__c
                    , Report_Date__c
                    , Specific_Target_of_Dog_s_Behavior__c
                    , Type_of_Bite__c
                    , Was_Bitten_Area_Covered_with_Clothing__c
                    , Witnesses__c
                    , Animal__r.Name
                    , Animal__r.Animal_Name__c
        FROM Incidents__c
        WHERE Name = '2022/01/20-0'];

        MultiselectPicklist = (Incidents__c)controller.getRecord();
    }
    public List<SelectOption> getPicklistValue {
        get {
            List<SelectOption> options = new List<SelectOption>();
            for( Schema.PicklistEntry obj : Incidents__c.Behaviors_Exhibited_by_the_Dog__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(obj.getValue(), obj.getLabel()));
            } 
            return options;
        }  
        set;
    }

    // public String[] getPicklistValue {
    //     get {
    //         String[] options = new String[0];
    //         for( Schema.PicklistEntry obj : Incidents__c.Behaviors_Exhibited_by_the_Dog__c.getDescribe().getPicklistValues()) {
    //             options.add(obj.getLabel());
    //         } 
    //         return options;
    //     }  
    //     set;
    // }    

    // public String[] Items { 
    //     get {
    //         List<String> selected = new List<String>();
    //         List<SelectOption> options = this.getPicklistValue;
    //         for(SelectOption obj : options) {
    //             if (this.incident.Behaviors_Exhibited_by_the_Dog__c !=null && this.incident.Behaviors_Exhibited_by_the_Dog__c.contains(obj.getValue()))
    //                 selected.add(obj.getValue());
    //         }
    //         return selected;
    //     }public set {
    //         String selectedCheckBox = '';
    //         for(String s : value) {
    //             if (selectedCheckBox == '') 
    //                 selectedCheckBox += s;
    //             else selectedCheckBox += ';' + s;
    //         }
    //         incident.Behaviors_Exhibited_by_the_Dog__c = selectedCheckBox;
    //     }
    // } 

    Option[] behaviorsExhibited { get; set; }
    public Option[] getbehaviorsExhibited(){
        behaviorsExhibited = new Option[0];
        String objectAPI = 'Incidents__c';
        String fieldAPI = 'Behaviors_Exhibited_by_the_Dog__c';
        String name = String.valueOf(Schema.getGlobalDescribe().get(objectAPI).getDescribe().fields.getMap().get(fieldAPI).getDescribe().getLabel());
        Schema.SObjectField fieldInfo = SchemaHelper.DetermineSObjectFieldByLabel(objectAPI, name);  

        String[] picklistValues = SchemaHelper.GetPicklistValues(fieldInfo);

        DescribeFieldResult fieldResult = Incidents__c.Behaviors_Exhibited_by_the_Dog__c.getDescribe();
        PicklistEntry[] entries = fieldResult.getPicklistValues();


        String value = '';
        if(!String.isEmpty(incident.Behaviors_Exhibited_by_the_Dog__c)) {
            value = incident.Behaviors_Exhibited_by_the_Dog__c;
        }
        String[] values = (String[]) value.split(';');

        for (PicklistEntry entry : entries) {
            String label = entry.label;

            Boolean isSelected = (!values.isEmpty() && values.contains(label)) ? true : false;
            Option opt = new Option();
            opt.label = label;
            opt.selected = isSelected;
            behaviorsExhibited.add(opt);
        }

        return behaviorsExhibited;
    }

    public class Option{
        public String label {get;set;}
        public Boolean selected {get;set;}
     }
}