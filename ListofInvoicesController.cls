Public class ListofInvoicesController {
    Public List<Invoice__c> invoiceList {get;set;}
    Public Invoice__c invoice{get;set;}
    Public Invoice__c invoiceOnSave{get;set;}
    Public Boolean displayPopup{get;set;}
    Public Boolean arrowUp{get;set;}
    Public Boolean arrowDown{get;set;}
    Public Boolean boolVar=true;
    Public String sortField{get;set;}
    Public static Integer paidCount{get;set;}
    Public static Integer dueCount{get;set;}
    Public static Integer overdueList{get;set;}
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
        invoiceList = [Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Order By Name  ];
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
        invoiceList = [Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Order By Name];
    }
    
    Public PageReference openNewViewPage() {
        string recordid=Apexpages.currentpage().getparameters().get('pagee');
        invoice=[Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c Where id=:recordid Order By Name];
        Return page.Invoice_New_View_Page;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Invoice__c> getAllInvoices(String AccountId, String field, String sortOrder) {
        String query;
        query = 'Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  from Invoice__c where Account__c=:AccountId';
        if(field != null && sortOrder !=null){
            query += ' ORDER BY '+field+' '+sortOrder;
        }
        return Database.query(query);
    }
    
    Public Void sortAscDesc(){
        
        if(boolVar==true)
        {
            //String query = 'Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY ' +sortField+ ' DESC';
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
            //String query = 'Select id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY '+sortField+' ASC';
            //invoiceList = database.query(query);
            system.debug('invoiceList in sortascdsce==== '+invoiceList);
            invoiceList = [SELECT id,Name,Account__r.Name, Days_Overdue__c, Due_Date__c, Invoice_Date__c, Amount_Paid__c, Amount_Due__c, Status__c,Total__c  FROM Invoice__c ORDER BY Name ASC];
            boolVar=true;
            arrowDown=false;
            arrowUp=true;
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<DataSet> getAllOverdues(String AccountId){
        List<Invoice__c> overdueResult = [Select Days_Overdue__c from Invoice__c where status__c = 'Overdue' AND Account__c=:AccountId ];
        List<DataSet> dataSet = new List<DataSet>();
        
        String status1to30 = '1 - 30', status31to60 = '31 - 60', status61to90 = '61 - 90', status90 = '90+', totalOverdueStatus = 'Total Overdue' ;
        Integer total1to30 = 0, total31to60 = 0,total61to90 = 0,total90 = 0,totalOverdue = 0 ;
        for(Invoice__c eachOverdue:overdueResult)
        {
            if(eachOverdue.Days_Overdue__c>=1 && eachOverdue.Days_Overdue__c<=30)
            {
                total1to30  = total1to30 + 1;
                system.debug('total1to30===' + total1to30);               
            }
            if(eachOverdue.Days_Overdue__c>=31 && eachOverdue.Days_Overdue__c<=60)
            {
                total31to60  = total31to60 + 1;
                system.debug('total31to60===' + total31to60);               
            }
            if(eachOverdue.Days_Overdue__c>=61 && eachOverdue.Days_Overdue__c<=90)
            {
                total61to90  = total61to90 + 1;
                system.debug('total61to90===' + total61to90);               
            }
            if(eachOverdue.Days_Overdue__c>=90)
            {
                total90  = total90 + 1;
                system.debug('total90' + total90);               
            } 
        }
        
        dataSet.add(new DataSet(status1to30 ,total1to30));
        dataSet.add(new DataSet(status31to60 ,total31to60));
        dataSet.add(new DataSet(status61to90 ,total61to90));
        dataSet.add(new DataSet(status90 ,total90));
        System.debug('dataSet==='+dataSet);
        return dataSet ;
    }
    public class DataSet
    {
        public DataSet(String label ,Integer count)
        {
            this.label  = label ;
            this.count = count ;
        }
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public Integer  count {get;set;}
    }
    
    @AuraEnabled(cacheable=true)
    public static wrapperClassInvoices summaryInfo(String AccountId) {
        
        paidCount=[SELECT COUNT() FROM Invoice__c WHERE Status__c='Paid' and Account__c=:AccountId];
        dueCount=[SELECT COUNT() FROM Invoice__c WHERE Status__c='Due' and Account__c=:AccountId];
        overdueList=[SELECT count() FROM Invoice__c WHERE Status__c='Overdue' and Account__c=:AccountId];
        totalSum=[SELECT SUM(Amount_Due__c) sum FROM Invoice__c WHERE Account__c=:AccountId];
        System.debug('totalSum== '+totalSum);
        Integer totalValue = Integer.valueOf(totalSum[0].get('sum'));
        Integer sum=0;
        if(totalValue>0){
            system.debug('totalsum.size()=='+totalsum.size());
            sum=totalValue;
        }
        else{
            sum=0;
        }
        wrapperClassInvoices wrpobj = new wrapperClassInvoices();
        wrpobj.PaidInfo = paidCount;
        wrpobj.CurrentDueInfo = dueCount;
        wrpobj.overdueInvoicesInfo = overdueList;
        wrpobj.TotalRecieveableInfo = sum;
        system.debug('wrpobj=='+wrpobj);
        return wrpobj;
    }
    
    public class wrapperClassInvoices{
        @AuraEnabled
        public Integer PaidInfo{get;set;}
        @AuraEnabled
        public Integer CurrentDueInfo{get;set;}
        @AuraEnabled
        public Integer TotalRecieveableInfo{get;set;}
        @AuraEnabled
        public Integer overdueInvoicesInfo{get;set;}
    }
}
