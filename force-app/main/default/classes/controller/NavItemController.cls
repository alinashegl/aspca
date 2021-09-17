/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public with sharing class NavItemController {

    @AuraEnabled(Cacheable=true)
    public static String getUrl(String recordId) {

        String newLabel = Label.Instance_URL;

        String url = newLabel + '/' + recordId;
        return url;
    }
}