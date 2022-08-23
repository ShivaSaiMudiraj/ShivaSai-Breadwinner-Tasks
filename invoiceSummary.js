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
    overduedata=[];
    count1to30=0;
    count31to60=0;
    count61to90=0;
    count91=0;
    countStatus=0;
    @api recordId;
    
    @track columns = [
        {
        label: 'Invoice #',
        fieldName: 'invoiceName',
        type: 'url',
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
        type: 'Date'
    },
    {
        label: 'Due Date',
        fieldName: 'Due_Date__c',
        type: 'Date'
    },
    {
        label: 'Amount Paid',
        fieldName: 'Amount_Paid__c',
        type: 'currency'
    },
    {
        label: 'Amount Due',
        fieldName: 'Amount_Due__c',
        type: 'currency'
    },
    {
        label: 'Days Overdue',
        fieldName: 'Days_Overdue__c',
        type: 'number'
    },
    {
        label: 'Total',
        fieldName: 'Total__c',
        type: 'currency'
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
    this.overduedata = data;
    this.countStatus= this.overduedata.length;
    console.log('countStatus'+this.overduedata.length);
    for(let i=0; i<this.overduedata.length; i++){
        console.log('days overdue'+this.overduedata[i].Days_Overdue__c);
       
    if(this.overduedata[i].Days_Overdue__c >=1 && this.overduedata[i].Days_Overdue__c<=30){
        console.log('count1to30==='+this.count1to30);
         this.count1to30= this.count1to30 + 1;
    }
    else if(this.overduedata[i].Days_Overdue__c >=31 && this.overduedata[i].Days_Overdue__c<=60){
        console.log('count31to60==='+this.count31to60);
         this.count31to60= this.count31to60 + 1;
    }
    else if(this.overduedata[i].Days_Overdue__c >=61 && this.overduedata[i].Days_Overdue__c <=90){
        console.log('count61to90==='+this.count61to90);
         this.count61to90= this.count61to90 + 1;
    } 
    else if(this.overduedata[i].Days_Overdue__c >=91){
        console.log('count91==='+this.count91);
         this.count91= this.count91 + 1;
    }     
}
}
}
@wire(totalReceivablesInvoices,  { AccountId:'$recordId' })totalReceivables;
}
