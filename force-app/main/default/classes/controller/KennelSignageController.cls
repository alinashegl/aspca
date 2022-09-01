/**
 * Created by barne on 4/6/2021.
 */
public with sharing class KennelSignageController {

    public Animal__c currentAnimal;
    public Animal__c animal { get; set; }
    public List<String> variables;

    /******************************************************************************************************************/
    /**************     PDF Generator and Basic Controller methods ****************************************************/
    /******************************************************************************************************************/

    public KennelSignageController()
    {
        dao_Animal daoAnimal = new dao_Animal();
        //PageReference page = new PageReference('/apex/KennelSignage');
        PageReference page = ApexPages.currentPage();
        System.debug('######Current Page   =' + page);

        currentAnimal = daoAnimal.findOne(page.getParameters().get('id'));
        System.debug('### Value of current animal  ' + currentAnimal);

        if(currentAnimal != null){
        m_animalName();
        m_animalId();
//        m_animalPetpointId();
        m_animalSex();
        m_animalColor();
        m_animalBreed();
        m_animalAge();
        m_VolunteerReadingOkay();
        m_animalBehSumm();
        //iBehaviorConcerns();
        }


    }




    /****************************************************************************************************************/
    /************************ Basic Animal Info *********************************************************************/
    /****************************************************************************************************************/

    public String animalName {get; set; }
    public String animalId { get; set; }
    public String animalBreed { get; set;}
    public String animalAge {get; set; }
    public String animalSex { get; set; }
    public String animalColor { get; set; }
    public String animalBehSumm { get; set; }

    public String m_animalName(){
        String defaultName = '';

        animalName = currentAnimal.Animal_Name__c;

        if (animalName == null) {
            animalName = defaultName;
        }
        return animalName;
    }

    public String m_animalId() {
        String defaultId = '';

        animalId = currentAnimal.Name;
        if (animalId == null) {
            animalId = defaultId;
        }
        return animalId;
    }

    public String m_animalBreed() {
         String defaultBreed = '';

        animalBreed = currentAnimal.Breed__c;
        if (animalBreed == null) {
            animalBreed = defaultBreed;
        }
        return animalBreed;
    }

    public String m_animalAge() {
        String defaultAge = '';

        animalAge = currentAnimal.Current_Animal_Age_Formatted__c;
        if (animalAge == null) { animalAge = defaultAge ;}
        return animalAge;
    }

    public String m_animalSex() {
        String defaultSex = '';

        animalSex = currentAnimal.Gender__c;
        if (animalSex == null) { animalSex = defaultSex ;}
        return animalSex;
    }

    public String m_animalColor() {
        String defaultColor = '';

        animalColor = currentAnimal.Color__c;
        if (animalColor == null ) { animalColor = defaultColor ; }
        return animalColor;
    }

    public String m_animalBehSumm() {
        String defaultBehSumm = '';

        animalBehSumm = currentAnimal.Behavior_Summary__c;
        if (animalBehSumm == null ) { animalBehSumm = defaultBehSumm ; }
        return animalBehSumm;
    }


    /******************************************************************************************************************/
    /**********************  Body Properties **************************************************************************/
    /******************************************************************************************************************/

    public String defaultPicklst = 'None Specified';
    //public String[] values = (String[]) '';
    public class behaviorConcern {
        public String value { get; set; }
        public Boolean isSelected { get; set; }


        public behaviorConcern(String value, Boolean isSelected) {
            this.value = value;
            this.isSelected = isSelected;
        }
    }
    List<behaviorConcern> behaviorConcerns { get; set; }
    public List<behaviorConcern> getBehaviorConcerns() {
        behaviorConcerns = new List<KennelSignageController.behaviorConcern>();
        DescribeFieldResult fieldResult = Animal__c.Behavior_Concerns__c.getDescribe();
        List< PicklistEntry> entries = fieldResult.getPicklistValues();
        String value = '';
        if (!String.isEmpty(currentAnimal.Behavior_Concerns__c)) { value = currentAnimal.Behavior_Concerns__c; }
        List<String> values = (List<String>) value.split(';');
        System.debug('*******************Picklist Values*************' + values);
        for (PicklistEntry entry : entries) {
            String label = entry.label;
            Boolean isSelected = false;
            if (!values.isEmpty()) {
                if(values.contains(entry.label)) {
                    isSelected = true;
                }
            }
            behaviorConcerns.add(new behaviorConcern(label, isSelected));
            System.debug('Entry isActive value =====> ' + isSelected);
        }
        return behaviorConcerns;
    }
    public PageReference showBC() {
        for (behaviorConcern concerns : behaviorConcerns) {
            System.debug(concerns.value + '========>' + concerns.isSelected);
        }
        return null;
    }

    public class walkingEquipment {
        public String value { get; set; }
        public Boolean isSelected { get; set; }


        public walkingEquipment(String value, Boolean isSelected) {
            this.value = value;
            this.isSelected = isSelected;
        }
    }

    public List<walkingEquipment> walkingEquipments { get; set; }
    public List<walkingEquipment> getWalkingEquipment() {
        walkingEquipments = new List<KennelSignageController.walkingEquipment>();
        DescribeFieldResult fieldResult = Animal__c.Walking_Equipment__c.getDescribe();
        List< PicklistEntry> entries = fieldResult.getPicklistValues();
        String value = '';
        if (!String.isEmpty(currentAnimal.Walking_Equipment__c)) { value = currentAnimal.Walking_Equipment__c; }
        List<String> values = (List<String>) value.split(';');
        //System.debug('Walking Equipment Selected Values ======> ' + values);
        for (PicklistEntry entry : entries) {
            String label = entry.label;
            Boolean isSelected = false;
            if (!values.isEmpty()) {
                if(values.contains(entry.label)) {
                    isSelected = true;
                }
            }
            //System.debug('Walking Equipment -> ' + entry);
            walkingEquipments.add(new walkingEquipment(label, isSelected));
        }
        return walkingEquipments;
    }
    public PageReference showWE() {
        for (walkingEquipment equipment : walkingEquipments) {
            System.debug(equipment.value + '=======>' + equipment.isSelected);
        }
        return null;
    }

    public class walkingStatus {
        public String value { get; set; }
        public Boolean isSelected { get; set; }


        public walkingStatus(String value, Boolean isSelected) {
            this.value = value;
            this.isSelected = isSelected;
        }
    }

    public List<walkingStatus> walkingStatuses { get; set; }
    public List<walkingStatus> getWalkingStatus() {
        walkingStatuses = new List<KennelSignageController.walkingStatus>();
        DescribeFieldResult fieldResult = Animal__c.Walking_Status__c.getDescribe();
        List< PicklistEntry> entries = fieldResult.getPicklistValues();
        String value = '';
        if (!String.isEmpty(currentAnimal.Walking_Status__c)) { value = currentAnimal.Walking_Status__c; }
        List<String> values = (List<String>) value.split(';');

        for (PicklistEntry entry : entries) {
            String label = entry.label;
            Boolean isSelected = false;
            if (!values.isEmpty()) {
                if(values.contains(entry.label)) {
                    isSelected = true;
                }
            }
            System.debug('Walking Status -> ' + entry);
            walkingStatuses.add(new walkingStatus(label, isSelected));
        }
        return walkingStatuses;
    }
    public PageReference showWS() {
        for (walkingStatus status : walkingStatuses) {
            System.debug(status.value + '=======>' + status.isSelected);
        }
        return null;
    }

    public Boolean volunteerReadingOkay{ get; set; }
    public Boolean m_VolunteerReadingOkay() {
        Boolean level = currentAnimal.Volunteer_Reading_Okay__c;
        volunteerReadingOkay = level;
        return volunteerReadingOkay;
    }

    /******************************************************************************************************/
    /*******  Evaluation Property *************************************************************************/
    /******************************************************************************************************/

    public String evaluation() {
        return null;
    }

    /******************************************************************************************************************/
    /**************** PRIVATE METHODS *********************************************************************************/
    /******************************************************************************************************************/



}