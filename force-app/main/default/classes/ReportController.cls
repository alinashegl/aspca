public without sharing class ReportController {
    public List<Report> ReportTemp = new List<Report>();
    public Id reportId {get; set;}
    public String freq {get; set;}
    public List<Report> reportList {get;set;}
    public List<String> labels {get;set;}
    public List<String> label {get;set;}
    public list<String> l1 {get; set;}
    public list<String> l2 {get; set;}
    public list<String> l3 {get; set;}
    public String fLabel {get;set;}
    public Id reportId2 { get; set; }
    public Reports.ReportResults reportResults {get;set;}
    public ReportController(){}

    public PageReference genReport(){
        // Run report
        // Call pdf-render page
        runReport(); PageReference pr = new PageReference('/apex/MedicineLabel'); return pr;
    }
    
    public void runReport(){
        // Capture ID from dropdown selection
        // Set filter to 'Frequency Of Treatment'
        String reportId2 = (String)reportId; Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId2); Reports.ReportMetadata reportMd = describe.getReportMetadata(); Reports.ReportFilter filter = reportMd.getReportFilters()[0];
        
        // Filter based on 'Time of day' selection
		if (freq == 'AM'){ filter.SetValue('SID,BID,TID'); } if (freq == 'Midday'){ filter.SetValue('TID'); } if (freq == 'PM'){ filter.SetValue('BID, TID'); }
         
        // Run report
        // Store report data
        reportResults = Reports.ReportManager.runReport(reportId2, reportMD, true); Reports.ReportFactWithDetails factWithDetails = (Reports.ReportFactWithDetails) reportResults.getFactMap().get('T!T');

        labels = new List<String>();  
        for (Reports.ReportDetailRow row : factWithDetails.getRows()) { label = new List<String>();  
            // Add each cell value to an individual label list
            for (Reports.ReportDataCell cell : row.getDataCells()) { label.add(cell.getLabel()); } fLabel = string.join(label,' '); labels.add(fLabel);
            // Convert each "label" to a string and add to overall list
        } 
        
        // Separate entire label list across three columns
        Integer num = 0; l1 = new List<String>(); l2 = new List<String>(); l3 = new List<String>(); 
        for (String lab : labels){ if (math.mod(num,3) == 0){l1.add(lab);} if (math.mod(num,3) == 1){l2.add(lab);} if (math.mod(num,3) == 2){l3.add(lab);} num++; }
    }
    
    
    
    public List<SelectOption> getReps(){
        // Create list of reports from "Medicine Labels" report folder
        List<SelectOption> rep_options = new List<SelectOption>();
        ReportTemp = [SELECT Id,DeveloperName,Name FROM Report WHERE OwnerId IN (SELECT Id FROM Folder WHERE DeveloperName = 'Medicine_Labels')];       
        for(Report temp : ReportTemp)
        {
            rep_options.add(new SelectOption(temp.Id, temp.Name));
        }
        return rep_options;
    }
    
    public Id getReportId(){
        return reportId;
    }
    
    public void setReportId(Id reportId){
        this.reportId = reportId;
    }    
 
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('AM','AM'));
        options.add(new SelectOption('Midday','Midday'));
        options.add(new SelectOption('PM','PM'));
        return options;
    }
    
    public String getFreq(){
        return freq;
    }
    
    public void setFreq(String freq){
        this.freq = freq;
    }
    

}