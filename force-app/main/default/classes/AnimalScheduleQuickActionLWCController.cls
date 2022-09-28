public with sharing class AnimalScheduleQuickActionLWCController {
    @AuraEnabled
    public static String recreateTasks(Id animalId, Date startDate, Date endDate){
        if(animalId != null && startDate != null && endDate != null){
            try {
                AutoScheduleController.deleteFutureTasks(new Id[]{animalId}, startDate, endDate);
                AutoScheduleController.handleScheduleTasks(new Id[]{animalId}, startDate, endDate);
                return 'success';
            } catch (Exception e) {
                System.debug('stackTrace: ' + e.getStackTraceString());
                throw new AuraHandledException(e.getMessage());
            }
        } else {
            AuraHandledException e = new AuraHandledException('Animal Id not found, or no startDate or endDate');
            e.setMessage('Animal Id not found, or no startDate or endDate');
            throw e;
        }
    }

    @AuraEnabled
    public static Map<String, autoScheduleTasksUtil.DateRangeWrapper> getDateRange(){
        try {
            return AutoScheduleTasksUtil.dateRanges;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}