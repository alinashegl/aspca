import { api, LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { updateRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import FORM_FACTOR from '@salesforce/client/formFactor';
import ID_FIELD from '@salesforce/schema/Treatment_Plan__c.Id';
import BUNDLE_ID_FIELD from '@salesforce/schema/Treatment_Plan__c.AssignedTreatmentBundleId__c';
import TREATMENT_OBJECT from '@salesforce/schema/Treatment_Plan__c';
import PRIORITY_FIELD from '@salesforce/schema/Treatment_Plan__c.Treatment_Priority__c';
import updateTreatment from '@salesforce/apex/TreatmentToDoListController.updateTreatment';

export default class TreatmentToDoSection extends NavigationMixin(LightningElement) {
    @api
    animalTreatment;
    customLookupNewId;
    isExpanded = false;
    isSelected = false;
    isEdit = false;
    urlId;
    urlBundle;
    treatmentPriority;
    isConfirmationVisible = false;

    @wire(getObjectInfo, { objectApiName: TREATMENT_OBJECT })
    treatmentMetadata;

    @wire(getPicklistValues,
    {
        recordTypeId: '$treatmentMetadata.data.defaultRecordTypeId', 
        fieldApiName: PRIORITY_FIELD
    })
    treatmentPriorirtyPicklist;

    connectedCallback() {
        this.recordPageRefId = {
            type: 'standard__recordPage',
            attributes: {
                recordId: this.animalTreatment.Animal__c,
                actionName: 'view',
            }
        };
        this[NavigationMixin.GenerateUrl](this.recordPageRefId)
            .then(url => this.urlId = url);
        this.recordPageRefBundle = {
            type: 'standard__recordPage',
            attributes: {
                recordId: this.animalTreatment.AssignedTreatmentBundleId__c,
                actionName: 'view',
            }
        };
        this[NavigationMixin.GenerateUrl](this.recordPageRefBundle)
            .then(url => this.urlBundle = url);
        this.customLookupNewId = this.animalTreatment.AssignedTreatmentBundleId__c;
        this.treatmentPriority = this.animalTreatment.Treatment_Priority__c;
    }

    get treatmentCount() {
        return this.animalTreatment.Animal__r.Number_of_Treatments__c ?? 0;
    }

    get showHandler() {
        return this.animalTreatment.Shelter_Color_Code__c != undefined && this.animalTreatment.Shelter_Color_Code__c !== '' && !this.animalTreatment.Shelter_Color_Code__c.startsWith('Green');
    }

    get handlerVariant() {
        let colorClass;
        if (this.animalTreatment.Shelter_Color_Code__c.startsWith('Yellow')) {
            colorClass = 'yellowIcon';
        }
        else if (this.animalTreatment.Shelter_Color_Code__c.startsWith('Purple')) {
            colorClass = 'purpleIcon';
        }
        else if (this.animalTreatment.Shelter_Color_Code__c.startsWith('Red')) {
            colorClass = 'redIcon';
        }
        else if (this.animalTreatment.Shelter_Color_Code__c.startsWith('Blue')) {
            colorClass = 'blueIcon';
        }
        else if (this.animalTreatment.Shelter_Color_Code__c.startsWith('Black')) {
            colorClass = 'blackIcon';
        }
        return colorClass;
    }

    get smallForm() {
        return FORM_FACTOR === 'Small';
    }

    get expanded() {
        return this.isExpanded || FORM_FACTOR === 'Large';
    }

    get treatmentBundleName(){
        return this.animalTreatment.AssignedTreatmentBundleId__r != undefined ? this.animalTreatment.AssignedTreatmentBundleId__r.Name : null;
    }

    get customLookupFields(){
        return ['Name'];
    }

    get customLookupDisplayFields(){
        return 'Name';
    }

    get customLookupFieldToQuery(){
        return 'Name';
    }

    get customLookupWhereClause(){
        return ' IsMaster__c = false';
    }

    handleReset() {
        this.isEdit = false;
    }

    toggleExpand() {
        this.isExpanded = !this.isExpanded;
    }

    handleClick() {
        this.isSelected = !this.isSelected;
    }

    handleEdit() {
        this.isEdit = !this.isEdit;
    }

    handleCustomLookupExpandSearch(event){
        let data = event.detail.data;
        let dataId = data.elementId;
        this.template.querySelector('[data-id="' + dataId + '"]').className =
           data.expandField ? 'slds-col slds-size_1-of-1 slds-medium-size_2-of-12 slds-large-size_2-of-12' : data.initialColSize;
    }

    handleUpdate() {
        this.isConfirmationVisible = true;
    }

    customLookupEvent(event){
        this.customLookupNewId = event.detail.data.recordId;
    }

    handleTreatmentPriorityChange(event){
        this.treatmentPriority = event.detail.value;
    }

    handleConfirmationClick(event){
        if(event.detail.status === 'confirm') {
            //trigger update logic and send update event to parent
            if (this.customLookupNewId !== this.animalTreatment.AssignedTreatmentBundleId__c || 
                this.treatmentPriority !== this.animalTreatment.Treatment_Priority__c) {
                const fields = {};
                fields[BUNDLE_ID_FIELD.fieldApiName] = this.customLookupNewId;
                fields[PRIORITY_FIELD.fieldApiName] = this.treatmentPriority;
                updateTreatment({recordId: this.animalTreatment.Id, fieldMap: fields})
                .then(() => {
                    this.dispatchEvent(new CustomEvent('update'));
                })
                .catch(error => {
                    console.log('error', JSON.stringify(error));
                });
            }
        }
        this.isEdit = false;
        this.isConfirmationVisible = false;
    }
}