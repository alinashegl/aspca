/**
 * Created by barne on 4/16/2021.
 */

public with sharing class DataDisplayController {
    public String PDFDData { get; set; }

    public DataDisplayController() {
        PDFDData = '';
    }

    public PageReference downloadPDF() {
        PageReference pageReference = new PageReference('/apex/PDFGenerator');

        pageReference.getHeaders().put('content-disposition', 'attachment; filename=TestPDF.pdf');

        return pageReference;
    }

}