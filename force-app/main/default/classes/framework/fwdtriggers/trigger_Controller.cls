public with sharing class trigger_Controller 
{
    private static trigger_Controller instance;
    private Map<String, trigger_Domain> domains = new Map<String, trigger_Domain>();

    private trigger_Controller() 
    {

    }

    public static trigger_Controller getInstance()
    {
        if (instance == null)
        {
            instance = new trigger_Controller();
        }

        return instance;
    }

    public void process(Schema.SObjectType sObjType)
    {
        String sobjName = sObjType.getDescribe().getName();
        
        addDomain(sobjName);

        trigger_Domain domain = domains.get(sobjName);

        if (domain != null)
        {
            if (Trigger.isBefore && Trigger.isInsert)
            {
                domain.beforeInsert(Trigger.new);
                domain.beforeInsert(Trigger.newMap);
            }
            else if (Trigger.isBefore && Trigger.isUpdate)
            {
                domain.beforeUpdate(Trigger.new, Trigger.old);
                domain.beforeUpdate(Trigger.newMap, Trigger.oldMap);
            }
            else if (Trigger.isBefore && Trigger.isDelete)
            {
                domain.beforeDelete(Trigger.new);
                domain.beforeDelete(Trigger.newMap);
            }
            else if (Trigger.isAfter && Trigger.isInsert)
            {
                domain.afterInsert(Trigger.new);
                domain.afterInsert(Trigger.newMap);
            }
            else if (Trigger.isAfter && Trigger.isUpdate)
            {
                domain.afterUpdate(Trigger.new, Trigger.old);
                domain.afterUpdate(Trigger.newMap, Trigger.oldMap);
            }
            else if (Trigger.isAfter && Trigger.isDelete)
            {
                domain.afterDelete(Trigger.new);
                domain.afterDelete(Trigger.newMap);
            }
        }
        else
        {
            System.debug('### Domain Class does not exist for ' + sobjName);
        }       
    }

    private void addDomain(String sobjName)
    {
        if (!domains.containsKey(sobjName))
        {
            String domainName = getDomainName(sobjName);

            try
            {
                domains.put(sobjName, (trigger_Domain) Type.forName(domainName).newInstance());
                
            }
            catch (Exception ex)
            {
                System.debug('### Domain Class ' + domainName + ' does not exist or could not be instantiated for ' + sobjName + '. Exception: ' + ex.getMessage());
            }
        }
    }

    private String getDomainName(String sobjName)
    {
        String domainName = sobjName;
        domainName = domainName.replace('__c', '');
        domainName = domainName.replace('_', '');
        return 'trigger_' + domainName;
    }
}