@isTest
public class Behavior_Incident_Report_ControllerTest {

    @testSetup
    static void setupData(){
        Animal__c anm = TestDataFactory.createAnimal();
        
        Incidents__c inc = new Incidents__c(
            Additional_Comments__c = 'Test'
            , Animal__c = anm.id
            , Behaviors_Exhibited_by_the_Dog__c = 'Tugging or climbing the leash'
            , Clothing_Worn_at_Bite_Site__c = 'Test'
            , Damage_Done_by_the_Dog__c = 'Deep scratch or abrasion'
            , Was_defensive_handling_used__c = 'No'
            , Would_dog_have_bitten_w_o_this_handling__c = 'Test'
            , Incident_Date_Time__c = System.now()
            , Incident_Description__c = 'Test'
            , Number_of_bites__c = 2
            , Other_Damage_Done_by_the_Dog__c = 'Test'
            , Person_Involved__c = 'Test'
            , Please_explain_why_you_think_so__c = 'Test'
            , Report_Date__c = system.today()
            , Specific_Target_of_Dog_s_Behavior__c = 'Test'
            , Type_of_Bite__c = 'Single bite'
            , Was_Bitten_Area_Covered_with_Clothing__c  = 'Yes'
            , Witnesses__c = 'Test'
            , Supervisor_Team_Lead__c = 'Test');
        insert inc;
    }
    
    @isTest
    static void testIncident(){
        Incidents__c obj = [Select Id,Animal__c from incidents__c];
        Animal__c anm = [Select Id from Animal__c];
        PageReference pageRef = Page.Behavior_Incident_Report;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(obj.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        Behavior_Incident_Report_Controller br = new Behavior_Incident_Report_Controller(sc);
        List<SelectOption> slo = br.getPicklistValue;
        List<Behavior_Incident_Report_Controller.Option> bo = br.getbehaviorsExhibited();
        List<SelectOption> sl = br.getTypeBitePicklist;
        List<Behavior_Incident_Report_Controller.Option> tb = br.gettypeBite();
        List<SelectOption> cp = br.getClothingPicklist;
        List<Behavior_Incident_Report_Controller.Option> gc = br.getClothing();
        List<SelectOption> dp = br.getDamagePicklist;
        List<Behavior_Incident_Report_Controller.Option> gd = br.getDamage();
        List<Behavior_Incident_Report_Controller.Option> gh = br.getHandling();
        List<Behavior_Incident_Report_Controller.Option> df = br.getDefensive();
        br.contact = null;
        br.anim = anm;
        System.assertNotEquals(obj, null);
        System.assertNotEquals(br.anim, null);
    }
}