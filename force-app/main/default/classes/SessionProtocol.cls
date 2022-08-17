public with sharing class SessionProtocol {
    @AuraEnabled public Session_Protocol__c sProto {get; set;}
    @AuraEnabled public String sessionDate {get; set;}
    @AuraEnabled public ProtocolScore aggressiveWorst {get; set;}
    @AuraEnabled public ProtocolScore arousalBest {get; set;}
    @AuraEnabled public ProtocolScore arousalWorst {get; set;}
    @AuraEnabled public ProtocolScore fearBest {get; set;}
    @AuraEnabled public ProtocolScore fearWorst {get; set;}
    @AuraEnabled public ProtocolScore socialBest {get; set;}
    @AuraEnabled public ProtocolScore solicitation {get; set;}

    public SessionProtocol(Session_Protocol__c sp){
        this.sProto = sp;
        this.sessionDate = sp.TreatmentSessionId__r.Session_Date__c.format();
        for(Session_Protocol_Scale__c protoScale : sp.Session_Protocol_Scales__r){
            switch on protoScale.Protocol_Scale_Name__c {
                when 'Aggression - Movement' {
                    this.aggressiveWorst = new ProtocolScore(protoScale);
                }	
                when 'Arousal - Best' {
                    this.arousalBest = new ProtocolScore(protoScale);
                }
                when 'Arousal - Worst' {
                    this.arousalWorst = new ProtocolScore(protoScale);
                }
                when 'Fear - Best' {
                    this.fearBest = new ProtocolScore(protoScale);
                }
                when 'Fear - Worst' {
                    this.fearWorst = new ProtocolScore(protoScale);
                }
                when 'Fear - Sociability Best' {
                    this.socialBest = new ProtocolScore(protoScale);
                }
                when 'Solicitation - Non-Fearful Treatment' {
                    this.solicitation = new ProtocolScore(protoScale);
                }
            }                
        }
    }

    public class ProtocolScore{
        @AuraEnabled public String name {get; set;}
        @AuraEnabled public String score {get; set;}
        @AuraEnabled public Decimal scoreNumber {get; set;}
        
        ProtocolScore(Session_Protocol_Scale__c scale){
            this.score = scale.Protocol_Score__c;
            this.scoreNumber = scale.Protocol_Score_Number__c;
            this.name = scale.Protocol_Scale_Name__c;
        }
    }
}