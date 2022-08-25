Public class ListofInvoicesController {
    Public List<Invoice__c> invoiceList {get;set;}
    Public Invoice__c invoice{get;set;}
    Public Invoice__c invoiceOnSave{get;set;}
    public static List<Invoice__c> accountInvoices;
    Public Boolean displayPopup{get;set;}
    Public Boolean arrowUp{get;set;}
    Public Boolean arrowDown{get;set;}
    Public Boolean boolVar=true;
    Public String sortField{get;set;}
    Public static Integer paidCount{get;set;}
    Public static Integer dueCount{get;set;}
    Public static List<Invoice__c> overdueCount{get;set;}
    Public static List<AggregateResult> totalSum{get;set;}
    
    Public  ListofInvoicesController(ApexPages.StandardController controller){
        system.debug('sortfield in constructor==='+sortField);
        invoiceList = [Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Order By Name ];
        system.debug('INVLst=='+invoiceList);
        arrowUp=true;
        arrowDown=false;
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
        return page.ListOfInvoicesvf;
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
        invoice=[Select id from Invoice__c Where id=:recordid];
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
    
    @AuraEnabled(cacheable=true)
    public static List<Invoice__c> getAllInvoices(String AccountId) {
        accountInvoices=[Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c where Account__c=:AccountId Order By Name];
        System.debug('accountInvoices== '+accountInvoices);
        return accountInvoices;
    }
    @AuraEnabled(cacheable=true)
    public static Integer paidInvoices(String AccountId) {
         System.debug('paidInvoices entered');
        paidCount=[SELECT COUNT() FROM Invoice__c WHERE Status__c='Paid' and Account__c=:AccountId];
        System.debug('PaidCount== '+paidCount);
        return paidCount;
    }
    @AuraEnabled(cacheable=true)
    public static Integer currentDueInvoices(String AccountId) {
         System.debug('paidInvoices entered');
        dueCount=[SELECT COUNT() FROM Invoice__c WHERE Status__c='Due' and Account__c=:AccountId];
        System.debug('dueCount== '+dueCount);
        return dueCount;
    }
    @AuraEnabled(cacheable=true)
    public static List<Invoice__c> overdueInvoices(String AccountId) {
        //overdueCount=[SELECT COUNT() FROM Invoice__c WHERE Status__c='Overdue' and Account__c=:AccountId];
        overdueCount=[SELECT Id,Name,Days_Overdue__c,Status__c FROM Invoice__c WHERE Status__c='Overdue' and Account__c=:AccountId];
        System.debug('overdueCount== '+overdueCount);
        return overdueCount;
    }
    @AuraEnabled(cacheable=true)
    public static Integer totalReceivablesInvoices(String AccountId) {
        totalSum=[SELECT SUM(Amount_Due__c) sum FROM Invoice__c WHERE Account__c=:AccountId];
        System.debug('totalSum== '+totalSum);
        Integer totalValue = Integer.valueOf(totalSum[0].get('sum'));
        return totalValue;
    }
    Public Void sortAscDesc(){
        
        if(boolVar==true)
        {
            String query = 'Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY ' +sortField+ ' DESC';
            //invoiceList = database.query(query);
            system.debug('sortfield==== '+sortField);
            system.debug('invoiceList in sortascdsce==== '+invoiceList);
            invoiceList = [SELECT id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY Name DESC];
            boolVar=false;
            arrowDown=true;
            arrowUp=false;
            
        }
        else
        {	
            String query = 'Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY '+sortField+' ASC';
			//invoiceList = database.query(query);
            system.debug('invoiceList in sortascdsce==== '+invoiceList);
            invoiceList = [SELECT id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY Name ASC];
            boolVar=true;
            arrowDown=false;
            arrowUp=true;
        }
    }
    
}
