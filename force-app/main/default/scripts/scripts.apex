// Animal_Playgroup__c[] animals = [SELECT Id, Animal__c FROM Animal_Playgroup__c WHERE Playgroup_Session__c =: 'a25010000009g7IAAQ'];
// playgroupSessionLWCController.createNewPlaygroupContacts(new Animal_Playgroup__c[]{animals[1], animals[2]}, '0030100000HPcHcAAL');

Id sessionId =  playgroupSessionLWCController.copyPlaygroupSession(
    'a25010000009g7IAAQ',
    new Id[]{'a070100000MM0z8AAD', 'a070100000MLsAuAAL', 'a070100000MMCjgAAH', 'a070100000MMCjlAAH'}
);
System.debug('sessionId: ' + sessionId);


Session_Protocol__c[] pList = [SELECT 
                    Id, 
                    ProtocolId__r.Name,
                    Aggressive_Worst__c,
                    Arousal_Best__c,
                    Arousal_Worst__c,
                    Fear_Best__c,
                    Fear_Worst__c,
                    IsSkipped__c,
                    Social_Best__c,
                    Overall_Score__c,
                    Needs_Review__c,
                    Protocol_Name__c,
                    Status__c 
                    FROM Session_Protocol__c 
                    WHERE TreatmentSessionId__c = 'a2701000000baMFAAY'];
System.debug('list: ' + pList);


[{
    Id='a2801000000YrN8AAK', 
    IsSkipped__c=false, 
    Needs_Review__c=false, 
    Protocol_Name__c='Kennel Presence'
}, 
{
    Id='a2801000000YrN9AAK', 
    IsSkipped__c=false, 
    Needs_Review__c=false, 
    Protocol_Name__c='Four on Floor for Leash', 
}, 
{
    Id='a2801000000YrNAAA0', 
    IsSkipped__c=false, 
    Needs_Review__c=false, 
    Protocol_Name__c='Arousal-DSCC to Handler Triggers', 
}, 
{
    Id='a2801000000YrNBAA0', 
    Aggressive_Worst__c='4. Air snaps or muzzle punches', 
    Arousal_Best__c='2. Mild', 
    Arousal_Worst__c='2. Mild', 
    Fear_Best__c='4. Extremely fearful',
    Fear_Worst__c='4. Extremely fearful', 
    IsSkipped__c=false, 
    Social_Best__c='3. Solicitation, no proximity', 
    Overall_Score__c='2. Catching On/ Fluency', 
    Needs_Review__c=false, 
    Protocol_Name__c='Basic Training'
}