@isTest
public class DateTimeUtilityTest {
    @isTest
    static void testDateMethods(){
        DateTimeUtility.Request request = new DateTimeUtility.Request();
        request.dateTimeString = '1/6/2022 8:21 AM';
        request.days = 4;
        request.requestType = 'datetime';
        
        List<DateTimeUtility.Response> response = DateTimeUtility.getDate(new List<DateTimeUtility.Request> {request});
        System.assertEquals(response[0].resultDate.format(), '1/12/2022');
        System.assertEquals(true, response[0].isSuccess);
    }    
    
    @isTest
    static void testDateTimeMethods(){
        DateTimeUtility.AddBusinessDays(System.now(), 1);
        DateTimeUtility.Request request = new DateTimeUtility.Request();
        request.dateTimeString = '1/7/2022';
        request.days = 4;
        request.requestType = 'date';
        
        List<DateTimeUtility.Response> response = DateTimeUtility.getDate(new List<DateTimeUtility.Request> {request});
        System.assertEquals(response[0].resultDate.format(), '1/13/2022');
        System.assertEquals(true, response[0].isSuccess);
    }

    @isTest
    static void testExceptions(){
        List<DateTimeUtility.Response> response = new List<DateTimeUtility.Response>();
        DateTimeUtility.Request request = new DateTimeUtility.Request();
        request.dateTimeString = 'invaliddate';
        request.days = 4;
        request.requestType = 'date';
        
        response = DateTimeUtility.getDate(new List<DateTimeUtility.Request> {request});
        System.assertEquals(false, response[0].isSuccess);
        
        request.dateTimeString = 'invdate';
        request.days = 4;
        request.requestType = 'datetime';
        
        response = DateTimeUtility.getDate(new List<DateTimeUtility.Request> {request});
        System.assertEquals(false, response[0].isSuccess);
        
        request.dateTimeString = '1/13/2022';
        request.days = 4;
        request.requestType = 'text';
        
        response = DateTimeUtility.getDate(new List<DateTimeUtility.Request> {request});
        System.assertEquals(false, response[0].isSuccess);
        
        request.dateTimeString = null;
        request.days = 4;
        request.requestType = 'text';
        
        response = DateTimeUtility.getDate(new List<DateTimeUtility.Request> {request});
        System.assertEquals(false, response[0].isSuccess);
    }
}