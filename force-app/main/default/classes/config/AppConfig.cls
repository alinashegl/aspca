public with sharing class AppConfig {
    public static final String RESOURCE_TYPE_SUFFIC = 'T';

    public static final Map<String, String> STATUS;

    public static final Map<String, String> ERRORS_VALIDATION;

    public static final Map<String, String> ROLES;

    static {
        STATUS = new Map<String, String>();
        STATUS.put('success', 'success');
        STATUS.put('error', 'error');
        STATUS.put('active', 'Activated');

        ERRORS_VALIDATION = new Map<String, String>();
        ERRORS_VALIDATION.put('id', 'Invalid record Id');

        ROLES = new Map<String, String>();
        ROLES.put('manager', 'manager');
    }

    public static String getUserUrl(String id) {
        return '/lightning/r/User/' + id + '/view';
    }

    public static String getAccountUrl(String id) {
        return '/lightning/r/Account/' + id + '/view';
    }

}