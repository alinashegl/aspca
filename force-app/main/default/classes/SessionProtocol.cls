public with sharing class SessionProtocol {
    public Session_Protocol__c sProto {get; set;}
    public ProtocolScore aggressiveWorst {get; set;}
    public ProtocolScore arousalBest {get; set;}
    public ProtocolScore arousalWorst {get; set;}
    public ProtocolScore fearBest {get; set;}
    public ProtocolScore fearWorst {get; set;}
    public ProtocolScore socialBest {get; set;}

    public SessionProtocol(Session_Protocol__c sp){
        this.sProto = sp;
        for(Session_Protocol_Scale__c protoScale : sProto.Session_Protocol_Scales__r){
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
            }                
        }
    }

    public class ProtocolScore{
        public String score {get; set;}
        public Decimal scoreNumber {get; set;}
        
        ProtocolScore(Session_Protocol_Scale__c scale){
            this.score = scale.Protocol_Score__c;
            this.scoreNumber = scale.Protocol_Score_Number__c;

        }
    }
}
