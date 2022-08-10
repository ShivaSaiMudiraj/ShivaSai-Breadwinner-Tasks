Public class ListofInvoicesController {
    Public List<Invoice__c> invoiceList {get;set;}
    Public Invoice__c invoice{get;set;}
    Public Invoice__c invoiceOnSave{get;set;}
    Public Boolean displayPopup{get;set;}
    
    Public  ListofInvoicesController(ApexPages.StandardController controller){
        invoiceOnSave = new Invoice__c();
        invoiceList = [Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Order By Name ];
        system.debug('INVLst=='+invoiceList);
    }
    
    Public void showPopup()
    {
        displayPopup = true;
    }
    
    Public void closePopup() {
        displayPopup = false;
    }
    
    Public void saveInvoice(){
        displayPopup = false;
        Insert InvoiceOnSave;
        //invoiceList.add(InvoiceOnSave);
        invoiceList = [Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c ];
    }
    
    Public PageReference openNewViewPage() {
        string recordid=Apexpages.currentpage().getparameters().get('pagee');
        invoice=[Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Where id=:recordid Order By Name];
        Return page.Invoice_New_View_Page;
    }
}
