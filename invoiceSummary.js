import { LightningElement,api,track,wire } from 'lwc';
import getAllInvoices from '@salesforce/apex/ListofInvoicesController.getAllInvoices';
import paidInvoices from '@salesforce/apex/ListofInvoicesController.paidInvoices';
import currentDueInvoices from '@salesforce/apex/ListofInvoicesController.currentDueInvoices';
import overdueInvoices from '@salesforce/apex/ListofInvoicesController.overdueInvoices';
import totalReceivablesInvoices from '@salesforce/apex/ListofInvoicesController.totalReceivablesInvoices';
export default class InvoiceSummary extends LightningElement {
    error;
    invoices;
    invdata=[];
    @api recordId;
    OverdueInvoicesString;
    
    @track columns = [
        {
        label: 'Invoice #',
        fieldName: 'invoiceName',
        type: 'url',
        sortable: true,
        typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}
    },
    {
        label: 'Status',
        fieldName: 'Status__c',
        type: 'text'
        /*cellAttributes:{ 
            class: { fieldName: 'Status__c' },
            iconName: {
                fieldName: 'IconName'
            }
        }*/
    },
    {
        label: 'Invoice Date',
        fieldName: 'Invoice_Date__c',
        type: 'Date',
        sortable: true
    },
    {
        label: 'Due Date',
        fieldName: 'Due_Date__c',
        type: 'Date',
        sortable: true
    },
    {
        label: 'Amount Paid',
        fieldName: 'Amount_Paid__c',
        type: 'currency',
        sortable: true
    },
    {
        label: 'Amount Due',
        fieldName: 'Amount_Due__c',
        type: 'currency',
        sortable: true
    },
    {
        label: 'Days Overdue',
        fieldName: 'Days_Overdue__c',
        type: 'number',
        sortable: true
    },
    {
        label: 'Total',
        fieldName: 'Total__c',
        type: 'currency',
        sortable: true
    }
    
];

@wire(getAllInvoices,  { AccountId:'$recordId' })
wiredInvoices({ error, data }) {
    if (data) 
    {
        let invArrayList = []; 
        data.forEach((record) => {
            let tempInvRec = Object.assign({}, record);  
            tempInvRec.invoiceName = '/' + tempInvRec.Id;
            invArrayList.push(tempInvRec);
        });
        this.invdata = invArrayList;
        console.log('invdata'+this.invdata);
        this.error = undefined;
    } 
    else if (error) {
        this.error = result.error;
    }
}
@wire(paidInvoices,  { AccountId:'$recordId' })TotalPaidInvoices;
@wire(currentDueInvoices,  { AccountId:'$recordId' })CurrentDueInvoices;
@wire(overdueInvoices,  { AccountId:'$recordId' })
wiredOverdueInvoices({ error, data }) {
if (data) 
{
    if(data >=1 && data<=30){
        this.OverdueInvoicesString='1-30';
    }
    else if (data >=31 && data<=60) {
        this.OverdueInvoicesString='31-60';
    }
    else if (data >=61 && data<=90) {
        this.OverdueInvoicesString='61-90';
    }
    else if (data >=91) {
        this.OverdueInvoicesString='91+';
    }
    else if (error) {
    this.error = result.error;
    }
}
}
@wire(totalReceivablesInvoices,  { AccountId:'$recordId' })totalReceivables;
}
