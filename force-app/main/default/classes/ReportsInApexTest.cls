@isTest
public class ReportsInApexTest{

    @isTest(SeeAllData='true')
    public static void testAsyncReportWithTestData() {

        
        ReportController medReport = new ReportController (); 
        
        List<SelectOption> testRep_options = medReport.getReps();     
        List<SelectOption> testOptions = medReport.getItems();
        
      	MedReport.setFreq('AM');
        
        Id testId = testRep_options[0].getValue();
        System.debug(testId);
        
        medReport.setReportId(testId);
        
        System.debug(medReport.getFreq());
        System.debug(medReport.getReportId());     
                
        System.debug(medReport.reportList);
		System.debug(medReport.labels);
        System.debug(medReport.label);
        System.debug(medReport.l1);
        System.debug(medReport.l2);
        System.debug(medReport.l3);
        System.debug(medReport.fLabel);
        System.debug(medReport.reportId2);
        System.debug(medReport.reportResults);
        
        
/*      List <Report> reportList = [SELECT Id,DeveloperName,Name FROM Report WHERE OwnerId IN (SELECT Id FROM Folder WHERE DeveloperName = 'Medicine_Labels')];  
      String reportId = (String)reportList.get(0).get('Id');
      
      // Create a Case object.
      Case cs = new Case();
      insert cs;
        
      // Create an Animal object.
      Animal__c anim = new Animal__c(Name='Test', Case__c=cs.Id);
      insert anim;*/
        

        
    
/*      Reports.ReportMetadata reportMetadata = Reports.ReportManager.describeReport(reportId).getReportMetadata();
      
      // Add a filter.
        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
        Reports.ReportMetadata reportMd = describe.getReportMetadata();        
        Reports.ReportFilter filter = reportMd.getReportFilters()[0];
        filter.SetValue('SID,BID,TID');
      
      Test.startTest();
       
      Reports.ReportInstance instanceObj = Reports.ReportManager.runAsyncReport(reportId,reportMetadata,false);
      String instanceId = instanceObj.getId();
      
      // Report instance is not available yet.
      Test.stopTest();
      // After the stopTest method, the report has finished executing
      // and the instance is available.
     
      instanceObj = Reports.ReportManager.getReportInstance(instanceId);
      System.assertEquals(instanceObj.getStatus(),'Success');
      Reports.ReportResults result = instanceObj.getReportResults();
      Reports.ReportFact grandTotal = (Reports.ReportFact)result.getFactMap().get('T!T');
//      System.assertEquals(1,(Decimal)grandTotal.getAggregates().get(1).getValue());*/
    }
}