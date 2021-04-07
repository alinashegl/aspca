/**
 * Created by barne on 4/6/2021.
 */

public with sharing class KennelSignageController {

    private ApexPages.StandardController controller;
    public List<Animal__c> animals { get; set; }
    public Animal__c animal { get; set; }
    public List<String> selectedBehaviorConcern { get; set; }
    public List<SelectOption> behaviorOptions { get; set; }
    public String allBehaviorConcerns { get; set; }
    public  String behaviorConcern { get; set; }
    private dao_Animal daoAnimal;

    public KennelSignageController()
    {
        Id recordId = Apexpages.currentPage().getParameters().get('id');

        if (String.isNotBlank(recordId))
        {
            animals = daoAnimal.getByIds((Set<Id>) recordId);

        }
    }

    public List<SelectOption> getBehaviorOptions() {
        Schema.DescribeFieldResult fieldresult = animal.Behavior_Concern__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldresult.getPicklistValues();

    }

}