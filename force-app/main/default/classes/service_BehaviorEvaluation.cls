/**
 * Created by barne on 5/20/2021.
 */

public with sharing  class service_BehaviorEvaluation extends service_Base{
    public override void process(service_Request request, service_Response response) {
        switch on (String) request.Parameters.get('action') {
            when 'beforeUpdate' {
                beforeUpdate(request, response);
            } when 'updatePicklist' {
                updatePicklist(request, response);
            } when 'updateComments' {
                updateComments(request, response);
            } when 'checkValidity' {
                checkValidity(request, response);
            } when 'putBoolean' {
                putBoolean(request, response);
            } when 'updatePick' {
                updatePick(request, response);
            }
        }
    }

    public void beforeUpdate(service_Request request, service_Response response) {
        Map<Id, Behavior_Evaluation__c> oldEvaluations = (Map<Id, Behavior_Evaluation__c>) request.Parameters.get('oldEvaluations');
        Map<Id, Behavior_Evaluation__c> newEvaluations = (Map<Id, Behavior_Evaluation__c>) request.Parameters.get('newEvaluations');
        System.debug('BEFORE UPDATE EVENT IS OCCURING');

    }

    public void updateComments(service_Request request, service_Response response) {
        String recordId = (String) request.Parameters.get('recordId');
        dao_BehaviorEvaluations daoBehaviorEvaluations = new dao_BehaviorEvaluations();
        Behavior_Evaluation__c evaluation = daoBehaviorEvaluations.findOne(recordId);
        String apiName = (String) request.Parameters.get('apiName');
        String values = (String) request.Parameters.get('values');
        Map<String, String> fieldValueMap = new Map<String, String>{
                apiName => values
        };
        Map<String, Schema.SObjectField> behaviorEvalFieldMap = SObjectFieldMapHelper.fieldMap('Behavior_Evaluation__c');
        for (String key : fieldValueMap.keySet()) {
            if (behaviorEvalFieldMap.containsKey(key)) {
                Schema.SObjectField field = behaviorEvalFieldMap.get(key);
                evaluation.put(field, fieldValueMap.get(key));

            }
        }
        List<Behavior_Evaluation__c> behaviorEvaluations = new List<Behavior_Evaluation__c>();
        behaviorEvaluations.add(evaluation);
        update behaviorEvaluations;
        response.Parameters.put('item' , behaviorEvaluations);
    }

    public void updatePicklist(service_Request request, service_Response response) {
        String recordId = (String) request.Parameters.get('recordId');
        dao_BehaviorEvaluations daoBehaviorEvaluations = new dao_BehaviorEvaluations();
        Behavior_Evaluation__c evaluation = daoBehaviorEvaluations.findOne(recordId);
        String message = '';
        String apiName = (String) request.Parameters.get('apiName');
        List<String> values = (List<String>) request.Parameters.get('values');
        Map<String, List<String>> fieldValueMap = new Map<String, List<String>>{
                apiName => values
        };
        Map<String, Schema.SObjectField> behaviorEvalFieldMap = SObjectFieldMapHelper.fieldMap('Behavior_Evaluation__c');

        for (String key : fieldValueMap.keySet()) {
            System.debug('@@## Current Key ===> ' +  key);
            if (behaviorEvalFieldMap.containsKey(key)) {
                Schema.SObjectField field = behaviorEvalFieldMap.get(key);
                if (field.getDescribe().isRestrictedPicklist()) {
                    List<PicklistEntry> entries = field.getDescribe().getPicklistValues();
                    Map<String, Integer> entriesHashMap = new Map<String, Integer>();
                    for (PicklistEntry e : entries) {
                        entriesHashMap.put(e.label, entries.indexOf(e));
                    }
                    List<String> nEntries = new List<String>();
                    List<String> rEntries = new List<String>();
                    Map<String, PicklistEntry> entriesByStrings = SObjectFieldMapHelper.entriesByStrings(field.getDescribe());
                    List<String> mStrings = fieldValueMap.get(key);
                    System.debug('@@@MSTRINGS ====> ' + mStrings);
                    for (String str : mStrings) {
                        System.debug(str);
                        Map<String, Object> objectMap = (Map<String, Object>) JSON.deserializeUntyped(str);
                        String lbl = (String) objectMap.get('label');
                        Integer k = entriesHashMap.get(lbl);
                        PicklistEntry e = entries.get(k);
                        System.debug('@@@@@@ OBJECT MAP' + objectMap);
                        System.debug('@@@ OBJ VAL=====> ' + lbl);
                        if (objectMap.get('isSelected')==true) {
                            nEntries.add(e.label);
                        }else if (objectMap.get('isSelected')==false) {
                            rEntries.add(e.label);
                        }else {
                            System.debug('ERROR OCCURED WITH FIELD' + str);
                        }
                        message = 'FIELD IS EMPTY - UPDATED FIELD';
                    }

                    if (evaluation.get(field) == null) {
                        evaluation.put(field, String.join(nEntries, ';'));
                    }else {
                        System.debug('FIELD NOT EMPTY EXECUTING');
                        message = 'FIELD NOT EMPTY, UPDATED FIELD';
                        List<String> jStrings = evaluation.get(field).toString().split(';');
                        System.debug(jStrings);
                        Set<String> nStrings = new Set<String>();
                        nStrings.addAll(nEntries);
                        nStrings.addAll(jStrings);
                        for (Integer i = 0; i < rEntries.size(); i++) {
                            String str = rEntries[i];
                            if (nStrings.contains(str)) {
                                nStrings.remove(rEntries[i]);
                            }
                        }
                        evaluation.put(field, String.join(new List<String>(nStrings), ';'));

                    }
                }


            }
        }
        List<Behavior_Evaluation__c> behaviorEvaluations = new List<Behavior_Evaluation__c>();
        behaviorEvaluations.add(evaluation);
        update behaviorEvaluations;

        response.Parameters.put('item' , behaviorEvaluations);
        response.Parameters.put('message', message);
    }

    public void checkValidity(service_Request request, service_Response response) {
        dao_BehaviorEvaluations daoBehaviorEvaluations = new dao_BehaviorEvaluations();
        Behavior_Evaluation__c evaluation = daoBehaviorEvaluations.findOne((String) request.Parameters.get('key'));
        Map<String, Object> errorMessages = new Map<String, Object>();
        String err = 'Result:';
        String ref = '#';
        Map<String, Object> messages = new Map<String, Object>();
        List<SObjectField> testFields = getTestFields(evaluation.Evaluation_Subtype__c);
        System.debug(testFields);
        for (SObjectField field : testFields) {
            Map<String, SObjectField> fieldMap = SObjectFieldMapHelper.fieldMap('Behavior_Evaluation__c');
            try {
                System.debug(evaluation.get(field));
                if (MetadataUtil.skipField(String.valueOf(field)) != null) {
                    String skipField = MetadataUtil.skipField(String.valueOf(field));
                    System.debug('###Skip Field ===> ' + skipField );
                    System.debug(evaluation.get(skipField));
                    if(String.valueOf(evaluation.get(field)) == null) {
                        if (String.valueOf(evaluation.get(skipField)) == null) {
                            errorMessages.put(field.getDescribe().label, String.valueOf('No entry Selected for  ' + field
                                    .getDescribe()
                                    .label) +
                                    '-------------> ');
                            err = err + ' No entry Selected for ' + field.getDescribe().label +
                                    '----->';
                        }
                    }
                }

            }catch(Exception ex) {
                response.Parameters.put('item', ex);
                System.debug('Field ' + field + ' returned ===> ' + ex);
            }
        }
        if (!errorMessages.equals(null)) {
            response.Parameters.put('item', err);
        }else {
            response.Parameters.put('item', 'SUCCESS');
        }
        System.debug('###### ERROR MESSAGES === ' + errorMessages.values() );


    }

    public void putBoolean(service_Request request, service_Response response) {
        dao_BehaviorEvaluations daoBehaviorEvaluations = new dao_BehaviorEvaluations();
        Behavior_Evaluation__c eval = daoBehaviorEvaluations.findOne((String) request.Parameters.get('recordId'));
        Map<String, SObjectField> fieldMap = SObjectFieldMapHelper.fieldMap('Behavior_Evaluation__c');
        SObjectField field = fieldMap.get((String) request.Parameters.get('apiName'));
        Boolean val = (Boolean) request.Parameters.get('values');
        System.debug('PUT BOOL SOBJECT FIELD ==> ' + field + '===>' + val);
        eval.put(field, val);
        List<Behavior_Evaluation__c> evaluations = new List<Behavior_Evaluation__c>();
        evaluations.add(eval);
        update evaluations;

        response.Parameters.put('item', val);
    }

    public void updatePick(service_Request request, service_Response response) {
        dao_BehaviorEvaluations daoBehaviorEvaluations = new dao_BehaviorEvaluations();
        Behavior_Evaluation__c eval = daoBehaviorEvaluations.findOne((String) request.Parameters.get('recordId'));
        Map<String, SObjectField> fieldMap = SObjectFieldMapHelper.fieldMap('Behavior_Evaluation__c');
        SObjectField field = fieldMap.get((String) request.Parameters.get('apiName'));
        String val = (String) request.Parameters.get('values');
        eval.put(field, val);
        List<Behavior_Evaluation__c> evaluations = new List<Behavior_Evaluation__c>();
        evaluations.add(eval);
        update evaluations;
        response.Parameters.put('item', evaluations);
    }

    /*
    *   PRIVATE METHODS
     */

    private static List<SObjectField> getTestFields (String type) {
        List<SObjectField> fields = new List<SObjectField>();
        if (type == 'Puppy') {
            fields.add(Behavior_Evaluation__c.Puppy_Behavior_in_Kennel__c);
            fields.add(Behavior_Evaluation__c.Puppy_Behavior_on_Leash__c);
            fields.add(Behavior_Evaluation__c.Puppy_Social_Behavior_P1__c);
            fields.add(Behavior_Evaluation__c.Puppy_Social_Behavior_P2__c);
            fields.add(Behavior_Evaluation__c.Puppy_Play_Tug_P1__c);
            fields.add(Behavior_Evaluation__c.Puppy_Play_Tug_P2__c);
            fields.add(Behavior_Evaluation__c.Puppy_Play_Tag__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Body__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Neck__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Push_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Body__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Neck__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Push_Face__c);
            fields.add(Behavior_Evaluation__c.Puppy_Child_Doll_P1__c);
            fields.add(Behavior_Evaluation__c.Puppy_Child_Doll_P2__c);
            fields.add(Behavior_Evaluation__c.Puppy_Dog_Interaction_P1__c);
            fields.add(Behavior_Evaluation__c.Puppy_Dog_Interaction_P2__c);
            fields.add(Behavior_Evaluation__c.Puppy_Dog_Interaction_P3__c);
        }else if (type == 'Dog Fighting') {
            fields.add(Behavior_Evaluation__c.Behavior_in_Kennel__c);
            fields.add(Behavior_Evaluation__c.Behavior_on_Leash__c);
            fields.add(Behavior_Evaluation__c.Social_Behavior_P1__c);
            fields.add(Behavior_Evaluation__c.Social_Behavior_P2_2__c);
            fields.add(Behavior_Evaluation__c.Pleasant_Touch__c);
            fields.add(Behavior_Evaluation__c.Unpleasant_Touch_1st__c);
            fields.add(Behavior_Evaluation__c.Play_Test_Tug_P1__c);
            fields.add(Behavior_Evaluation__c.Play_Test_Tug_P2__c);
            fields.add(Behavior_Evaluation__c.Tag_Test__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Push_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Neck__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Body__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Push_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Neck__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Body__c);
            fields.add(Behavior_Evaluation__c.Toddler_Doll_P1__c);
            fields.add(Behavior_Evaluation__c.Toddler_Doll_P2__c);
            fields.add(Behavior_Evaluation__c.Scolding_Person_P1__c);
            fields.add(Behavior_Evaluation__c.Scolding_Person_P2__c);
            fields.add(Behavior_Evaluation__c.Fake_Dog__c);
            fields.add(Behavior_Evaluation__c.Same_Sex_P1__c);
            fields.add(Behavior_Evaluation__c.Same_Sex_P2__c);
            fields.add(Behavior_Evaluation__c.Same_Sex_P3__c);
            fields.add(Behavior_Evaluation__c.Opposite_Sex_P1__c);
            fields.add(Behavior_Evaluation__c.Opposite_Sex_P2__c);
            fields.add(Behavior_Evaluation__c.Opposite_Sex_P3__c);
        }else if (type == 'Adult Animal') {
            fields.add(Behavior_Evaluation__c.Behavior_in_Kennel__c);
            fields.add(Behavior_Evaluation__c.Behavior_on_Leash__c);
            fields.add(Behavior_Evaluation__c.Social_Behavior_P1__c);
            fields.add(Behavior_Evaluation__c.Social_Behavior_P2_2__c);
            fields.add(Behavior_Evaluation__c.Pleasant_Touch__c);
            fields.add(Behavior_Evaluation__c.Unpleasant_Touch_1st__c);
            fields.add(Behavior_Evaluation__c.Play_Test_Tug_P1__c);
            fields.add(Behavior_Evaluation__c.Play_Test_Tug_P2__c);
            fields.add(Behavior_Evaluation__c.Tag_Test__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Push_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Neck__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Body__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Push_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Face__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Neck__c);
            fields.add(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Body__c);
            fields.add(Behavior_Evaluation__c.Toddler_Doll_P1__c);
            fields.add(Behavior_Evaluation__c.Toddler_Doll_P2__c);
            fields.add(Behavior_Evaluation__c.Scolding_Person_P1__c);
            fields.add(Behavior_Evaluation__c.Scolding_Person_P2__c);
            fields.add(Behavior_Evaluation__c.Same_Sex_P1__c);
            fields.add(Behavior_Evaluation__c.Same_Sex_P2__c);
            fields.add(Behavior_Evaluation__c.Same_Sex_P3__c);
            fields.add(Behavior_Evaluation__c.Opposite_Sex_P1__c);
            fields.add(Behavior_Evaluation__c.Opposite_Sex_P2__c);
            fields.add(Behavior_Evaluation__c.Opposite_Sex_P3__c);
        }else {
            System.debug('FIELD IS NOT VALID');
        }

        return fields;
    }

}