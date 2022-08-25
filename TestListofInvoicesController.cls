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
    }
}
