//Create Bundle Entries
String bundleName = 'Typical Juvenile';
String[] protocols = new String[]{
'Kennel Presence',
'Four on Floor for Leash',
};
Protocol__c[] protos = [SELECT Id, Name FROM Protocol__c WHERE Name IN: protocols];
Map<String, Id> protoMap = new Map<String, Id>();
for(Protocol__c proto : protos){
    protoMap.put(proto.Name, proto.Id);
}
Id bundleId = [SELECT Id FROM Treatment_Bundle__c WHERE Name =: bundleName LIMIT 1].Id;
Bundle_Entry__c[] entries = new Bundle_Entry__c[0];
for(String protocol: protocols){
    Bundle_Entry__c entry = new Bundle_Entry__c(
    	Protocol__c = protoMap.get(protocol),
        Treatment_Bundle__c = bundleId        
    );
    entries.add(entry);
}
insert entries;