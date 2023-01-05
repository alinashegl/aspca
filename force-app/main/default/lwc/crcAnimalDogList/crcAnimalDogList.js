import { LightningElement, wire } from 'lwc';
import getBehCaseWorkers from '@salesforce/apex/ArcCareAnimalDogListController.getBehCaseWorkers';
import getAnimals from '@salesforce/apex/CRCAnimalDogListController.getRecords';
import updateRecords from '@salesforce/apex/CRCAnimalDogListController.saveRecords';
import LOCATION_FILTER_MC from "@salesforce/messageChannel/LocationFilterChannel__c";
import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import getPicklistValue from '@salesforce/apex/ArcCareAnimalDogListController.getPicklistValue';

const columns = [
    {label: 'ASPCA Animal Name', fieldName: 'Animal_Name__c',type: 'text', editable: false, disabled: true},
    {label: 'Animal Name/Id', fieldName: 'Animal__c', type: 'link', linkLabel: 'anmName', sortable: true, sortBy: 'anmName'}, 
    {label: 'Treatment Priority', fieldName: 'Treatment_Priority__c', type: 'picklist', sortable: true, resizable: true,editable: true},
    {label: 'Enrichment Priority', fieldName: 'Enrichment_Priority__c', type: 'picklist', sortable: true, resizable: true, editable: true},
    {label: 'Shelter Color Coding', fieldName: 'Shelter_Color_Coding__c', type: 'picklist', sortable: true, resizable: true, editable: true},
    {label: 'Meets Adoptability Date', fieldName: 'Meets_Adoptability_Date__c',type: 'date', editable: true, disabled: false, sortable: true},
    {label: 'Playgroup Priority Level', fieldName: 'Playgroup_Priority_Level__c', type: 'picklist', sortable: true, resizable: true, editable: true},
    //{label: 'Behavior Case Worker', fieldName: 'Behavior_Case_Worker__c', type: 'link', linkLabel: 'behName'}, 
    {label: 'Behavior Case Worker', fieldName: 'Behavior_Case_Worker__c', type: 'lookup', linkLabel: 'behName',
     sortable: true, resizable: true, editable: true,sortBy: 'behName', title:'Click to view Behavior Case Worker', iconName:'standard:contact'},
    
    {label: 'Behavior Summary Change Date', fieldName: 'Behavior_Summary_Change_Date__c',type: 'date', editable: true, disabled: false, sortable: true},
    {label: 'Play Pause Reason', fieldName: 'Play_Pause_Reason',type: 'text', editable: false, disabled: true, sortable: true},
    
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
    searchKey = '';
    receivedMessage;
    subscription = null;

    connectedCallback(){
        this.subscribeMC();
        this.getTreatmentPriority();
        this.getEnrichmentPriority();
        this.getShelterColorCoding();
        this.getPlaygroupPriority();
    }

    @wire(MessageContext)
    messageContext;
    
	subscribeMC() {
		if (this.subscription) {
			return;
		}
		this.subscription = subscribe(
			this.messageContext,
			LOCATION_FILTER_MC, ( message ) => {
				this.handleMessage( message );
			},
			{scope: APPLICATION_SCOPE});
	}

	unsubscribeMC() {
		unsubscribe( this.subscription );
		this.subscription = null;
	}

    getTreatmentPriority(){
        getPicklistValue({
            objectname: 'Treatment_Plan__c',
            fieldname : 'Treatment_Priority__c'
        }).then(data=>{
            this.columns[2].options = data;
        })
    }
    
    getEnrichmentPriority(){
        getPicklistValue({
            objectname: 'Treatment_Plan__c',
            fieldname : 'Enrichment_Priority__c'
        }).then(data=>{
            this.columns[3].options = data;
        })
    }

    getShelterColorCoding(){
        getPicklistValue({
            objectname: 'Animal__c',
            fieldname : 'Shelter_Color_Coding__c'
        }).then(data=>{
            this.columns[4].options = data;
        })
    }
    
    getPlaygroupPriority(){
        getPicklistValue({
            objectname: 'Animal__c',
            fieldname : 'Playgroup_Priority_Level__c'
        }).then(data=>{
            this.columns[6].options = data;
        })
    }

    @wire(getBehCaseWorkers)
    wAccs({error,data}){
        if(data){
            let contacts = [];
            for(let i=0; i<data.length; i++){
                let obj = {value: data[i].Id, label: data[i].Name};
                contacts.push(obj);
            }
            this.columns[7].options = contacts;
            if(!this.subscription){
                this.subscribeMC();
            } else {                
                this.getAnimals_(this.receivedMessage);
            }
            
        }else{
            this.error = error;
        }       
    }

    getAnimals_(filter){
        this.showTable = false;
        this.loadMessage = 'Loading...';
        this.isLoading = true;
        this.error = '';
        let location = filter && filter.locations ? filter.locations : null;
        getAnimals({locationsFilter: location})
        .then(resData=>{
            let data = resData.animals;
            let playPauseReasons = resData.playPauseReasons;
            console.log('ppp'+playPauseReasons);
            this.anms = [];
            for(let i=0; i<data.length; i++){
                let obj = {...data[i]};
                
                if(data[i].hasOwnProperty('Animal_Name__c')){
                    obj.anmName = data[i].Animal_Name_Id__c;
                    obj.Animal__c = data[i].Id;
                    obj.Animal_Name__c = data[i].Animal_Name__c;
                }
                if(data[i].hasOwnProperty('Treatment_Plan__r') && data[i].Treatment_Plan__r.length > 0 && data[i].Treatment_Plan__r[0].hasOwnProperty('Treatment_Priority__c')){
                    obj.Treatment_Priority__c = data[i].Treatment_Plan__r[0].Treatment_Priority__c;
                }
                if(data[i].hasOwnProperty('Treatment_Plan__r') && data[i].Treatment_Plan__r.length > 0 && data[i].Treatment_Plan__r[0].hasOwnProperty('Enrichment_Priority__c')){
                    obj.Enrichment_Priority__c = data[i].Treatment_Plan__r[0].Enrichment_Priority__c;
                }
                if(data[i].hasOwnProperty('Behavior_Case_Worker__r')){
                    obj.behName = data[i].Behavior_Case_Worker__r.Name;
                    obj.Behavior_Case_Worker__c = data[i].Behavior_Case_Worker__r.Id;
                }
                if(playPauseReasons.hasOwnProperty(data[i].Id)){
                    obj.Play_Pause_Reason = (playPauseReasons[data[i].Id]).join(';');
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
            }

            if(recs[i].hasOwnProperty('behName')){
                //delete recs[i]['Behavior_Case_Worker__c'];
                delete recs[i]['behName'];
            }

            if(recs[i].hasOwnProperty('Play_Pause_Reason')){
                delete recs[i]['Play_Pause_Reason'];
            }

            if(recs[i].hasOwnProperty('Treatment_Plan__r') && recs[i].Treatment_Plan__r.length > 0){
                if(recs[i].hasOwnProperty('Treatment_Priority__c')){
                    recs[i].Treatment_Plan__r[0].Treatment_Priority__c = recs[i]['Treatment_Priority__c'];
                    delete recs[i]['Treatment_Priority__c'];
                }

                if(recs[i].hasOwnProperty('Enrichment_Priority__c')){
                    recs[i].Treatment_Plan__r[0].Enrichment_Priority__c = recs[i]['Enrichment_Priority__c'];
                    delete recs[i]['Enrichment_Priority__c'];
                }

                let temp = this.rewriteSubquery(recs[i].Treatment_Plan__r);
                delete recs[i].Treatment_Plan__r;
                recs[i].Treatment_Plan__r = temp;
            } else {
                recs[i].Treatment_Plan__r = this.rewriteSubquery([]);
            }
        }
        updateRecords({recsString: JSON.stringify(recs)})
        .then(response=>{
            if(response==='success') this.getAnimals_(this.receivedMessage);
        })
        .catch(error=>{
            console.log('recs save error***'+error);
            this.error = JSON.stringify(error);
            this.isLoading = false;
        });
    }

    rewriteSubquery(array) {
        if (array && !array.hasOwnProperty('records')) {
            var tempArray = array;
            array = {
                totalSize: tempArray.length,
                done: true,
                records: tempArray
            }
        }
        return array;
    };

	handleMessage( message ) {

		this.receivedMessage = message;
		
		if(this.receivedMessage){
			this.getAnimals_(this.receivedMessage);
		}
	}
}