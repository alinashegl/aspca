
Case c = new Case(
    Investigator__c = 'Kyle Held',
    Case_Type__c = 'Neglect',
    Case_Subtype__c = 'Inadequate Nutrition',
    Category__c = 'Investigations - Consultation',
    Description = 'Test Summary',
    Date_of_Complaint__c = date.today()
);
insert c;

String[] animalNames = new String[]{'Santa\'s Little Helper', 'Willow', 'Mika', 'AJ', 'Poncho', 'Eddie'};
Animal__c[] newAnimals = new Animal__c[0];
Id recordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Animal__c' AND DeveloperName = 'Behavior' LIMIT 1].Id;

for(integer i = 0; i < animalNames.size(); i++){
    Animal__c animal = new Animal__c(
        Name = animalNames[i],
        Animal_Name__c = animalNames[i],
        Gender__c = 'Unknown',
        Potential_Helper_Dog__c = true,
        Type_of_Animal__c = 'Dog',
        Case__c = c.Id,
        RecordTypeId = recordTypeId
    );
    newAnimals.add(animal);    
}
insert newAnimals;

String[] firstNames = new String[]{'Pam','Dwight', 'Michael', 'Jim', 'Kevin', 'Angela', 'Stanley', 'Darryl', 'Oscar'};
String[] lastNames = new String[]{'Beesly', 'Schrute', 'Scott', 'Halpert', 'Malone', 'Martin', 'Hudson', 'Philbin', 'Martinez'};
Contact[] newCons = new Contact[0];
for(integer i = 0; i < firstNames.size(); i++){
    Contact con = new Contact(
        FirstName = firstNames[i],
        LastName = lastNames[i],
        Email = firstNames[i] + lastNames[i] + '@invalidemail.com',
        External_Id__c = firstNames[i] + lastNames[i]
    );
    newCons.add(con);
}
insert newCons;