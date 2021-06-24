/**
 * Class Description
 *
 * @author Lamar Barnett
 * @version 1.0.13
 */

public with sharing class BehaviorEvaluationPageController {
    public static dao_BehaviorEvaluations daoBehaviorEvaluations = new dao_BehaviorEvaluations();
    public static dao_Animal daoAnimal = new dao_Animal();
    public static dao_Case daoCase = new dao_Case();
    public static Behavior_Evaluation__c m_behaviorEvaluation = new Behavior_Evaluation__c();


    @AuraEnabled(Cacheable=true)
    public static List<Behavior_Evaluation__c> getBehaviorEvalsByAnimal (String key) {
        List<Behavior_Evaluation__c> behaviorEvaluations = daoBehaviorEvaluations.getAllByAnimalIdString(key);
        if (behaviorEvaluations.isEmpty()) {return null ; }
        return behaviorEvaluations;
    }
    @AuraEnabled
    public static Behavior_Evaluation__c getOne (String key) {
        Behavior_Evaluation__c behaviorEvaluation = daoBehaviorEvaluations.findOne(key);
        if (behaviorEvaluation == null) { return null;}
        m_behaviorEvaluation = behaviorEvaluation;
        return behaviorEvaluation;
    }
    @AuraEnabled
    public static Behavior_Evaluation__c getOneByAnimalId (String key) {
        Behavior_Evaluation__c behaviorEvaluation = daoBehaviorEvaluations.getOneByAnimalIdString(key);
        if( behaviorEvaluation.Name.isWhitespace() ) { return null ; }
        return behaviorEvaluation;
    }
    @AuraEnabled
    public static String getAnimalId(String key) {
        Behavior_Evaluation__c behaviorEvaluation = daoBehaviorEvaluations.getOneByAnimalId(key);
        String m_id = behaviorEvaluation.Animal__c;
        return  m_id;
    }
    /*
    * Private Methods
     */
    private static EvaluationWrapper newWrapper(SObjectField field, Behavior_Evaluation__c evaluation) {
        ControllerHelper.Properties prop = ControllerHelper.getFieldProperties(field);
        List<Picklist_Description_Config__mdt> sConfigs = MetadataUtil.getFieldValues(prop.id);
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



        List<EvaluationWrapper.Options> zeroOption = new List<EvaluationWrapper.Options>();
        List<EvaluationWrapper.Options> nOptions = new List<EvaluationWrapper.Options>();
        List<EvaluationWrapper.Options> rOptions = new List<EvaluationWrapper.Options>();
        List<EvaluationWrapper.Options> aOptions = new List<EvaluationWrapper.Options>();
        List<EvaluationWrapper.Options> iOptions = new List<EvaluationWrapper.Options>();

        List<String> strings = new List<String>();
        if (evaluation.get(field) != null) { strings = evaluation.get(field).toString().split(';'); }
        System.debug(strings);
        for (Picklist_Description_Config__mdt config : sConfigs) {
            EvaluationWrapper.Options options = new EvaluationWrapper.Options();
            options.label = config.Field_Value__c;
            options.pleApiName = config.Field_API_Name__c;
            options.longDesc = config.Field_Description__c;
            if (config.Value_Category__c.equals('0')) {
                zeroOption.add(options);
            }else if (config.Value_Category__c.equals('1')) {
                nOptions.add(options);
            }else if (config.Value_Category__c.equals('2')) {
                rOptions.add(options);
            }else if (config.Value_Category__c.equals('3')) {
                aOptions.add(options);
            }else if (config.Value_Category__c.equals('4')) {
                iOptions.add(options);
            }
            if (!strings.isEmpty()) {
                if (strings.contains(options.label)) {
                    options.IsSelected = true;
                }else if(!strings.contains(options.label)) {
                    options.IsSelected = false;
                }
            }
        }
        /*
        if (!strings.isEmpty()) {
            for ()

        }

         */

        EvaluationWrapper wrapper = new EvaluationWrapper();
        wrapper.id = prop.id;
        wrapper.label = prop.label;
        wrapper.mZeroOptions = zeroOption;
        wrapper.mNotConcerningOptions = nOptions;
        wrapper.mRedFlagOptions = rOptions;
        wrapper.mAlertOptions = aOptions;
        wrapper.mInconclusiveOptions = iOptions;
        wrapper.testComments = commentField;
        wrapper.skipField = skipField;
        wrapper.isSkipped = !skipField.value.isWhitespace() ? true : false ;

        return wrapper;
    }
    /*
    * Behavior Report Properties
    * @Param: key => Behavior Evaluation
    * @method: getBehaviorReport
    * @description: sets behavior report values. Constructor is TabContentUtil custom class
     */
    @AuraEnabled
    public static TabContentUtil getBehaviorReport(String key) {
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
        Behavior_Evaluation__c behaviorEvaluation = daoBehaviorEvaluations.findOne(key);
        //String aid = behaviorEvaluation.Animal__c;
        //Animal__c cAnimal = daoAnimal.findOne(aid);
        //Case aCase = daoCase.findOne(String.valueOf(cAnimal.Case__c));
        //utils.id = String.isNotEmpty(cAnimal.Id) ? 'Behavior Report' : iId;
        //utils.label = String.isNotEmpty(cAnimal.Id) ? 'Behavior Report' : iLabel;
        //utils.name = String.isNotEmpty(cAnimal.Name) ? cAnimal.Name : iName;
        //utils.breed = String.isNotEmpty(cAnimal.Breed__c) ? cAnimal.Breed__c : iBreed;
        //utils.color = String.isNotEmpty(cAnimal.Color__c) ? cAnimal.Color__c : iColor;
        //utils.caseNumber = String.isNotEmpty(aCase.Id) ? aCase.Id : iCaseNumber;
        //utils.animalId = String.isNotEmpty(cAnimal.Animal_Field_ID__c) ? cAnimal.Animal_Field_ID__c : iAnimalId;
        //utils.animalAge = String.isNotEmpty(cAnimal.Age__c) ? cAnimal.Age__c : iAnimalId;
        //utils.animalSex = String.isNotEmpty(cAnimal.Gender__c) ? cAnimal.Gender__c : iAnimalId;
        //utils.location = String.isNotEmpty(cAnimal.Animal_Field_ID__c) ? cAnimal.Animal_Field_ID__c : iAnimalId;
        //utils.currentDate = Date.today();
        // TODO: refactor after potentialBehaviorIssues and placementRecommendation fields are defined
        //utils.potentialBehaviorIssues = (List<Object>) iPotBehavIssues.add(dVals);
        //utils.placementRecommendations =  (List<Object>) iPlReccs.add(dVals);
        //TODO: refactor after Behavior Summary field and process id defined
        //utils.behaviorSummary = iBehSummary;
        utils.IsMuzzled = behaviorEvaluation.Is_Muzzled__c;
        utils.UseCaution = behaviorEvaluation.Caution__c;
        utils.IsAdult = behaviorEvaluation.Evaluation_Subtype__c == 'Adult Animal' ? true : false;
        utils.IsPuppy = behaviorEvaluation.Evaluation_Subtype__c == 'Puppy' ? true : false;
        if (behaviorEvaluation.Evaluation_Subtype__c == 'Dog Fighting') {
            utils.IsDogFighting = true;
            utils.IsAdult = true;
        }else {
            utils.IsDogFighting = false;
        }



        return utils;
    }
    /*
    *  Behavior in Kennel Properties
    *   @Description: Method generates properties for the 'Behavior in Kennel' test on the Evaluation page. All methods follow
    *    this pattern. Recreate additional methods using the below pattern
    *   @TODO: Find out how to define helper text in the Database so the longDesc values are not hard coded
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getBehaviorInKennel(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Behavior_in_Kennel__c, evaluation);

        return wrapper;
    }
    /*
    * Behavior on Leash Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getBehaviorOnLeash(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Behavior_on_Leash__c, evaluation);
        return wrapper;
    }
    /*
    * Social Behavior Test Properties - Part 1
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getSocialBehaviorTestOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Social_Behavior_P1__c, evaluation);
        return wrapper;
    }
    /*
    * Social Behavior Test Properties - Part 2
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getSocialBehaviorTestTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Social_Behavior_P2_2__c, evaluation);
        System.debug(wrapper.testComments);
        return wrapper;
    }
    /*
    * Pleasant Touch Test
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPleasantTouchTest(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Pleasant_Touch__c, evaluation);
        return wrapper;
    }
    /*
    * Unpleasant Touch Test Two Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getUnpleasantTouchTestOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Unpleasant_Touch_1st__c, evaluation);
        return wrapper;
    }
    /*
    *
    * Play Test Part 1 Properties
    *
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPlayTestPartOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Play_Test_Tug_P1__c, evaluation);
        return wrapper;
    }
    /*
    * Play Test Part 2 Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPlayTestPartTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Play_Test_Tug_P2__c, evaluation);
        return wrapper;
    }
    /*
    * Tag Test Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getTagTest(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Tag_Test__c, evaluation);
        return wrapper;
    }
    /*
    * Resource Guarding Test Part 1 Properties
     */

    /*
    @AuraEnabled
    public static EvaluationWrapper getResourceGuardingOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = new EvaluationWrapper();
        wrapper.wrapper1 = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Push_Face__c, evaluation);
        wrapper.wrapper2 = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Face__c, evaluation);
        wrapper.wrapper3 = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Neck__c, evaluation);
        wrapper.wrapper4 = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Body__c, evaluation);
        System.debug(wrapper);
        return wrapper;

    }
    */


    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getResourceGuardingOnePF(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Push_Face__c, evaluation);
        return wrapper;
    }


    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getResourceGuardingOneTF(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Face__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getResourceGuardingOneTN(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Neck__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getResourceGuardingOneTB(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P1_Touch_Body__c, evaluation);
        return wrapper;
    }


    /*
    * Resource Guarding Test Part 2 Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getResourceGuardingTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P2_Push_Face__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getResourceGuardingTF(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Face__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getResourceGuardingTwoTN(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Neck__c, evaluation);
        return wrapper;
    }@AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getResourceGuardingTwoTB(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Resource_Guarding_P2_Touch_Body__c, evaluation);
        return wrapper;
    }
    /*
    * Toddler Doll Test Part 1 Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getToddlerDollTestOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Toddler_Doll_P1__c, evaluation);
        return wrapper;
    }
    /*
    * Toddler Doll Test Part 2 Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getToddlerDollTestTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Toddler_Doll_P2__c, evaluation);
        return wrapper;
    }
    /*
    * Scolding Person Test Part 1 Properties Scolding_Person_P1__c
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getScoldingPersonTestOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Scolding_Person_P1__c, evaluation);
        return wrapper;
    }
    /*
    * Scolding Person Test Part 2 Properties Scolding_Person_P2__c
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getScoldingPersonTestTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Scolding_Person_P2__c, evaluation);
        return wrapper;
    }
    /*
    * Fake Dog Interaction Test Properties Fake_Dog__c
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getFakeDogTest(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Fake_Dog__c, evaluation);
        return wrapper;
    }
    /*
    * Same Sex Dog Test Part 1 Properties Same_Sex_P1__c
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getSameSexDogTestOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Same_Sex_P1__c, evaluation);
        return wrapper;
    }
    /*
    * Same Sex Dog Test Part 2 Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getSameSexDogTestTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Same_Sex_P2__c, evaluation);
        return wrapper;
    }
    /*
    * Same Sex Dog Test Part 3 Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getSameSexDogTestThree(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Same_Sex_P3__c, evaluation);
        return wrapper;
    }
    /*
    * Opposite Sex Dog Test Part 1 Properties Opposite_Sex_P1__c
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getOppositeSexDogTestOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Opposite_Sex_P1__c, evaluation);
        return wrapper;
    }
    /*
    * Opposite Sex Dog Test Part 2 Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getOppositeSexDogTestTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Opposite_Sex_P2__c, evaluation);
        return wrapper;
    }
    /*
    * Opposite Sex Dog Test Part 3 Properties
     */
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getOppositeSexDogTestThree(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Opposite_Sex_P3__c, evaluation);
        return wrapper;
    }

    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyBehaviorInKennel(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Behavior_in_Kennel__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyBehaviorOnLeash(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Behavior_on_Leash__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppySocialBehaviorPart1(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Social_Behavior_P1__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppySocialBehaviorPart2(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Social_Behavior_P2__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyPlayTestTugP1(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Play_Tug_P1__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyPlayTestTugP2(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Play_Tug_P2__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyPlayTestTugTug(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Play_Tag__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyRestraint(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Restraint__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyResourceGuardingPartOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P1_Push_Face__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyResourceGuardingPartTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Resource_Guarding_P2_Push_Face__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyChildDollOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Child_Doll_P1__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyChildDollTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Child_Doll_P1__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyDogInteractionOne(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Dog_Interaction_P1__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyDogInteractionTwo(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Dog_Interaction_P2__c, evaluation);
        return wrapper;
    }
    @AuraEnabled(Cacheable=true)
    public static EvaluationWrapper getPuppyDogInteractionThree(String key) {
        Behavior_Evaluation__c evaluation = getOne(key);
        EvaluationWrapper wrapper = newWrapper(Behavior_Evaluation__c.Puppy_Dog_Interaction_P3__c, evaluation);
        return wrapper;
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

    @AuraEnabled
    public static Boolean getCautionStatus(String key) {
        Behavior_Evaluation__c evaluation = daoBehaviorEvaluations.findOne(key);
        Boolean bool;
        bool = evaluation.Caution__c ? true : false;
        return bool;
    }

    /*
    * executables
     */

    @AuraEnabled
    public static Map<String, Object> updateEval(String apiName,String values, String recordId) {
        Map<String, Object> params = new Map<String, Object>{
                'apiName' => apiName ,
                'values' => values ,
                'recordId' => recordId
        };
        System.debug(params);

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


}