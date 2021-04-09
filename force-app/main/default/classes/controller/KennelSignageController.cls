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
        iBehaviorConcernOptions();
        iBehaviorConcerns();

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

    public List<SelectOption> behaviorConcerns { get; set; }
    public List<String> behaviorConcernOptions { get; set; }

    public List<SelectOption> iBehaviorConcerns() {
        Schema.DescribeFieldResult fieldResult = Animal__c.Behavior_Concerns__c.getDescribe();
        List<PicklistEntry> options = fieldResult.getPicklistValues();

        ControllerHelper controllerHelper = new ControllerHelper();

        behaviorConcerns = controllerHelper.getPicklist(options);

        return behaviorConcerns;
    }

    public List<String> iBehaviorConcernOptions() {
        Schema.DescribeFieldResult fieldResult = Animal__c.Behavior_Concerns__c.getDescribe();
        List<PicklistEntry> options = fieldResult.getPicklistValues();

        ControllerHelper controllerHelper = new ControllerHelper();

        behaviorConcernOptions = controllerHelper.getOptions(options);

        return behaviorConcernOptions;
    }

    public List<SelectOption> iwalkingEquipment() {
        return null;
    }

    public List<SelectOption> iwalkingStatus() {
        return null;
    }

    public List<SelectOption> ivolunteerLevel() {
        return null;
    }

    public List<SelectOption> itrainingProtocols() {
        return null;
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