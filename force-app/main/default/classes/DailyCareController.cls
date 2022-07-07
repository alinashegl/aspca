public with sharing class DailyCareController {
    public static void handleDailyCareSchedular() {
        //get the most recent Daily Care record
        Daily_Care__c odlDailyCare = getDailyCare();

        //if no daily care is returned we do not need to continue
        if(odlDailyCare == null) return;

        //get a map of most recent Animal Daily Care records with animalId as key
        Map<Id, Animal_Daily_Care__c> animalToADCMap = getAnimalDailyCareMap(odlDailyCare.Id);

        //if animal daily care fields have changed - update the parent animal record
        updateAnimals(animalToADCMap.values());

        //create Daily Care record for new day - copying values from most recent Daily Care
        Daily_Care__c newDailyCare = createDailyCare(odlDailyCare);

        //get a list of all active MRC dogs
        Animal__c[] mrcDogs = getActiveMRCDogs();

        //loop through the dogs, create the Animal Daily Care Records and relate them to the newly creatd Daily Care record
        createAnimalDailyCares(newDailyCare.Id, mrcDogs);
    }

    public static Daily_Care__c getDailyCare(){
        Daily_Care__c dc = null;
        Daily_Care__c[] dcList = [
            SELECT Id, AM_Reminders__c, Date__c, General_Reminders__c, PM_Reminders__c, Scent_of_the_Week__c, Special_Projects__c 
            FROM Daily_Care__c
            ORDER BY Date__c DESC 
            LIMIT 1
        ];

        //make sure we aren't creating a duplicate if one already exists for tomorrow
        if(!dcList.isEmpty()){
            if(dcList[0].Date__c < Date.today().addDays(1)){
                dc = dcList[0];
            }
        }
        return dc;
    }

    public static Map<Id, Animal_Daily_Care__c> getAnimalDailyCareMap(Id dailyCareId){
        Map<Id, Animal_Daily_Care__c> animalDailyCareMap = new Map<Id, Animal_Daily_Care__c>();
        for(Animal_Daily_Care__c adc : getAnimalDailyCares(dailyCareId)){
            animalDailyCareMap.put(adc.Animal__c, adc);
        }

        return animalDailyCareMap;
    }

    public static Animal_Daily_Care__c[] getAnimalDailyCares(Id dailyCareId){
        //need to come back to this to add corresponding animal fields
        return [
            SELECT Id, Handling_Instructions__c, Movements_For_Cleaning__c, Special_Care_Other__c, Special_Care_Outside_TX__c, Special_Care_TX__c, Animal__c, Animal__r.Handling_Instructions__c
            FROM Animal_Daily_Care__c
            WHERE Daily_Care__c =: dailyCareId
        ];
    }

    public static void updateAnimals(Animal_Daily_Care__c[] adcs){
        if(adcs == null) return;
        Animal__c[] animalsToUpdate =  new Animal__c[0];
        for(Animal_Daily_Care__c adc : adcs){
            if(adc.Handling_Instructions__c != adc.Animal__r.Handling_Instructions__c){
                animalsToUpdate.add(new Animal__c(
                    Id = adc.Animal__c,
                    Handling_Instructions__c = adc.Handling_Instructions__c
                ));
            }
            //todo: check if the fields are different and update the animals that need it
        }

        if(!animalsToUpdate.isEmpty()){
            update animalsToUpdate;
        }
    }

    public static Daily_Care__c createDailyCare(Daily_Care__c oldDC){
        if(oldDC == null) return null;
        Daily_Care__c dc = oldDc.clone(false, true, false, false);
        Date today = Date.today();
        Date dcDate = oldDc.Date__c == today ? today.addDays(1) : today;
        dc.Date__c = dcDate;

        //if dcDate day of the week is a Tuesday we need to cycle through the scents of the week
        if(AutoScheduleTasksUtil.getDayOfWeek(dcDate) == 'Tuesday'){
            dc.Scent_of_the_Week__c = getScentOfWeek(dc.Scent_of_the_Week__c);
        }

        insert dc;
        return dc;
    }

    public static String getScentOfWeek(String currentScent){
        Integer index = 0;
        String[] scentValues = SchemaHelper.GetPicklistValues(SchemaHelper.DetermineSObjectFieldByLabel('Daily_Care__c', 'Scent of the Week'));
        if(scentValues.contains(currentScent)){
            Integer currentIndex = scentValues.indexOf(currentScent);
            if((currentIndex + 1) < scentValues.size()){
                index = currentIndex +1;
            }
        }
        return scentValues[index];
    }

    public static Animal__c[] getActiveMRCDogs(){
        return [
            SELECT Id, Handling_Instructions__c,
                (SELECT Id, Round__c, Special_Care_Other__c, Special_Care_Outside_TX__c, Special_Care_TX__c, Movements_For_Cleaning__c FROM Animals_Daily_Care__r ORDER BY CreatedDate DESC LIMIT 1)
            FROM Animal__c
            WHERE Current_Location__c = 'MRC' AND Final_Outcome__c = null
        ];
    }

    public static void createAnimalDailyCares(Id dailyCareId, Animal__c[] animals){
        Animal_Daily_Care__c[] adcs = new Animal_Daily_Care__c[0];
        for(Animal__c dog : animals){
            Animal_Daily_Care__c oldADC = !dog.Animals_Daily_Care__r.isEmpty() ? dog.Animals_Daily_Care__r[0] : null;
            adcs.add(new Animal_Daily_Care__c(
                Daily_Care__c = dailyCareId,
                Animal__c = dog.Id,
                Handling_Instructions__c = dog.Handling_Instructions__c,
                Round__c = oldADC == null ? '1' : oldADC.Round__c,
                Special_Care_Other__c = oldADC == null ? null : oldADC.Special_Care_Other__c,
                Special_Care_Outside_TX__c = oldADC == null ? 'Dry' : oldADC.Special_Care_Outside_TX__c,
                Special_Care_TX__c = oldADC == null ? 'Dry + Wet' : oldADC.Special_Care_TX__c,
                Movements_For_Cleaning__c = oldADC == null ? null : oldADC.Movements_For_Cleaning__c
            ));
        }

        if(!adcs.isEmpty()){
            insert adcs;
        }
    }
}