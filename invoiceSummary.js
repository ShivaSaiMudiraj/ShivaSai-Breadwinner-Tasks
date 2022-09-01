import { LightningElement,api,track,wire } from 'lwc';
import Chartjs from '@salesforce/resourceUrl/Chartjs';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllInvoices from '@salesforce/apex/ListofInvoicesController.getAllInvoices';
import getAllOverdues from '@salesforce/apex/ListofInvoicesController.getAllOverdues';
import summaryInfo from '@salesforce/apex/ListofInvoicesController.summaryInfo';
export default class InvoiceSummary extends LightningElement {
    error;
    invoices;
    invdata=[];
    summarydata=[];
    @api recordId;
    sortBy='Name';
    sortDirection='asc';
    
    columns = [
        {
        label: 'Invoice #',
        fieldName: 'invoiceName',
        type: 'url',
        sortable: "true",
        typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}
    },
    { label: 'Status',
      fieldName: '',
      cellAttributes: { iconName: { fieldName: 'Status__c' } , class: { fieldName: 'variant' }}
    },
    {
        label: 'Invoice Date',
        fieldName: 'Invoice_Date__c',
        type: 'Date',
        sortable: "true"
    },
    {
        label: 'Due Date',
        fieldName: 'Due_Date__c',
        type: 'Date',
        sortable: "true"
    },
    {
        label: 'Amount Paid',
        fieldName: 'Amount_Paid__c',
        type: 'currency',
        sortable: "true"
    },
    {
        label: 'Amount Due',
        fieldName: 'Amount_Due__c',
        type: 'currency',
        sortable: "true"
    },
    {
        label: 'Days Overdue',
        fieldName: 'Days_Overdue__c',
        type: 'number',
        sortable: "true"
    },
    {
        label: 'Total',
        fieldName: 'Total__c',
        type: 'currency',
        sortable: "true"
    }
    
];

@wire(getAllInvoices,  { AccountId:'$recordId',field : '$sortBy',sortOrder : '$sortDirection' })
wiredInvoices({ error, data }) {
    if (data) 
    {
        let invArrayList = []; 
        data.forEach((record) => {
            let tempInvRec = Object.assign({}, record);  
            tempInvRec.invoiceName = '/' + tempInvRec.Id;
            invArrayList.push(tempInvRec);
        
            if(tempInvRec.Status__c.includes("Paid")){
                console.log('Paid Entered');
                tempInvRec.Status__c='action:priority';
                tempInvRec.variant='slds-icon slds-icon-text-success';
                
            }
            else if(tempInvRec.Status__c.includes("Overdue"))
            {
                console.log('Overdue Entered');
                tempInvRec.Status__c='action:priority';
                tempInvRec.variant='slds-icon slds-icon-text-error';
            }
            else {
                console.log('Due Entered');
                tempInvRec.Status__c='action:priority';
                tempInvRec.variant='slds-icon slds-icon-text-warning';
            }
        });
        this.invdata = invArrayList;
        console.log('invdata'+this.invdata);
        this.error = undefined;
    } 
    else if (error) {
        this.error = result.error;
    }
}
handleSorting(event) {
    let sortByField = event.detail.fieldName;
    console.log('sortByField ==='+sortByField);
    if (sortByField === "invoiceName") {
        this.sortBy = "Name";
        console.log('sortBy if loop=='+this.sortBy);
      }else{
        this.sortBy=sortByField;
        console.log('sortBy else loop'+this.sortBy);
      }
    //this.sortBy = sortByField;
    this.sortDirection = event.detail.sortDirection;
    console.log('sortDirection==='+this.sortDirection);
}
 
@wire (summaryInfo, { AccountId:'$recordId' }) 
WiredsummaryInfo({error,data})
{
    if(data){
        console.log('WiredsummaryInfo Entered');
        this.summarydata = data;
    }
}
@wire (getAllOverdues, { AccountId:'$recordId' }) 
overdues({error,data})
{
   if(data)
   {
    
      for(var key in data)
       {
          this.updateChart(data[key].count,data[key].label);
       }
      this.error=undefined;
   }
  else if(error)
  {
     this.error = error;
     this.overdues = undefined;
  }
}
chart;
chartjsInitialized = false;
config={
type : 'doughnut',
data :{
datasets :[
{
data: [
],
backgroundColor :[
    'rgb(55,255,51)',
    'rgb(238,253,21)',
    'rgb(51,255,255)',
    'rgb(0,0,255)',
],
   label:'Dataset 1'
}
],
labels:[]
},
options: {
    responsive : true,
legend : {
    position :'right'
},
animation:{
   animateScale: true,
   animateRotate : true
}
}
};
renderedCallback()
{
   if(this.chartjsInitialized)
  {
   return;
  }
  this.chartjsInitialized = true;
  Promise.all([
   loadScript(this,Chartjs)
  ]).then(() =>{
    const ctx = this.template.querySelector('canvas.Doughnut').getContext('2d');
    this.chart = new window.Chart(ctx, this.config);
  })
  .catch(error =>{
    this.dispatchEvent(
    new ShowToastEvent({
    title : 'Error loading ChartJS',
    message : error.message,
    variant : 'error',
   }),
  );
});
}
updateChart(count,label)
{
   this.chart.data.labels.push(label);
   this.chart.data.datasets.forEach((dataset) => {
   dataset.data.push(count);
   });
   this.chart.update();
 }
}
