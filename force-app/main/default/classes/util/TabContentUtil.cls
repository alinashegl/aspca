/*
 * Created by barne on 5/5/2021.
 */

public with sharing class TabContentUtil {
    @AuraEnabled public String id { get; set; }
    @AuraEnabled public String label { get; set; }
    @AuraEnabled public String name { get; set; }
    @AuraEnabled public String breed { get; set; }
    @AuraEnabled public String color { get; set; }
    @AuraEnabled public String caseNumber { get; set;}
    @AuraEnabled public String animalId { get; set; }
    @AuraEnabled public String animalAge { get; set; }
    @AuraEnabled public String animalSex { get; set; }
    @AuraEnabled public String location { get; set; }
    @AuraEnabled public Date currentDate { get; set; }
    @AuraEnabled public List<Object> potentialBehaviorIssues { get; set; }
    @AuraEnabled public List<Object> placementRecommendations { get; set; }
    @AuraEnabled public String behaviorSummary { get; set; }
    @AuraEnabled public Boolean IsAdult { get; set; }
    @AuraEnabled public Boolean IsPuppy { get; set; }
    @AuraEnabled public Boolean IsDogFighting { get; set; }
    @AuraEnabled public Boolean UseCaution { get; set; }
    @AuraEnabled public Boolean IsMuzzled { get; set; }
    @AuraEnabled public EvaluationWrapper.FieldContents Caution { get; set; }

    public TabContentUtil(
            String id,
            String label,
            String name,
            String breed,
            String color,
            String caseNumber,
            String animalId,
            String animalAge,
            String animalSex,
            String location,
            Date currentDate,
            List<Object> potentialBehaviorIssues,
            List<Object> placementRecommendations,
            String behaviorSummary,
            Boolean IsAdult,
            Boolean IsPuppy,
            Boolean IsDogFighting,
            Boolean UseCaution,
            Boolean IsMuzzled ,
            EvaluationWrapper.FieldContents Caution
    ) {
        this.id = id;
        this.label = label;
        this.name = name;
        this.breed = breed;
        this.color = color;
        this.caseNumber = caseNumber;
        this.animalId = animalId;
        this.animalAge = animalAge;
        this.animalSex = animalSex;
        this.location = location;
        this.currentDate = currentDate;
        this.potentialBehaviorIssues = potentialBehaviorIssues;
        this.placementRecommendations = placementRecommendations;
        this.behaviorSummary = behaviorSummary;
        this.IsAdult = IsAdult;
        this.IsPuppy = IsPuppy;
        this.IsDogFighting = IsDogFighting;
        this.UseCaution = UseCaution;
        this.IsMuzzled = IsMuzzled;
        this.Caution = Caution;

    }

    public TabContentUtil() {}

}