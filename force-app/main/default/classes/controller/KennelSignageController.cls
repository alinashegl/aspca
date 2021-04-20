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

        m_animalName();
        m_animalId();
        m_animalSex();
        m_animalColor();
        m_animalBreed();
        m_animalAge();
        m_VolunteerReadingOkay();
        //iBehaviorConcerns();


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

    public String m_animalName(){
        String defaultName = 'Default';

        animalName = currentAnimal.Animal_Name__c;

        if (animalName == null) {
            animalName = defaultName;
        }
        return animalName;
    }

    public String m_animalId() {
        String defaultId = '123456';

        animalId = currentAnimal.Animal_Field_ID__c;
        if (animalId == null) {
            animalId = defaultId;
        }
        return animalId;
    }

    public String m_animalBreed() {
         String defaultBreed = 'Dog';

        animalBreed = currentAnimal.Breed__c;
        if (animalBreed == null) {
            animalBreed = defaultBreed;
        }
        return animalBreed;
    }

    public String m_animalAge() {
        String defaultAge = 'Unkown';

        animalAge = currentAnimal.Age__c;
        if (animalAge == null) { animalAge = defaultAge ;}
        return animalAge;
    }

    public String m_animalSex() {
        String defaultSex = 'M';

        animalSex = currentAnimal.Gender__c;
        if (animalSex == null) { animalSex = defaultSex ;}
        return animalSex;
    }

    public String m_animalColor() {
        String defaultColor = 'Brown';

        animalColor = currentAnimal.Color__c;
        if (animalColor == null ) { animalColor = defaultColor ; }
        return animalColor;
    }



    /******************************************************************************************************************/
    /**********************  Body Properties **************************************************************************/
    /******************************************************************************************************************/

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
        String[] values = currentAnimal.Behavior_Concerns__c.split(';');
        System.debug('*******************Picklist Values*************' + values);
        for (PicklistEntry entry : entries) {
            String label = entry.label;
            Boolean isSelected = false;
            if (values.contains(entry.label) && !values.isEmpty()) {
                isSelected = true;
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
        String[] values = currentAnimal.Walking_Equipment__c.split(';');
        for (PicklistEntry entry : entries) {
            String label = entry.label;
            Boolean isSelected = false;
            if (values.contains(entry.label)  && !values.isEmpty()) {
                isSelected = true;
            }
            System.debug('Walking Equipment -> ' + entry);
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
        String[] values = currentAnimal.Walking_Status__c.split(';');
        for (PicklistEntry entry : entries) {
            String label = entry.label;
            Boolean isSelected = false;
            if (values.contains(entry.label) && !values.isEmpty()) {
                isSelected = true;
            }
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