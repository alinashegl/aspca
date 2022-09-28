import { LightningElement, wire } from 'lwc';
//import getBehCaseWorkers from '@salesforce/apex/CRCAnimalDogListController.getBehCaseWorkers';
import getAnimals from '@salesforce/apex/CRCAnimalDogListController.getRecords';
import updateRecords from '@salesforce/apex/CRCAnimalDogListController.saveRecords';

const TREATMENTPRIORITYOPTIONS = [
    { label: 'No Treatment', value: 'No Treatment' },
    { label: 'Daily – 7 days', value: 'Daily – 7 days' },
    { label: 'High – 5 days', value: 'High – 5 days' },
    { label: 'Medium – 4 days', value: 'Medium – 4 days' },
    { label: 'Low – 3 days', value: 'Low – 3 days' }
];

const ENRICHMENTPRIORITYOPTIONS = [
    {value: 'Low – 3 days', label: 'Low – 3 days'},
    {value: 'High – 5 days', label: 'High – 5 days'},
    {value: 'Daily – 7 days', label: 'Daily – 7 days'}
];

const SHELTERCOLOROPTIONS = [
    {value: 'Green', label: 'Green'},
    {value: 'Yellow', label: 'Yellow'},
    {value: 'Purple - EC/DH/Behavior Move Only', label: 'Purple - EC/DH/Behavior Move Only'},
    {value: 'Red', label: 'Red'},
    {value: 'Blue - Behavior Move Only', label: 'Blue - Behavior Move Only'},
    {value: 'Black', label: 'Black'},
    {value: 'Green - Medical Handling Instructions', label: 'Green - Medical Handling Instructions'},
    {value: 'Yellow - Medical Handling Instructions', label: 'Yellow - Medical Handling Instructions'},
    {value: 'Purple - EC/DH/Behavior Move Only - Medical Handling Instructions', label: 'Purple - EC/DH/Behavior Move Only - Medical Handling Instructions'},
    {value: 'Red - Medical Handling Instructions', label: 'Red - Medical Handling Instructions'},
    {value: 'Blue - Behavior Move Only - Medical Handling Instructions', label: 'Blue - Behavior Move Only - Medical Handling Instructions'},
    {value: 'Black - Medical Handling Instructions', label: 'Black - Medical Handling Instructions'},
    {value: 'Yellow - EC/DH/Behavior Move Only', label: 'Yellow - EC/DH/Behavior Move Only'},
    {value: 'Behavior Move Only', label: 'Behavior Move Only'},
    {value: 'Yellow - EC/DH/Behavior Move Only - Medical Handling Instructions', label: 'Yellow - EC/DH/Behavior Move Only - Medical Handling Instructions'},
    {value: 'Blue – Behavior Move', label: 'Blue – Behavior Move'},
    {value: 'Blue – Behavior Move - LS', label: 'Blue – Behavior Move - LS'},
    {value: 'Green - LS', label: 'Green - LS'},
    {value: 'Purple – EC/DH/Behavior', label: 'Purple – EC/DH/Behavior'},
    {value: 'Purple – EC/DH/Behavior - LS', label: 'Purple – EC/DH/Behavior - LS'},
    {value: 'Red – Designated Handler', label: 'Red – Designated Handler'},
    {value: 'Red – Designated Handler - LS', label: 'Red – Designated Handler - LS'},
    {value: 'Yellow - LS', label: 'Yellow - LS'}
];

const PLAYGROUPPRIORITYOPTIONS = [
    {value: 'Daily – 7 days', label: 'Daily – 7 days'},
    {value: 'High – 4 days', label: 'High – 4 days'},
    {value: 'Low – 2 days', label: 'Low – 2 days'}
];

const columns = [
    {label: 'ASPCA Animal Name', fieldName: 'Animal_Name__c',type: 'text', editable: false, disabled: true},
    {label: 'Animal Name/Id', fieldName: 'Animal__c', type: 'link', linkLabel: 'anmName'}, 
    {label: 'Treatment Priority', fieldName: 'Treatment_Priority__c', type: 'picklist', options: TREATMENTPRIORITYOPTIONS, sortable: true, resizable: true,editable: true},
    {label: 'Enrichment Priority', fieldName: 'Enrichment_Priority__c', type: 'picklist', options: ENRICHMENTPRIORITYOPTIONS, sortable: true, resizable: true, editable: true},
    {label: 'Shelter Color Coding', fieldName: 'Shelter_Color_Coding__c', type: 'picklist', options: SHELTERCOLOROPTIONS, sortable: true, resizable: true, editable: true},
    {label: 'Meets Adoptability Date', fieldName: 'Meets_Adoptability_Date__c',type: 'date', editable: true, disabled: false},
    {label: 'Playgroup Priority Level', fieldName: 'Playgroup_Priority_Level__c', type: 'picklist', options: PLAYGROUPPRIORITYOPTIONS, sortable: true, resizable: true, editable: true},
    {label: 'Behavior Case Worker', fieldName: 'Behavior_Case_Worker__c', type: 'link', linkLabel: 'behName'}, 
    {label: 'Behavior Summary Change Date', fieldName: 'Behavior_Summary_Change_Date__c',type: 'date', editable: false, disabled: true},
    
];
const PAGESIZEOPTIONS = [5,10,20,40];

export default class VkDatatableUsage extends LightningElement {
    error;
    columns = columns;
    anms;
    showTable = false;
    pageSizeOptions = PAGESIZEOPTIONS;
    isLoading = true;
    loadMessage = 'Loading...';

    /*@wire(getBehCaseWorkers)
    wAccs({error,data}){
        if(data){
            let contacts = [];
            for(let i=0; i<data.length; i++){
                let obj = {value: data[i].Id, label: data[i].Name};
                contacts.push(obj);
            }
            this.columns[7].options = contacts;
            this.getAnimals_();
        }else{
            this.error = error;
        }       
    }*/

    connectedCallback(){
        this.getAnimals_();
    }

    getAnimals_(){
        this.showTable = false;
        this.loadMessage = 'Loading...';
        this.isLoading = true;
        this.error = '';
        getAnimals()
        .then(data=>{
            this.anms = [];
            for(let i=0; i<data.length; i++){
                let obj = {...data[i]};
                if(data[i].hasOwnProperty('Animal__r')){
                    if(data[i].Animal__r.hasOwnProperty('Animal_Name__c')){
                        obj.anmName = data[i].Animal__r.Animal_Name__c;
                        obj.Animal_Name__c = data[i].Animal__r.Animal_Name__c;
                    }
                    if(data[i].Animal__r.hasOwnProperty('Animal_Name_Id__c')){
                        obj.Animal_Name_Id__c = data[i].Animal__r.Animal_Name_Id__c;
                    }
                    if(data[i].Animal__r.hasOwnProperty('Shelter_Color_Coding__c')){
                        obj.Shelter_Color_Coding__c = data[i].Animal__r.Shelter_Color_Coding__c;
                    }
                    if(data[i].Animal__r.hasOwnProperty('Meets_Adoptability_Date__c')){
                        obj.Meets_Adoptability_Date__c = data[i].Animal__r.Meets_Adoptability_Date__c;
                    }
                    if(data[i].Animal__r.hasOwnProperty('Playgroup_Priority_Level__c')){
                        obj.Playgroup_Priority_Level__c = data[i].Animal__r.Playgroup_Priority_Level__c;
                    }
                    if(data[i].Animal__r.hasOwnProperty('Behavior_Summary_Change_Date__c')){
                        obj.Behavior_Summary_Change_Date__c = data[i].Animal__r.Behavior_Summary_Change_Date__c;
                    }
                    if(data[i].Animal__r.hasOwnProperty('Behavior_Case_Worker__r')){
                        obj.behName = data[i].Animal__r.Behavior_Case_Worker__r.Name;
                        obj.Behavior_Case_Worker__c = data[i].Animal__r.Behavior_Case_Worker__r.Id;
                    }
                }    
                this.anms.push(obj);
            }
            this.showTable = true;
            this.isLoading = false;
        })
        .catch(error=>{
            this.error = JSON.stringify(error);
            this.showTable = true;
            this.isLoading = false;
        });       
    }

    handleRowSelection(event){
        console.log('Records selected***'+JSON.stringify(event.detail));
    }

    saveRecords(event){
        this.loadMessage = 'Saving...';
        this.isLoading = true;
        this.error = '';
        let recs = JSON.parse(JSON.stringify(event.detail));
        for(let i=0;i<recs.length;i++){
            if(recs[i].hasOwnProperty('anmName')){
                delete recs[i]['anmName'];
                delete recs[i]['Animal_Name__c'];
                delete recs[i]['Animal_Name_Id__c'];
                delete recs[i]['Behavior_Summary_Change_Date__c'];
            }

            if(recs[i].hasOwnProperty('behName')){
                delete recs[i]['Behavior_Case_Worker__c'];
                delete recs[i]['behName'];
            }

            if(recs[i].hasOwnProperty('Animal__r')){
                if(recs[i].hasOwnProperty('Shelter_Color_Coding__c')){
                    recs[i].Animal__r.Shelter_Color_Coding__c = recs[i]['Shelter_Color_Coding__c'];
                    delete recs[i]['Shelter_Color_Coding__c'];
                }

                if(recs[i].hasOwnProperty('Behavior_Summary_Change_Date__c')){
                    recs[i].Animal__r.Behavior_Summary_Change_Date__c = recs[i]['Behavior_Summary_Change_Date__c'];
                    delete recs[i]['Behavior_Summary_Change_Date__c'];
                }
                if(recs[i].hasOwnProperty('Playgroup_Priority_Level__c')){
                    recs[i].Animal__r.Playgroup_Priority_Level__c = recs[i]['Playgroup_Priority_Level__c'];
                    delete recs[i]['Playgroup_Priority_Level__c'];
                }
                if(recs[i].hasOwnProperty('Meets_Adoptability_Date__c')){
                    recs[i].Animal__r.Meets_Adoptability_Date__c = recs[i]['Meets_Adoptability_Date__c'];
                    delete recs[i]['Meets_Adoptability_Date__c'];
                }
            }
        }
        updateRecords({recsString: JSON.stringify(recs)})
        .then(response=>{
            if(response==='success') this.getAnimals_();
        })
        .catch(error=>{
            console.log('recs save error***'+error);
            this.error = JSON.stringify(error);
            this.isLoading = false;
        });
    }
}