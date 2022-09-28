public class BehEvalPdfController {
    
    public Behavior_Evaluation__c behEval{get;set;}
    public Boolean paramForensic { get; set; }
    public List<String> potentBehIssue { get; set; }
    public String summary { get; set; }
    public List<EvaluationGroup> evaluation { get; set; }
    
    public BehEvalPdfController(ApexPages.StandardController controller){
        
        behEval = [SELECT Id, Potential_Behavior_Issues__c,
                Overall_Evaluation_Grade__c, Evaluation_Subtype__c,
                Facility_Outcome__c, Animal_Name__c, Animal_ID__c,
                Animal_Breed__c, Animal_Age__c, Animal_Color__c,
                Animal_Sex__c, Evaluation_Date__c, Case_Number__c,
                Potential_Beh_Iss_Other__c, Behavior_Evaluation_Summary__c,
                Tester_Initials__c, Caution__c,
                Behavior_in_Kennel__c, Skipped_BIK__c, Comments_BIK__c,
                Behavior_on_Leash__c, Skipped_BOL__c, Comments_BOL__c,
                Fake_Dog__c, Skipped_FD__c, Comments_FD__c,
                Social_Behavior_P1__c, Skipped_SB_P1__c, Comments_SB_P1__c,
                Social_Behavior_P2_2__c, Skipped_SB_P2__c, Comments_SB_P2__c,
                Pleasant_Touch__c, Skipped_Pleasant__c, Comments_Pleasant_Touch__c,
                Unpleasant_Touch_1st__c, Skipped_UT_1st__c, Comments_UT__c,
                Unpleasant_Touch_2nd__c, Skipped_UT_2nd__c, Comments_UT_2nd__c,
                Play_Test_Tug_P1__c, Skipped_Play_Tug_P1__c, Comments_Play_Tug_P1__c,
                Play_Test_Tug_P2__c, Skipped_Play_Tug_P2__c, Comments_Play_Tug_P2__c,
                Tag_Test__c, Skipped_Tag__c, Comments_Tag__c,
                Resource_Guarding_P1_Push_Face__c,
                Resource_Guarding_P1_Touch_Body__c,
                Resource_Guarding_P1_Touch_Face__c,
                Resource_Guarding_P1_Touch_Neck__c,
                Skipped_RG_P1__c, Comments_RG_P1__c,
                Resource_Guarding_P2_Push_Face__c,
                Resource_Guarding_P2_Touch_Body__c,
                Resource_Guarding_P2_Touch_Face__c,
                Resource_Guarding_P2_Touch_Neck__c,
                Skipped_RG_P2__c, Comments_RG_P2__c,
                Toddler_Doll_P1__c, Skipped_TD_P1__c, Comments_TD_P1__c,
                Toddler_Doll_P2__c, Skipped_TD_P2__c, Comments_TD_P2__c,
                Scolding_Person_P1__c, Skipped_SP_P1__c, Comments_SP_P1__c,
                Scolding_Person_P2__c, Skipped_SP_P2__c, Comments_SP_P2__c,
                Same_Sex_P1__c, Skipped_SSD_P1__c, Comments_SSD_P1__c,
                Same_Sex_P2__c, Skipped_SSD_P2__c, Comments_SSD_P2__c,
                Same_Sex_P3__c, Skipped_SSD_P3__c, Comments_SSD_P3__c,
                Opposite_Sex_P1__c, Skipped_OSD_P1__c, Comments_OSD_P1__c,
                Opposite_Sex_P2__c, Skipped_OSD_P2__c, Comments_OSD_P2__c,
                Opposite_Sex_P3__c, Skipped_OSD_P3__c, Comments_OSD_P3__c,
                Muzzled_SSD_P3__c, Muzzled_OSD_P3__c,
                Puppy_Behavior_in_Kennel__c, Puppy_Behavior_on_Leash__c, Puppy_BIK_Housing__c,
                Puppy_Social_Behavior_P1__c, Puppy_Social_Behavior_P2__c,
                Puppy_Play_Tug_P1__c, Puppy_Play_Tug_P2__c, Puppy_Play_Tag__c,
                Puppy_Restraint__c, Puppy_Skipped_Restraint__c, Puppy_Comments_Restraint__c,
                Puppy_Resource_Guarding_P1_Push_Face__c,
                Puppy_Resource_Guarding_P1_Touch_Body__c,
                Puppy_Resource_Guarding_P1_Touch_Face__c,
                Puppy_Resource_Guarding_P1_Touch_Neck__c,
                Puppy_Resource_Guarding_P2_Push_Face__c,
                Puppy_Resource_Guarding_P2_Touch_Body__c,
                Puppy_Resource_Guarding_P2_Touch_Face__c,
                Puppy_Resource_Guarding_P2_Touch_Neck__c,
                Puppy_Child_Doll_P1__c, Puppy_Child_Doll_P2__c,
                Puppy_Dog_Interaction_P1__c, Puppy_Skipped_DI_P1__c,
                Puppy_Comments_DI_P1__c, Puppy_Muzzled_DI_P1__c,
                Puppy_Dog_Interaction_P2__c, Puppy_Skipped_DI_P2__c,
                Puppy_Comments_DI_P2__c, Puppy_Muzzled_DI_P2__c,
                Puppy_Dog_Interaction_P3__c, Puppy_Skipped_DI_P3__c,
                Puppy_Comments_DI_P3__c, Puppy_Muzzled_DI_P3__c,
                Potential_Issue_Aggression_To_Animals__c,
                Potential_Issue_Aggression_To_People__c,
                Potential_Issue_Fear__c,
                Potential_Issue_High_Arousal__c,
                Potential_Issue_Other__c,
                Potential_Issue_Other_Notes__c
        FROM Behavior_Evaluation__c
        WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        
        if (ApexPages.currentPage().getParameters().get('forensic') != null) {
            paramForensic = Boolean.valueOf(ApexPages.currentPage().getParameters().get('forensic'));
        }
        
        //Breaks up Potential Behavior Issues multi-select into potentBehIssue list
        if(behEval.Potential_Behavior_Issues__c != null){
            potentBehIssue = behEval.Potential_Behavior_Issues__c.split(';');
        }

        summary = behEval.Behavior_Evaluation_Summary__c;
        if (summary != null && paramForensic != null && paramForensic == true) {
            //remove same sex and opposite sex entries
            Integer sameStart = 0;
            Integer sameEnd = 0;
            if(summary.contains('<p><b>Same Sex')){
                sameStart = summary.indexOf('<p><b>Same Sex');
            }
            if (summary.contains('</p>') && sameStart != -1) {
                sameEnd = summary.indexOf('</p>', sameStart);
                summary = summary.substring(0, sameStart) + summary.substring(sameEnd + 4);
            }

            if(summary.contains('<p><b>Opposite Sex')){
                Integer oppositeStart = summary.indexOf('<p><b>Opposite Sex');
                if (oppositeStart != -1) {
                    Integer oppositeEnd = summary.indexOf('</p>', oppositeStart);
                    summary = summary.substring(0, oppositeStart) + summary.substring(oppositeEnd + 4);
                }
            }
        }
        
        List<Test_Config__mdt> testConfigMetadata;
        switch on behEval.Evaluation_SubType__c {
            when 'Puppy' {
                testConfigMetadata = [SELECT MasterLabel, Test_Display_Order__c, Test_Name__c, Test_Description__c, IsPuppy__c, IsAdult__c, IsDogFighting__c, IsDogOnly__c,
                                                        Test_Header_Description__c, Test_Type_Description__c, Test_Optional_Field__c, Test_Skip_Reason_Field__c, Test_Comment_Field_Name__c,
                                                        (SELECT Field_API_Name__c,Picklist_Order__c,Value_Category__c,Field_Value__c, Field_Description__c
                                                        FROM Picklist_Description_Configs__r)
                                                    FROM Test_Config__mdt
                                                    WHERE IsPuppy__c = true
                                                    AND Test_Name__c != null];
            }
            when 'Adult Animal' {
                testConfigMetadata = [SELECT MasterLabel, Test_Display_Order__c, Test_Name__c, Test_Description__c, IsPuppy__c, IsAdult__c, IsDogFighting__c, IsDogOnly__c,
                                                        Test_Header_Description__c, Test_Type_Description__c, Test_Optional_Field__c, Test_Skip_Reason_Field__c, Test_Comment_Field_Name__c,
                                                        (SELECT Field_API_Name__c,Picklist_Order__c,Value_Category__c,Field_Value__c, Field_Description__c
                                                        FROM Picklist_Description_Configs__r)
                                                    FROM Test_Config__mdt
                                                    WHERE IsAdult__c = true
                                                    AND Test_Name__c != null];
            }
            when 'Dog Fighting' {
                testConfigMetadata = [SELECT MasterLabel, Test_Display_Order__c, Test_Name__c, Test_Description__c, IsPuppy__c, IsAdult__c, IsDogFighting__c, IsDogOnly__c,
                                                        Test_Header_Description__c, Test_Type_Description__c, Test_Optional_Field__c, Test_Skip_Reason_Field__c, Test_Comment_Field_Name__c,
                                                        (SELECT Field_API_Name__c,Picklist_Order__c,Value_Category__c,Field_Value__c, Field_Description__c
                                                        FROM Picklist_Description_Configs__r)
                                                    FROM Test_Config__mdt
                                                    WHERE IsDogFighting__c = true
                                                    AND Test_Name__c != null];
            }
            when 'Dog/Dog Only' {
                testConfigMetadata = [SELECT MasterLabel, Test_Display_Order__c, Test_Name__c, Test_Description__c, IsPuppy__c, IsAdult__c, IsDogFighting__c, IsDogOnly__c,
                                                        Test_Header_Description__c, Test_Type_Description__c, Test_Optional_Field__c, Test_Skip_Reason_Field__c, Test_Comment_Field_Name__c,
                                                        (SELECT Field_API_Name__c,Picklist_Order__c,Value_Category__c,Field_Value__c, Field_Description__c
                                                        FROM Picklist_Description_Configs__r)
                                                    FROM Test_Config__mdt
                                                    WHERE IsDogOnly__c = true
                                                    AND Test_Name__c != null];
            }
        }
        
        //Get field data mapping to add selected item descriptions
        Map<String, Object> evalFields = behEval.getPopulatedFieldsAsMap();
        evaluation = new List<EvaluationGroup>();
        Set<String> testGroup = new Set<String>();
        Map<String, EvaluationGroup> evaluationMap = new Map<String, EvaluationGroup>();
        for (Test_Config__mdt config : testConfigMetadata) {
            //Ignore tabs for forensic use
            if (paramForensic != null && paramForensic == true) {
                if (config.Test_Name__c.startsWith('Same Sex') || config.Test_Name__c.startsWith('Opposite Sex')) {
                    continue;
                }
            }
            List<ValueGroup> vGroup = new List<ValueGroup>();
            Map<String, ValueGroup> valueMap = new Map<String, ValueGroup>();
            for (Picklist_Description_Config__mdt pick : config.Picklist_Description_Configs__r) {
                //Gather selected items per tab by comparing the defined metadata value to the actual field value
                FieldGroup fGroup = new FieldGroup();
                fGroup.fieldOrder = Integer.valueOf(pick.Picklist_Order__c);
                String testNameType = config.Test_Name__c;
                if (testNameType.contains(' - ')) {
                    fGroup.fieldTypeOrder = Integer.valueOf(config.Test_Display_Order__c);
                    fGroup.fieldType = testNameType.substringAfterLast(' - ');
                    fGroup.fieldTypeDescription = config.Test_Type_Description__c;
                }
                if (evalFields.get(pick.Field_API_Name__c) != null && String.valueOf(evalFields.get(pick.Field_API_Name__c)).contains(pick.Field_Value__c)) {
                    fGroup.isSelected = true;
                }
                else {
                    fGroup.isSelected = false;
                }
                if (valueMap.containsKey(pick.Field_Value__c)) {
                    valueMap.get(pick.Field_Value__c).fields.add(fGroup);
                    valueMap.get(pick.Field_Value__c).fields.sort();
                }
                else {
                    valueMap.put(pick.Field_Value__c, new ValueGroup(Integer.valueOf(pick.Value_Category__c), Integer.valueOf(pick.Picklist_Order__c), pick.Field_Value__c, pick.Field_Description__c, new List<FieldGroup> {fGroup}));
                }
            }
            if (evaluationMap.containsKey(config.Test_Description__c)) {
                vGroup = valueMap.values();
                vGroup.sort();
                for (ValueGroup v : vGroup) {
                    switch on v.valueCategory {
                        when 0 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup0) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                        when 1 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup1) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                        when 2 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup2) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                        when 3 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup3) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                        when 4 {
                            for (ValueGroup eV : evaluationMap.get(config.Test_Description__c).valueGroup4) {
                                if (v.fieldValue == eV.fieldValue) {
                                    eV.fields.addAll(v.fields);
                                    eV.fields.sort();
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            else {
                vGroup = valueMap.values();
                vGroup.sort();
                List<ValueGroup> vG0 = new List<ValueGroup>();
                List<ValueGroup> vG1 = new List<ValueGroup>();
                List<ValueGroup> vG2 = new List<ValueGroup>();
                List<ValueGroup> vG3 = new List<ValueGroup>();
                List<ValueGroup> vG4 = new List<ValueGroup>();
                for (ValueGroup v : vGroup) {
                    switch on v.valueCategory {
                        when 0 {
                            vG0.add(v);
                        }
                        when 1 {
                            vG1.add(v);
                        }
                        when 2 {
                            vG2.add(v);
                        }
                        when 3 {
                            vG3.add(v);
                        }
                        when 4 {
                            vG4.add(v);
                        }
                    }
                }
                OptionalField opField = new OptionalField();
                if (!String.isBlank(config.Test_Optional_Field__c)) {
                    Object optionalValue = evalFields.get(config.Test_Optional_Field__c);
                    if (optionalValue instanceof Boolean) {
                        opField.selectedValue = getMuzzled((Boolean)optionalValue);
                        opField.availableValues = new List<String>{'Muzzled', 'Not Muzzled'};
                    }
                    else {
                        //picklist
                        opField.selectedValue = (String)optionalValue;
                        opField.availableValues = new List<String>();
                        List<PicklistEntry> optValues = Behavior_Evaluation__c.getSObjectType().getDescribe().fields.getMap().get(config.Test_Optional_Field__c).getDescribe().getPicklistValues();
                        for (PicklistEntry p : optValues) {
                            opField.availableValues.add(p.getLabel());
                        }
                    }
                }
                evaluationMap.put(config.Test_Description__c, new EvaluationGroup(Integer.valueOf(config.Test_Display_Order__c), config.Test_Description__c, config.Test_Header_Description__c, /*config.Test_Type_Description__c, */opField, (String)evalFields.get(config.Test_Skip_Reason_Field__c), (String)evalFields.get(config.Test_Comment_Field_Name__c), vG0, vG1, vG2, vG3, vG4));
            }
        }
        evaluation = evaluationMap.values();
        //sort tab group data
        evaluation.sort();
    }

    public String getMuzzled(Boolean val) {
        if (val) {
            return 'Muzzled';
        }
        else {
            return 'Not Muzzled';
        }
    }

    public class EvaluationGroup implements Comparable {
        public Integer groupOrder { get; set; }
        public String groupValue { get; set; }
        public String headerValue { get; set; }
        public OptionalField optionalValue { get; set; }
        public String skipValue { get; set; }
        public String commentValue { get; set; }
        public List<ValueGroup> valueGroup0 { get; set; }
        public List<ValueGroup> valueGroup1 { get; set; }
        public List<ValueGroup> valueGroup2 { get; set; }
        public List<ValueGroup> valueGroup3 { get; set; }
        public List<ValueGroup> valueGroup4 { get; set; }
        public Boolean hasGroup0 {
            get {
                return this.valueGroup0.size() > 0;
            }
            private set;
        }
        public Boolean hasGroup1 {
            get {
                return this.valueGroup1.size() > 0;
            }
            private set;
        }
        public Boolean hasGroup2 {
            get {
                return this.valueGroup2.size() > 0;
            }
            private set;
        }
        public Boolean hasGroup3 {
            get {
                return this.valueGroup3.size() > 0;
            }
            private set;
        }
        public Boolean hasGroup4 {
            get {
                return this.valueGroup4.size() > 0;
            }
            private set;
        }
        public Boolean hasFieldTypes {
            get {
                if (this.valueGroup1 != null && this.valueGroup1.size() > 0) {
                    if (this.valueGroup1[0].fields != null && this.valueGroup1[0].fields.size() > 0) {
                        return !String.isEmpty(this.valueGroup1[0].fields[0].fieldType);
                    }
                    else {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
            private set;
        }
        public EvaluationGroup() {}
        public EvaluationGroup(Integer groupOrder, String groupValue, String headerValue, OptionalField optionalValue, String skipValue, String commentValue, List<ValueGroup> valueGroup0, List<ValueGroup> valueGroup1, List<ValueGroup> valueGroup2, List<ValueGroup> valueGroup3, List<ValueGroup> valueGroup4) {
            this.groupOrder = groupOrder;
            this.groupValue = groupValue;
            this.headerValue = headerValue;
            this.optionalValue = optionalValue;
            this.skipValue = skipValue;
            this.commentValue = commentValue;
            this.valueGroup0 = valueGroup0;
            this.valueGroup1 = valueGroup1;
            this.valueGroup2 = valueGroup2;
            this.valueGroup3 = valueGroup3;
            this.valueGroup4 = valueGroup4;
        }
        public Integer compareTo(Object compare) {
            EvaluationGroup eval = (EvaluationGroup)compare;
            Integer returnValue = 0;
            if (this.groupOrder > eval.groupOrder) {
                returnValue = 1;
            }
            else if (this.groupOrder < eval.groupOrder) {
                returnValue = -1;
            }
            return returnValue;
        }
    }
    public class OptionalField {
        public String selectedValue { get; set; }
        public List<String> availableValues { get; set; }
        public OptionalField() {}
        public OptionalField(String selectedValue, List<String> availableValues) {
            this.selectedValue = selectedValue;
            this.availableValues = availableValues;
        }
    }
    public class ValueGroup implements Comparable {
        public Integer valueCategory { get; set; }
        public Integer fieldOrder { get; set; }
        public String fieldValue { get; set; }
        public String fieldDescription { get; set; }
        public List<FieldGroup> fields { get; set; }
        public ValueGroup() {}
        public ValueGroup(Integer valueCategory, Integer fieldOrder, String fieldValue, String fieldDescription, List<FieldGroup> fields) {
            this.valueCategory = valueCategory;
            this.fieldOrder = fieldOrder;
            this.fieldValue = fieldValue;
            this.fieldDescription = fieldDescription;
            this.fields = fields;
        }
        public Integer compareTo(Object compare) {
            ValueGroup valGroup = (ValueGroup)compare;
            Integer returnValue = 0;
            if (this.valueCategory > valGroup.valueCategory) {
                returnValue = 1;
            }
            else if (this.valueCategory < valGroup.valueCategory) {
                returnValue = -1;
            }
            else if (this.fieldOrder > valGroup.fieldOrder) {
                returnValue = 1;
            }
            else if (this.fieldOrder < valGroup.fieldOrder) {
                returnValue = -1;
            }
            return returnValue;
        }
    }
    public class FieldGroup implements Comparable {
        public Integer fieldOrder { get; set; }
        public Boolean isSelected { get; set; }
        public Integer fieldTypeOrder { get; set; }
        public String fieldType { get; set; }
        public String fieldTypeDescription { get; set; }
        public FieldGroup() {}
        public FieldGroup(Integer fieldOrder, Boolean isSelected, Integer fieldTypeOrder, String fieldType, String fieldTypeDescription) {
            this.fieldOrder = fieldOrder;
            this.isSelected = isSelected;
            this.fieldTypeOrder = fieldTypeOrder;
            this.fieldType = fieldType;
            this.fieldTypeDescription = fieldTypeDescription;
        }
        public Integer compareTo(Object compare) {
            FieldGroup pick = (FieldGroup)compare;
            Integer returnValue = 0;
            if (this.fieldOrder > pick.fieldOrder) {
                returnValue = 1;
            }
            else if (this.fieldOrder < pick.fieldOrder) {
                returnValue = -1;
            }
            else if (this.fieldTypeOrder > pick.fieldTypeOrder) {
                returnValue = 1;
            }
            else if (this.fieldTypeOrder < pick.fieldTypeOrder) {
                returnValue = -1;
            }
            return returnValue;
        }
    }
}