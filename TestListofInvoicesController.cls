@isTest
public class TestListofInvoicesController {
    public static testmethod void  testMethod1(){
        Account accounttest = new Account(Name='Test');
        Insert accounttest;
        
        Invoice__c testInvoice = new Invoice__c();
        testInvoice.Account__c=accounttest.id;
        testInvoice.Amount_Paid__c=100;
        testInvoice.Due_Date__c=system.today();
        testInvoice.Invoice_Date__c=system.today();
        testInvoice.Total__c=100;
        Insert testInvoice;
        
        Invoice__c testInvoice2 = new Invoice__c();
        testInvoice2.Account__c=accounttest.id;
        testInvoice2.Amount_Paid__c=99;
        testInvoice2.Due_Date__c=system.today()-20;
        testInvoice2.Invoice_Date__c=system.today();
        testInvoice2.Total__c=100;
        Insert testInvoice2;
        
        Invoice__c testInvoice3 = new Invoice__c();
        testInvoice3.Account__c=accounttest.id;
        testInvoice3.Amount_Paid__c=99;
        testInvoice3.Due_Date__c=system.today()-40;
        testInvoice3.Invoice_Date__c=system.today();
        testInvoice3.Total__c=100;
        Insert testInvoice3;
        
        Invoice__c testInvoice4 = new Invoice__c();
        testInvoice4.Account__c=accounttest.id;
        testInvoice4.Amount_Paid__c=99;
        testInvoice4.Due_Date__c=system.today()-80;
        testInvoice4.Invoice_Date__c=system.today();
        testInvoice4.Total__c=100;
        Insert testInvoice4;
        
        Invoice__c testInvoice5 = new Invoice__c();
        testInvoice5.Account__c=accounttest.id;
        testInvoice5.Amount_Paid__c=99;
        testInvoice5.Due_Date__c=system.today()-100;
        testInvoice5.Invoice_Date__c=system.today();
        testInvoice5.Total__c=100;
        Insert testInvoice5;
                
        PageReference pageRef = Page.ListOfInvoicesvf;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('pagee',testInvoice.id);
        pageRef.getParameters().put('idToEdit',testInvoice.id);
        pageRef.getParameters().put('idToDel',testInvoice.id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(testInvoice);
		ListofInvoicesController controllerclass = new ListofInvoicesController(controller);
        ApexPages.Pagereference openView =controllerclass.openNewViewPage();
        controllerclass.showPopup();
        controllerclass.closePopup();
        controllerclass.invoiceDetailClose();
        controllerclass.saveInvoice();
        controllerclass.editAction();
        controllerclass.deleteAction();
        controllerclass.sortAscDesc();
        ListofInvoicesController.getAllInvoices(accounttest.id);
        ListofInvoicesController.paidInvoices(accounttest.id);
        ListofInvoicesController.currentDueInvoices(accounttest.id);
        ListofInvoicesController.overdueInvoices(accounttest.id);
        ListofInvoicesController.totalReceivablesInvoices(accounttest.id);
        ListofInvoicesController.getAllOverdues(accounttest.id);
    }
}
