/**
 * Created by barne on 4/6/2021.
 */

public with sharing class KennelSignageController {

    public List<SelectOption> behaviorOptions { get; set; }
    public Animal__c currentAnimal { get; set; }
    public List<Animal__c> animals { get; set; }
    public List<String> selectedBehaviorConcern {get; set; }


    public KennelSignageController()
    {
        dao_Animal daoAnimal = new dao_Animal();
        PageReference page = new PageReference('/apex/KennelSignage');

        currentAnimal = daoAnimal.findOne(page.getParameters().get('id'));


    }

    public  Blob generatePDF(String recordId)
    {
        PageReference page = new PageReference('/apex/KennelSignage');

        page.getParameters().put('id', recordId);

        return page.getContentAsPDF();
    }

    public List<SelectOption> getBehaviorOptions() {
        Schema.DescribeFieldResult fieldResult = Animal__c.Behavior_Concerns__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry plEntry : pList)
        {
            behaviorOptions.add(new SelectOption(String.valueOf(plEntry.value), String.valueOf(plEntry.label)));
        }

        return behaviorOptions;
    }

}