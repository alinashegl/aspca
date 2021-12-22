public with sharing class ScheduleBoardAndTrainTask {
    public static Id recordTypeId = Util.getRecordTypeId('Task',AutoScheduleTasksUtil.BOARD_AND_TRAIN_RECORD_TYPE_NAME);
    public static Task[] scheduleFollowUps() {
        Task[] bntTasks = new Task[0];
        Map<String, Calendar_Schedule_Config__mdt> calendarConfigMap = AutoScheduleTasksUtil.getCalendarConfig('Board And Train');
        Calendar_Schedule_Config__mdt defaultConfig = calendarConfigMap.get('Board And Train All-Weekly');



        return null;
    }
}
