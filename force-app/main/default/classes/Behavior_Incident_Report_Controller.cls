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
                    , Was_defensive_handling_used__c
                    , Would_dog_have_bitten_w_o_this_handling__c
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
                    , Supervisor_Team_Lead__c
        FROM Incidents__c
        WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];

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

        //need to find the middle index number, column 1 will show the 0-splitIndex and column 2 will show anything after splitIndex
        Decimal listCount = (Decimal)  entries.size();
        Integer splitIndex = (Integer) listCount.divide(2, 1).round(System.RoundingMode.UP);

        for(integer i = 0; i < splitIndex; i++){
            PicklistEntry entry = entries[i];

            String label = entry.label;
            Option opt = new Option();
            opt.label = label;
            opt.selected = (!values.isEmpty() && values.contains(label)) ? true : false;

            Integer secondColumnIndex = i + splitIndex;

            //to get these in the second column, we add them to the Option object here
            if(i + splitIndex < listCount){
                PicklistEntry secondEntry = entries[secondColumnIndex];
                String secondLabel = secondEntry.label;
                opt.secondLabel = secondLabel;
                opt.secondSelected = (!values.isEmpty() && values.contains(secondLabel)) ? true : false;
            }

            behaviorsExhibited.add(opt);
        }

        return behaviorsExhibited;
    }
    
    public List<SelectOption> getTypeBitePicklist {
        get {
            List<SelectOption> options = new List<SelectOption>();
            for( Schema.PicklistEntry obj : Incidents__c.Type_of_Bite__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(obj.getValue(), obj.getLabel()));
            } 
            return options;
        }  
        set;
    }

    Option[] typeBite { get; set; }
    public Option[] gettypeBite(){
        typeBite = new Option[0];
        String objectAPI = 'Incidents__c';
        String fieldAPI = 'Type_of_Bite__c';
        String name = String.valueOf(Schema.getGlobalDescribe().get(objectAPI).getDescribe().fields.getMap().get(fieldAPI).getDescribe().getLabel());
        Schema.SObjectField fieldInfo = SchemaHelper.DetermineSObjectFieldByLabel(objectAPI, name);  

        String[] picklistValues = SchemaHelper.GetPicklistValues(fieldInfo);

        DescribeFieldResult fieldResult = Incidents__c.Type_of_Bite__c.getDescribe();
        PicklistEntry[] entries = fieldResult.getPicklistValues();


        String value = '';
        if(!String.isEmpty(incident.Type_of_Bite__c)) {
            value = incident.Type_of_Bite__c;
        }
        String[] values = (String[]) value.split(';');

        for (PicklistEntry entry : entries) {
            String label = entry.label;

            Boolean isSelected = (!values.isEmpty() && values.contains(label)) ? true : false;
            Option opt = new Option();
            opt.label = label;
            opt.selected = isSelected;
            typeBite.add(opt);
        }

        return typeBite;
    }
    public List<SelectOption> getClothingPicklist {
        get {
            List<SelectOption> options = new List<SelectOption>();
            for( Schema.PicklistEntry obj : Incidents__c.Was_Bitten_Area_Covered_with_Clothing__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(obj.getValue(), obj.getLabel()));
            } 
            return options;
        }  
        set;
    }

    Option[] Clothing { get; set; }
    public Option[] getClothing(){
        Clothing = new Option[0];
        String objectAPI = 'Incidents__c';
        String fieldAPI = 'Was_Bitten_Area_Covered_with_Clothing__c';
        String name = String.valueOf(Schema.getGlobalDescribe().get(objectAPI).getDescribe().fields.getMap().get(fieldAPI).getDescribe().getLabel());
        Schema.SObjectField fieldInfo = SchemaHelper.DetermineSObjectFieldByLabel(objectAPI, name);  

        String[] picklistValues = SchemaHelper.GetPicklistValues(fieldInfo);

        DescribeFieldResult fieldResult = Incidents__c.Was_Bitten_Area_Covered_with_Clothing__c.getDescribe();
        PicklistEntry[] entries = fieldResult.getPicklistValues();


        String value = '';
        if(!String.isEmpty(incident.Was_Bitten_Area_Covered_with_Clothing__c)) {
            value = incident.Was_Bitten_Area_Covered_with_Clothing__c;
        }
        String[] values = (String[]) value.split(';');

        for (PicklistEntry entry : entries) {
            String label = entry.label;

            Boolean isSelected = (!values.isEmpty() && values.contains(label)) ? true : false;
            Option opt = new Option();
            opt.label = label;
            opt.selected = isSelected;
            Clothing.add(opt);
        }

        return Clothing;
    }
    public List<SelectOption> getDamagePicklist {
        get {
            List<SelectOption> options = new List<SelectOption>();
            for( Schema.PicklistEntry obj : Incidents__c.Damage_Done_by_the_Dog__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(obj.getValue(), obj.getLabel()));
            } 
            return options;
        }  
        set;
    }

    Option[] Damage { get; set; }
    public Option[] getDamage(){
        Damage = new Option[0];
        String objectAPI = 'Incidents__c';
        String fieldAPI = 'Damage_Done_by_the_Dog__c';
        String name = String.valueOf(Schema.getGlobalDescribe().get(objectAPI).getDescribe().fields.getMap().get(fieldAPI).getDescribe().getLabel());
        Schema.SObjectField fieldInfo = SchemaHelper.DetermineSObjectFieldByLabel(objectAPI, name);  

        String[] picklistValues = SchemaHelper.GetPicklistValues(fieldInfo);

        DescribeFieldResult fieldResult = Incidents__c.Damage_Done_by_the_Dog__c.getDescribe();
        PicklistEntry[] entries = fieldResult.getPicklistValues();


        String value = '';
        if(!String.isEmpty(incident.Damage_Done_by_the_Dog__c)) {
            value = incident.Damage_Done_by_the_Dog__c;
        }
        String[] values = (String[]) value.split(';');

        //need to find the middle index number, column 1 will show the 0-splitIndex and column 2 will show anything after splitIndex
        Decimal listCount = (Decimal)  entries.size();
        Integer splitIndex = (Integer) listCount.divide(2, 1).round(System.RoundingMode.UP);

        for(integer i = 0; i < splitIndex; i++){
            PicklistEntry entry = entries[i];

            String label = entry.label;
            Option opt = new Option();
            opt.label = label;
            opt.selected = (!values.isEmpty() && values.contains(label)) ? true : false;

            Integer secondColumnIndex = i + splitIndex;

            //to get these in the second column, we add them to the Option object here
            if(i + splitIndex < listCount){
                PicklistEntry secondEntry = entries[secondColumnIndex];
                String secondLabel = secondEntry.label;
                opt.secondLabel = secondLabel;
                opt.secondSelected = (!values.isEmpty() && values.contains(secondLabel)) ? true : false;
            }

            Damage.add(opt);
        }

        return Damage;
    }
    Option[] Handling { get; set; }
    public Option[] getHandling(){
        Handling = new Option[0];
        String objectAPI = 'Incidents__c';
        String fieldAPI = 'Was_defensive_handling_used__c';
        String name = String.valueOf(Schema.getGlobalDescribe().get(objectAPI).getDescribe().fields.getMap().get(fieldAPI).getDescribe().getLabel());
        Schema.SObjectField fieldInfo = SchemaHelper.DetermineSObjectFieldByLabel(objectAPI, name);  

        String[] picklistValues = SchemaHelper.GetPicklistValues(fieldInfo);

        DescribeFieldResult fieldResult = Incidents__c.Was_defensive_handling_used__c.getDescribe();
        PicklistEntry[] entries = fieldResult.getPicklistValues();


        String value = '';
        if(!String.isEmpty(incident.Was_defensive_handling_used__c)) {
            value = incident.Was_defensive_handling_used__c;
        }
        String[] values = (String[]) value.split(';');

        for (PicklistEntry entry : entries) {
            String label = entry.label;

            Boolean isSelected = (!values.isEmpty() && values.contains(label)) ? true : false;
            Option opt = new Option();
            opt.label = label;
            opt.selected = isSelected;
            Handling.add(opt);
        }

        return Handling;
    }

    Option[] Defensive { get; set; }
    public Option[] getDefensive(){
        Defensive = new Option[0];
        String objectAPI = 'Incidents__c';
        String fieldAPI = 'Would_dog_have_bitten_w_o_this_handling__c';
        String name = String.valueOf(Schema.getGlobalDescribe().get(objectAPI).getDescribe().fields.getMap().get(fieldAPI).getDescribe().getLabel());
        Schema.SObjectField fieldInfo = SchemaHelper.DetermineSObjectFieldByLabel(objectAPI, name);  

        String[] picklistValues = SchemaHelper.GetPicklistValues(fieldInfo);

        DescribeFieldResult fieldResult = Incidents__c.Would_dog_have_bitten_w_o_this_handling__c.getDescribe();
        PicklistEntry[] entries = fieldResult.getPicklistValues();


        String value = '';
        if(!String.isEmpty(incident.Would_dog_have_bitten_w_o_this_handling__c)) {

        }
        String[] values = (String[]) value.split(';');

        for (PicklistEntry entry : entries) {
            String label = entry.label;

            Boolean isSelected = (!values.isEmpty() && values.contains(label)) ? true : false;
            Option opt = new Option();
            opt.label = label;
            opt.selected = isSelected;
            Defensive.add(opt);
        }

        return Defensive;
    }

    public class Option{
        public String label {get;set;}
        public Boolean selected {get;set;}
        public String secondLabel {get;set;}
        public Boolean secondSelected {get;set;}
     }
}