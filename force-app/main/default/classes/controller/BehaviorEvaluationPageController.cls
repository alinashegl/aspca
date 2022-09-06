/**
 * Class Description
 *
 * @author Lamar Barnett
 * @version 1.0.13
 */

public with sharing class BehaviorEvaluationPageController {

    @AuraEnabled(cacheable=true)
    public static Behavior_Evaluation__c getOne (String key) {
        List<Behavior_Evaluation__c> behaviorEvaluation = [SELECT Animal__c, Animal_Age__c, Animal_Breed__c, Animal_ID__c,
                Animal_Sex__c, Animal_Name__c, Name, Id, Caution__c, Muzzled_SSD_P3__c, Muzzled_OSD_P3__c, Is_Muzzled__c,
                Puppy_Muzzled_DI_P3__c, Puppy_Muzzled_DI_P2__c, Puppy_Muzzled_DI_P1__c, Puppy_Skipped_DI_P1__c,
                Puppy_Skipped_DI_P2__c, Puppy_Skipped_DI_P3__c, Puppy_Comments_DI_P1__c, Puppy_Comments_DI_P2__c,
                Puppy_Comments_DI_P3__c, Puppy_Dog_Interaction_P1__c, Puppy_Dog_Interaction_P2__c, Puppy_Dog_Interaction_P3__c,
                Puppy_BIK_Housing__c, Puppy_Behavior_in_Kennel__c, Puppy_Behavior_on_Leash__c, Puppy_Social_Behavior_P1__c,
                Puppy_Social_Behavior_P2__c, Puppy_Play_Tug_P1__c, Puppy_Play_Tug_P2__c,
                 Puppy_Play_Tag__c, Puppy_Restraint__c,
                Puppy_Comments_Restraint__c, Puppy_Skipped_Restraint__c, Puppy_Child_Doll_P1__c, Puppy_Comments_CD_P1__c,
                Puppy_Skipped_CD_P1__c, Puppy_Resource_Guarding_P1_Push_Face__c, Puppy_Resource_Guarding_P1_Touch_Body__c,
                Puppy_Resource_Guarding_P1_Touch_Neck__c, Puppy_Resource_Guarding_P1_Touch_Face__c, Puppy_Resource_Guarding_P2_Push_Face__c,
                Puppy_Resource_Guarding_P2_Touch_Body__c, Puppy_Resource_Guarding_P2_Touch_Neck__c, Puppy_Resource_Guarding_P2_Touch_Face__c,
                Social_Behavior_P1__c, Social_Behavior_P2_2__c, Play_Test_P1__c, Play_Test_Tug_P1__c, Play_Test_Tug_P2__c,
                Play_Test_P2__c, Pleasant_Touch__c, Pleasant_Touch_Test__c, Comments_Pleasant_Touch__c, Comments_SB_P1__c,
                Comments_SB_P2__c, Evaluation_Subtype__c, Behavior_in_Kennel__c,  Comments_BIK__c, Behavior_on_Leash__c,
                Comments_BOL__c, Unpleasant_Touch_1st__c, Unpleasant_Touch_2nd__c, Comments_UT_1st__c, Comments_UT_2nd__c,
                Tag_Test__c, Comments_Tag__c, Resource_Guarding_P1_Push_Face__c, Resource_Guarding_P1_Touch_Body__c,
                Resource_Guarding_P1_Touch_Face__c, Resource_Guarding_P1_Touch_Neck__c, Comments_RG_P1__c, Puppy_Child_Doll_P2__c,
                Resource_Guarding_P2_Push_Face__c, Resource_Guarding_P2_Touch_Body__c, Resource_Guarding_P2_Touch_Face__c,
                Resource_Guarding_P2_Touch_Neck__c, Comments_RG_P2__c, Toddler_Doll_P1__c, Comments_TD_P1__c, Toddler_Doll_P2__c,
                Comments_TD_P2__c, Scolding_Person_P1__c, Comments_SP_P1__c, Scolding_Person_P2__c, Comments_SP_P2__c, Fake_Dog__c,
                Comments_FD__c, Same_Sex_P1__c, Comments_SSD_P1__c, Same_Sex_P2__c, Comments_SSD_P2__c, Same_Sex_P3__c,
                Comments_SSD_P3__c, Opposite_Sex_P1__c, Comments_OSD_P1__c, Opposite_Sex_P2__c, Comments_OSD_P2__c, Opposite_Sex_P3__c,
                Comments_OSD_P3__c, Skipped_BIK__c, Skipped_BOL__c, Skipped_FD__c, Skipped_OSD_P1__c, Skipped_OSD_P2__c, Skipped_OSD_P3__c,
                Skipped_RG_P1__c, Skipped_RG_P1_PF__c, Skipped_RG_P2__c, Skipped_RG_P1_TB__c, Skipped_RG_P1_TF__c, Skipped_RG_P1_TN__c,
                Skipped_RG_P2_PF__c, Skipped_RG_P2_TB__c, Skipped_RG_P2_TF__c, Skipped_RG_P2_TN__c, Skipped_UT_1st__c, Skipped_UT_2nd__c,
                Skipped_TD_P1__c, Skipped_TD_P2__c, Skipped_Tag__c, Skipped_SSD_P1__c, Skipped_SSD_P2__c, Skipped_SSD_P3__c, Skipped_Pleasant__c,
                Skipped_SB_P1__c, Skipped_SB_P2__c, Skipped_SP_P1__c, Skipped_SP_P2__c, Skipped_Play_Tug_P1__c, Skipped_Play_Tug_P2__c,
                Comments_UT__c, Comments_Play_Tug_P1__c, Comments_Play_Tug_P2__c, Unpleasant_Touch_1st_Flank__c, Unpleasant_Touch_2nd_Flank__c
            FROM Behavior_Evaluation__c
            WHERE Id =: key LIMIT 1];
        if (behaviorEvaluation.size() > 0) {
            return behaviorEvaluation[0];
        }
        else {
            return null;
        }
    }

    /*
    * Private Methods
     */
    private static EvaluationWrapper newWrapper(SObjectField field, Behavior_Evaluation__c evaluation) {
        ControllerHelper.Properties prop = ControllerHelper.getFieldProperties(field);
        List<Picklist_Description_Config__mdt> sConfigs = MetadataUtil.getFieldValues(prop.id);
        System.debug('***sConfigs: ' + sConfigs);
        Map<String, Integer> hashMap = new Map<String, Integer>();
        for (Picklist_Description_Config__mdt config : sConfigs) {
            hashMap.put(config.DeveloperName, sConfigs.indexOf(config));
        }
        EvaluationWrapper.FieldContents commentField = new EvaluationWrapper.FieldContents();
        commentField.id = MetadataUtil.commentField(prop.id);
        if (evaluation.get(commentField.id) != null) {
            commentField.value = (String) evaluation.get(commentField.id);
        }else {
            commentField.value = '';
        }
        EvaluationWrapper.FieldContents skipField = new EvaluationWrapper.FieldContents();
        skipField.id = MetadataUtil.skipField(prop.id);
        if (evaluation.get(skipField.id) != null) {
            skipField.value = (String) evaluation.get(skipField.id);
        }else {
            skipField.value = '';
        }
        List<PicklistEntry> entries = field.getDescribe().getPicklistValues();

        List<EvaluationWrapper.Options> zeroOption = new List<EvaluationWrapper.Options>();
        List<EvaluationWrapper.Options> nOptions = new List<EvaluationWrapper.Options>();
        List<EvaluationWrapper.Options> rOptions = new List<EvaluationWrapper.Options>();
        List<EvaluationWrapper.Options> aOptions = new List<EvaluationWrapper.Options>();
        List<EvaluationWrapper.Options> iOptions = new List<EvaluationWrapper.Options>();

        List<String> strings = new List<String>();
        Integer index = 0;
        if (evaluation.get(field) != null) { strings = evaluation.get(field).toString().split(';'); }
        for (PicklistEntry entry : prop.fieldResult.picklistValues) {
            String key = '';
            for (Picklist_Description_Config__mdt config : sConfigs) {
                if (config.Field_API_Name__c == field.getDescribe().name) {
                    if (config.Field_Value__c == entry.label) {
                        key = config.DeveloperName;
                        Integer i = hashMap.get(key);
                        Picklist_Description_Config__mdt iConfig = sConfigs[i];
                        System.debug(iConfig);

                        EvaluationWrapper.Options options = new EvaluationWrapper.Options();
                        options.label = entry.label;
                        options.pleApiName = iConfig.Field_API_Name__c != null ? iConfig.Field_API_Name__c : field.getDescribe().name;
                        options.longDesc = iConfig.Field_Description__c != null ? '- ' + iConfig.Field_Description__c : '';
                        try {
                            if (iConfig.Value_Category__c.equals('0')) {
                                zeroOption.add(options);
                            }else if (iConfig.Value_Category__c.equals('1')) {
                                nOptions.add(options);
                            }else if (iConfig.Value_Category__c.equals('2')) {
                                rOptions.add(options);
                            }else if (iConfig.Value_Category__c.equals('3')) {
                                aOptions.add(options);
                            }else if (iConfig.Value_Category__c.equals('4')) {
                                iOptions.add(options);
                            }
                            if (!strings.isEmpty()) {
                                if (strings.contains(options.label)) {
                                    options.IsSelected = true;
                                }else if(!strings.contains(options.label)) {
                                    options.IsSelected = false;
                                }
                            }
                        }catch(Exception e) {
                            System.debug(e);
                        }
                        break;
                    }
                }
            }
        }

        EvaluationWrapper wrapper = new EvaluationWrapper();
        wrapper.id = field.getDescribe().name;
        wrapper.label = field.getDescribe().label;
        wrapper.mZeroOptions = zeroOption;
        wrapper.mNotConcerningOptions = nOptions;
        wrapper.mRedFlagOptions = rOptions;
        wrapper.mAlertOptions = aOptions;
        wrapper.mInconclusiveOptions = iOptions;
        wrapper.testComments = commentField;
        wrapper.skipField = skipField;
        wrapper.isSkipped = !String.isBlank((String)skipField.value);

        return wrapper;
    }

    /*
    * Behavior Report Properties
    * @Param: key => Behavior Evaluation
    * @method: getBehaviorReport
    * @description: sets behavior report values. Constructor is TabContentUtil custom class
     */
    @AuraEnabled
    public static TabContentUtil getBehaviorReport(Behavior_Evaluation__c behaviorEvaluation) {
        String iId = 'none defined';
        String iLabel = 'none defined';
        String iName = 'none defined';
        String iBreed = 'none defined';
        String iColor = 'none defined';
        String iCaseNumber = 'none defined';
        String iAnimalId = 'none defined';
        String iAnimalAge = 'none defined';
        String iAnimalSex = 'none defined';
        String iLocation = 'none defined';
        Date iCurrentDate = Date.today();
        List<Object> iPotBehavIssues = new List<Object>();
        List<Object> iPlReccs = new List<Object>();
        Map<String, Object> dVals = new Map<String, Object>{
                'id' => 'no values added' ,
                'label' => 'PLACEHOLDER LABEL TODO: UPDATE AFTER FIELDS ARE CREATED'
        };
        String iBehSummary = 'none defined';
        List<TabContentUtil> tabConentUtils = new List<TabContentUtil>();
        TabContentUtil utils = new TabContentUtil();
        utils.IsMuzzled = behaviorEvaluation.Is_Muzzled__c;
        utils.puppyHousing = behaviorEvaluation.Puppy_BIK_Housing__c;
        utils.puppyMuzzledDogInteraction1 = behaviorEvaluation.Puppy_Muzzled_DI_P1__c;
        utils.puppyMuzzledDogInteraction2 = behaviorEvaluation.Puppy_Muzzled_DI_P2__c;
        utils.puppyMuzzledDogInteraction3 = behaviorEvaluation.Puppy_Muzzled_DI_P3__c;
        utils.muzzledSameSexDog3 = behaviorEvaluation.Muzzled_SSD_P3__c;
        utils.muzzledOppositeSexDog3 = behaviorEvaluation.Muzzled_OSD_P3__c;
        utils.UseCaution = behaviorEvaluation.Caution__c;
        utils.IsAdult = behaviorEvaluation.Evaluation_Subtype__c == 'Adult Animal' ? true : false;
        utils.IsPuppy = behaviorEvaluation.Evaluation_Subtype__c == 'Puppy' ? true : false;

        utils.UnpleasantTouch1stFlank = behaviorEvaluation.Unpleasant_Touch_1st_Flank__c;
        utils.UnpleasantTouch2ndFlank = behaviorEvaluation.Unpleasant_Touch_2nd_Flank__c;

        if (behaviorEvaluation.Evaluation_Subtype__c == 'Dog Fighting') {
            utils.IsDogFighting = true;
            utils.IsAdult = true;
        }else {
            utils.IsDogFighting = false;
        }

        if (behaviorEvaluation.Evaluation_Subtype__c == 'Dog/Dog Only') {
            utils.IsDogOnly = true;
            utils.IsAdult = true;
        }else {
            utils.IsDogOnly = false;
        }
        EvaluationWrapper.FieldContents contents = new EvaluationWrapper.FieldContents();
        contents.id = Behavior_Evaluation__c.Caution__c.getDescribe().name;
        contents.value = behaviorEvaluation.Caution__c;
        utils.Caution = contents;


        return utils;
    }

    @AuraEnabled
    public static List<EvaluationWrapper> getAdultEvaluation(Behavior_Evaluation__c evaluation) {
        List<EvaluationWrapper> evalList = new List<EvaluationWrapper>();
        evalList.add(newWrapper(Behavior_Evaluation__c.Behavior_in_Kennel__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Behavior_on_Leash__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Social_Behavior_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Social_Behavior_P2_2__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Pleasant_Touch__c, evaluation));
        EvaluationWrapper ut1 = newWrapper(Behavior_Evaluation__c.Unpleasant_Touch_1st__c, evaluation);
        EvaluationWrapper ut2 = newWrapper(Behavior_Evaluation__c.Unpleasant_Touch_2nd__c, evaluation);
        evalList.add(new EvaluationWrapper(
            'Unpleasant Touch',
            'Unpleasant Touch',
            ut1.isSkipped,
            ut1.testComments,
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            ut1.skipField,
            ut1.index,
            ut1.isParent,
            ut1.parentTestApiName,
            ut1,
            ut2,
            new EvaluationWrapper(),
            new EvaluationWrapper())
        );
        evalList.add(newWrapper(Behavior_Evaluation__c.Play_Test_Tug_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Play_Test_Tug_P2__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Tag_Test__c, evaluation));
        EvaluationWrapper rg1TB = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Body__c, evaluation);
        EvaluationWrapper rg1TN = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Neck__c, evaluation);
        EvaluationWrapper rg1TF = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Face__c, evaluation);
        EvaluationWrapper rg1PF = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Push_Face__c, evaluation);
        evalList.add(new EvaluationWrapper(
            'Resource Guarding P1',
            'Resource Guarding P1',
            rg1TB.isSkipped,
            rg1TB.testComments,
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            rg1TB.skipField,
            rg1TB.index,
            rg1TB.isParent,
            rg1TB.parentTestApiName,
            rg1TB,
            rg1TN,
            rg1TF,
            rg1PF)
        );
        EvaluationWrapper rg2TB = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Body__c, evaluation);
        EvaluationWrapper rg2TN = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Neck__c, evaluation);
        EvaluationWrapper rg2TF = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Face__c, evaluation);
        EvaluationWrapper rg2PF = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P2_Push_Face__c, evaluation);
        evalList.add(new EvaluationWrapper(
            'Resource Guarding P2',
            'Resource Guarding P2',
            rg2TB.isSkipped,
            rg2TB.testComments,
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            rg2TB.skipField,
            rg2TB.index,
            rg2TB.isParent,
            rg2TB.parentTestApiName,
            rg2TB,
            rg2TN,
            rg2TF,
            rg2PF)
        );
        evalList.add(newWrapper(Behavior_Evaluation__c.Toddler_Doll_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Toddler_Doll_P2__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Scolding_Person_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Scolding_Person_P2__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Fake_Dog__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Same_Sex_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Same_Sex_P2__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Same_Sex_P3__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Opposite_Sex_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Opposite_Sex_P2__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Opposite_Sex_P3__c, evaluation));
        return evalList;
    }

    @AuraEnabled
    public static List<EvaluationWrapper> getPuppyEvaluation(Behavior_Evaluation__c evaluation) {
        List<EvaluationWrapper> evalList = new List<EvaluationWrapper>();
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Behavior_in_Kennel__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Behavior_on_Leash__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Social_Behavior_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Social_Behavior_P2__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Play_Tug_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Play_Tug_P2__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Play_Tag__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Restraint__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Child_Doll_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Child_Doll_P2__c, evaluation));
        EvaluationWrapper rg1TB = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Touch_Body__c, evaluation);
        EvaluationWrapper rg1TN = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Touch_Neck__c, evaluation);
        EvaluationWrapper rg1TF = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Touch_Face__c, evaluation);
        EvaluationWrapper rg1PF = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Push_Face__c, evaluation);
        evalList.add(new EvaluationWrapper(
            'Resource Guarding P1',
            'Resource Guarding P1',
            rg1TB.isSkipped,
            rg1TB.testComments,
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            rg1TB.skipField,
            rg1TB.index,
            rg1TB.isParent,
            rg1TB.parentTestApiName,
            rg1TB,
            rg1TN,
            rg1TF,
            rg1PF)
        );
        EvaluationWrapper rg2TB = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Touch_Body__c, evaluation);
        EvaluationWrapper rg2TN = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Touch_Neck__c, evaluation);
        EvaluationWrapper rg2TF = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Touch_Face__c, evaluation);
        EvaluationWrapper rg2PF = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Push_Face__c, evaluation);
        evalList.add(new EvaluationWrapper(
            'Resource Guarding P2',
            'Resource Guarding P2',
            rg2TB.isSkipped,
            rg2TB.testComments,
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            new List<EvaluationWrapper.Options>(),
            rg2TB.skipField,
            rg2TB.index,
            rg2TB.isParent,
            rg2TB.parentTestApiName,
            rg2TB,
            rg2TN,
            rg2TF,
            rg2PF)
        );
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Dog_Interaction_P1__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Dog_Interaction_P2__c, evaluation));
        evalList.add(newWrapper(Behavior_Evaluation__c.Puppy_Dog_Interaction_P3__c, evaluation));
        return evalList;
    }

    @AuraEnabled(Cacheable=true)
    public static List<EvaluationWrapper.ListItems> getSkipReasons(Integer key) {
        List<EvaluationWrapper.ListItems>  listItems = new List<EvaluationWrapper.ListItems>();
        List<PicklistEntry> entries = Behavior_Evaluation__c.Skipped_BIK__c.getDescribe().getPicklistValues();
        for (PicklistEntry entry : entries) {
            EvaluationWrapper.ListItems item = new EvaluationWrapper.ListItems();
            item.label = entry.label;
            item.value = entry.label;
            listItems.add(item);
        }

        return listItems;
    }

    /*
    * executables
     */

    @AuraEnabled
    public static Map<String, Object> updateEval(String apiName, Object values, String recordId) {
        Map<String, Object> params = new Map<String, Object>{
                'apiName' => apiName ,
                'values' => values ,
                'recordId' => recordId
        };

        Map<String, Object> request = new Map<String, Object>{
                'service' => Services.BehaviorEvaluation ,
                'action' => 'updateComments' ,
                'params' => params ,
                'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'apiName' ,
                                'type' => 'string' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'values' ,
                                'type' => 'string' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'recordId' ,
                                'type' => 'string' ,
                                'required' => true ,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        }
                } ,
                'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'item',
                                'type' => 'object',
                                'required' => true,
                                'apiName' => 'item',
                                'errors' => new Map<String, Object> {}
                        }
                }
        };

        Map<String, Object> response = new Map<String, Object>();

        service_Validation.proccessRequest(request, response);
        return response;
    }

    @AuraEnabled
    public static Map<String, Object> putSelections(String apiName, List<String> values, String recordId) {
        Map<String, Object> params = new Map<String, Object>{
                'apiName' => apiName ,
                'values' => values ,
                'recordId' => recordId
        };
        System.debug(params);

        Map<String, Object> request = new Map<String, Object>{
                'service' => Services.BehaviorEvaluation ,
                'action' => 'updatePicklist' ,
                'params' => params ,
                'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'apiName' ,
                                'type' => 'string' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'values' ,
                                'type' => 'list' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'recordId' ,
                                'type' => 'string' ,
                                'required' => true ,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        }
                } ,
                'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'item',
                                'type' => 'object',
                                'required' => true,
                                'apiName' => 'item',
                                'errors' => new Map<String, Object> {}
                        }
                }
        };

        List<String> relatedVals = new List<String>();
        if (apiName == 'Skipped_OSD_P1__c') {
            relatedVals.add('Skipped_OSD_P2__c');
            relatedVals.add('Skipped_OSD_P3__c');
        }else if (apiName == 'Skipped_SSD_P1__c') {
            System.debug('IS SAME SEX DOG');
            relatedVals.add('Skipped_SSD_P2__c');
            relatedVals.add('Skipped_SSD_P3__c');
        }else if (apiName == 'Puppy_Skipped_DI_P1__c') {
            relatedVals.add('Puppy_Skipped_DI_P2__c');
            relatedVals.add('Puppy_Skipped_DI_P3__c');
        }

        for (String nApiName : relatedVals) {
            System.debug('RELATED RECORD API NAME ===> ' + nApiName);
            Map<String, Object> params1 = new Map<String, Object>{
                    'apiName' => nApiName ,
                    'values' => values ,
                    'recordId' => recordId
            };
            Map<String, Object> request1 = new Map<String, Object>{
                    'service' => Services.BehaviorEvaluation ,
                    'action' => 'updatePicklist' ,
                    'params' => params1 ,
                    'fields' => new List<Map<String, Object>>{
                            new Map<String, Object>{
                                    'name' => 'apiName' ,
                                    'type' => 'string' ,
                                    'required' => true,
                                    'errors' => new Map<String, Object>{
                                            'ValidationError' => new Map<String, String>{
                                                    'message' => 'Parameter {0} is empty'
                                            }
                                    }
                            } ,
                            new Map<String, Object>{
                                    'name' => 'values' ,
                                    'type' => 'list' ,
                                    'required' => true,
                                    'errors' => new Map<String, Object>{
                                            'ValidationError' => new Map<String, String>{
                                                    'message' => 'Parameter {0} is empty'
                                            }
                                    }
                            } ,
                            new Map<String, Object>{
                                    'name' => 'recordId' ,
                                    'type' => 'string' ,
                                    'required' => true ,
                                    'errors' => new Map<String, Object>{
                                            'ValidationError' => new Map<String, String>{
                                                    'message' => 'Parameter {0} is empty'
                                            }
                                    }
                            }
                    } ,
                    'response' => new List<Map<String, Object>>{
                            new Map<String, Object>{
                                    'name' => 'item',
                                    'type' => 'object',
                                    'required' => true,
                                    'apiName' => 'item',
                                    'errors' => new Map<String, Object> {}
                            }
                    }
            };
            Map<String, Object> response1 = new Map<String, Object>();
            service_Validation.proccessRequest(request1, response1);
            System.debug('INDEX OF RELATED FIELD ====>  ' +  String.valueOf(relatedVals.indexOf(nApiName)) +
                    response1.values());
        }
        Map<String, Object> response = new Map<String, Object>();

        service_Validation.proccessRequest(request, response);
        return response;
    }

    @AuraEnabled
    public static Map<String, Object> putBoolean(String apiName, Boolean values, String recordId) {
        Map<String, Object> params = new Map<String, Object>{
                'apiName' => apiName ,
                'values' => values ,
                'recordId' => recordId
        };
        System.debug('PUT BOOL PARAMS' + params);
        Map<String, Object> request = new Map<String, Object>{
                'service' => Services.BehaviorEvaluation ,
                'action' => 'putBoolean' ,
                'params' => params ,
                'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'apiName' ,
                                'type' => 'string' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'values' ,
                                'type' => 'boolean' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'recordId' ,
                                'type' => 'string' ,
                                'required' => true ,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        }
                } ,
                'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'item',
                                'type' => 'object',
                                'required' => true,
                                'apiName' => 'item',
                                'errors' => new Map<String, Object> {}
                        }
                }
        };
        Map<String, Object> response = new Map<String, Object>();

        service_Validation.proccessRequest(request, response);
        return response;
    }

    @AuraEnabled
    public static Map<String, Object> handleValidity (String key) {
        Map<String, Object> params = new Map<String, Object>{
                'key' => key
        };

        Map<String, Object> request = new Map<String, Object>{
                'service' => Services.BehaviorEvaluation ,
                'action' => 'checkValidity' ,
                'params' => params ,
                'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'key' ,
                                'type' => 'string' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        }
                } ,
                'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'item',
                                'type' => 'list',
                                'required' => true,
                                'apiName' => 'item',
                                'errors' => new Map<String, Object> {}
                        }
                }
        };

        Map<String, Object> response = new Map<String, Object>();

        service_Validation.proccessRequest(request, response);
        System.debug('Validity Response ' + response);
        return response;

    }

    @AuraEnabled
    public static Map<String, Object> putSelection(String apiName, String values, String recordId) {
        Map<String, Object> params = new Map<String, Object>{
                'apiName' => apiName ,
                'values' => values ,
                'recordId' => recordId
        };

        Map<String, Object> request = new Map<String, Object>{
                'service' => Services.BehaviorEvaluation ,
                'action' => 'updatePick' ,
                'params' => params ,
                'fields' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'apiName' ,
                                'type' => 'string' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'values' ,
                                'type' => 'string' ,
                                'required' => true,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        } ,
                        new Map<String, Object>{
                                'name' => 'recordId' ,
                                'type' => 'string' ,
                                'required' => true ,
                                'errors' => new Map<String, Object>{
                                        'ValidationError' => new Map<String, String>{
                                                'message' => 'Parameter {0} is empty'
                                        }
                                }
                        }
                } ,
                'response' => new List<Map<String, Object>>{
                        new Map<String, Object>{
                                'name' => 'item',
                                'type' => 'object',
                                'required' => true,
                                'apiName' => 'item',
                                'errors' => new Map<String, Object> {}
                        }
                }
        };
        Map<String, Object> response = new Map<String, Object>();

        service_Validation.proccessRequest(request, response);
        return response;
    }
}