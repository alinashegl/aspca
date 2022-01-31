public with sharing class AnimalScheduleQuickActionLWCController {
    @AuraEnabled
    public static String recreateTasks(Id animalId){
        if(animalId != null){
            try {
                AutoScheduleController.deleteFutureTasks(new Id[]{animalId}, AutoScheduleTasksUtil.dateRanges.startDate);
                AutoScheduleController.handleScheduleTasks(new Id[]{animalId});
                return 'success';
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        } else {
            AuraHandledException e = new AuraHandledException('Animal Id not found');
            e.setMessage('Animal Id not found');
            throw e;
        }
    }

    @AuraEnabled
    public static autoScheduleTasksUtil.DateRangeWrapper getDateRange(){
        try {
            return AutoScheduleTasksUtil.dateRanges;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
