Public class ListofInvoicesController {
    Public List<Invoice__c> invoiceList {get;set;}
    Public Invoice__c invoice{get;set;}
    Public Invoice__c invoiceOnSave{get;set;}
    Public Boolean displayPopup{get;set;}
    Public Boolean boolVar=true;
    
    Public  ListofInvoicesController(ApexPages.StandardController controller){
        
        invoiceList = [Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Order By Name ];
        system.debug('INVLst=='+invoiceList);
    }
    
    Public void showPopup()
    {
        displayPopup = true;
        invoiceOnSave = new Invoice__c();
    }
    
    Public void closePopup() {
        displayPopup = false;
    }
    
    Public PageReference invoiceDetailClose() {
        return page.ListOfInvoices_VF;
    }
    
    Public void saveInvoice(){
        displayPopup = false;
        Upsert InvoiceOnSave;
        //invoiceList.add(InvoiceOnSave);
        invoiceList = [Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c ];
    }
    Public void editAction() {
        string recordid=Apexpages.currentpage().getparameters().get('idToEdit');
        invoiceOnSave = new Invoice__c();
        invoiceOnSave = [Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Where id=:recordid Order By Name ];
        displayPopup = true;
    }
    Public void deleteAction() {
       string recordid=Apexpages.currentpage().getparameters().get('idToDel');
        invoice=[Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Where id=:recordid Order By Name];
        if(invoice !=null){
            delete invoice;
        }
        invoiceList = [Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c ];
    }
    
    Public PageReference openNewViewPage() {
        string recordid=Apexpages.currentpage().getparameters().get('pagee');
        invoice=[Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Where id=:recordid Order By Name];
        Return page.Invoice_New_View_Page;
    }
    
    Public Void sortAscDesc(){
        
        if(boolVar==true)
        {
            //String query = 'Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY Name DESC';
            //invoiceList = database.query(query);
            invoiceList = [SELECT id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY Name DESC];
            boolVar=false;
        }
        else
        {
            invoiceList = [SELECT id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY Name ASC];
            boolVar=true;
        }
    }
}
