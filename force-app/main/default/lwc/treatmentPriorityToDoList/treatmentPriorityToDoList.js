import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import FORM_FACTOR from '@salesforce/client/formFactor';
import getAnimalTreatments from '@salesforce/apex/TreatmentToDoListController.getAnimalTreatments';

export default class TreatmentPriorityToDoList extends NavigationMixin(LightningElement) {
    @track
    addedSort = [];
    @track
    addedFilter = [];
    @track
    filterValueOptions = [];
    //result for refreshApex
    animalTreatments;
    //holds actual data from server call
    animalTreatmentsData;
    //displayed data that sorts/filters on client side
    animalTreatmentSortFilter;
    sortFieldValue;
    sortDirectionValue = 'ASC';
    filterFieldValue;
    filterValueValue;

    get sortFieldOptions() {
        return [
            { label: 'Name', value: 'Animal__r.Animal_Name__c' },
            { label: 'ID#', value: 'Animal__r.Name' },
            { label: 'Treatment Priority', value: 'Treatment_Priority__c' },
            { label: 'Bundle Assignment', value: 'AssignedTreatmentBundleId__r.Name' },
            { label: 'Treatment Count', value: 'Animal__r.Number_of_Treatments__c' },
            { label: 'Shelter Color Code', value: 'Shelter_Color_Code__c' },
            { label: 'Sex', value: 'Animal__r.Gender__c' },
            { label: 'Age', value: 'Animal__r.Current_Animal_Age_Estimate__c' },
            { label: 'Grade', value: 'Animal__r.Current_Behavior_Grade__c' },
            { label: 'Location', value: 'Animal__r.Shelter_Location__c' },
        ];
    }

    get filterFieldOptions() {
        return [
            { label: 'Treatment Priority', value: 'Treatment_Priority__c' },
            { label: 'Bundle Assignment', value: 'AssignedTreatmentBundleId__r.Name' },
            { label: 'Treatment Count', value: 'Animal__r.Number_of_Treatments__c' },
            { label: 'Shelter Color Code', value: 'Shelter_Color_Code__c' },
            { label: 'Sex', value: 'Animal__r.Gender__c' },
            { label: 'Age', value: 'Animal__r.Current_Animal_Age_Estimate__c' },
            { label: 'Grade', value: 'Animal__r.Current_Behavior_Grade__c' },
            { label: 'Location', value: 'Animal__r.Shelter_Location__c' },
        ];
    }

    get sortDirectionOptions() {
        return [
            { label: 'A→Z/1→9', value: 'ASC' },
            { label: 'Z→A/9→1', value: 'DESC' },
        ];
    }

    get sortActive() {
        return this.addedSort.length > 0;
    }

    get filterActive() {
        return this.addedFilter.length > 0;
    }

    get smallForm() {
        return FORM_FACTOR === 'Small';
    }

    connectedCallback(){
        if(this.animalTreatments == null || this.animalTreatments == undefined){
            getAnimalTreatments({})
            .then((result) => {
                this.animalTreatments = result;
                if (result) {
                    this.animalTreatmentsData = result;
                    this.sortFilterData();
                }
                else if (result.error) {
                    const evt = new ShowToastEvent({
                        title: 'Error',
                        message: result.error,
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                }
            });
        }    
    }

    optionsFieldLabel(fieldValue, fieldOptions) {
        //returns the associated label for the specified field value
        return fieldOptions.filter(x => x.value === fieldValue)[0].label;
    }

    handleSortClick() {
        if (!this.sortFieldValue) {
            const evt = new ShowToastEvent({
                title: 'No value',
                message: 'Please select a field',
            });
            this.dispatchEvent(evt);
        }
        else {
            //get any current sort for the selected field value
            let oldSort = this.addedSort.filter(x => x.name === this.sortFieldValue);
            //get labels for display
            let fieldLabel = this.optionsFieldLabel(this.sortFieldValue, this.sortFieldOptions);
            let directionLabel = this.optionsFieldLabel(this.sortDirectionValue, this.sortDirectionOptions);
            //construct new sort object
            let newSort = {label: fieldLabel + ' ' + directionLabel, name: this.sortFieldValue, direction: this.sortDirectionValue};
            if (oldSort.length == 0) {
                //add new sort if no previous sort exists for the field
                this.addedSort.push(newSort);
            }
            else {
                //replace previous field sort with new selection
                const index = this.addedSort.map(x => x.name).indexOf(this.sortFieldValue);
                this.addedSort.splice(index, 1, newSort);
            }
            this.sortFilterData();
        }
    }

    handleClearSortClick() {
        this.addedSort = [];
        this.sortFilterData();
    }

    handleClearFilterClick() {
        this.addedFilter = [];
        this.sortFilterData();
    }

    handleFilterClick() {
        if (!this.filterFieldValue) {
            const evt = new ShowToastEvent({
                title: 'No value',
                message: 'Please select a field',
            });
            this.dispatchEvent(evt);
        }
        else {
            //get any current filter for the selected field value
            let oldFilter = this.addedFilter.filter(x => x.name === this.filterFieldValue);
            //get label for display
            let fieldLabel = this.optionsFieldLabel(this.filterFieldValue, this.filterFieldOptions);
            //construct new filter object
            let newFilter = {label: fieldLabel + ' = ' + this.filterValueValue, name: this.filterFieldValue, filtered: this.filterValueValue};
            if (oldFilter.length == 0) {
                //add new filter if no previous filter exists for the field
                this.addedFilter.push(newFilter);
            }
            else {
                //replace previous field filter with new selection
                const index = this.addedFilter.map(x => x.name).indexOf(this.filterFieldValue);
                this.addedFilter.splice(index, 1, newFilter);
            }
            this.sortFilterData();
        }
        //Clear selected values for next filter options populating
        this.resetFilterValues();
    }

    sortFilterData() {
        this.animalTreatmentSortFilter = Array.from(this.animalTreatmentsData ?? []);
        if (this.filterActive) {
            //handle filtering of data
            for (let i = 0; i < this.addedFilter.length; i++) {
                let name = this.addedFilter[i].name.split('.');
                let filtered = this.addedFilter[i].filtered;
                if (name.length == 1) {
                    this.animalTreatmentSortFilter = this.animalTreatmentSortFilter.filter(f => f[name] == filtered);
                }
                else {
                    this.animalTreatmentSortFilter = this.animalTreatmentSortFilter.filter(f => f[name[0]][name[1]] == filtered);
                }
            }
        }
        if (this.sortActive) {
            //handle sorting of data
            this.animalTreatmentSortFilter.sort((a, b) => {
                for (let i = 0; i < this.addedSort.length; i++) {
                    let name = this.addedSort[i].name.split('.');
                    let direction = this.addedSort[i].direction;
                    if (name.length == 1) {
                        if ((a[name] > b[name]) || (a[name] != undefined && b[name] == undefined)) {
                            return (direction === 'ASC') ? 1 : -1;
                        }
                        else if ((a[name] < b[name]) || (a[name] == undefined && b[name] != undefined)) {
                            return (direction === 'ASC') ? -1 : 1;
                        }
                    }
                    else {
                        if ((a[name[0]][name[1]] > b[name[0]][name[1]]) || (a[name[0]][name[1]] != undefined && b[name[0]][name[1]] == undefined)) {
                            return (direction === 'ASC') ? 1 : -1;
                        }
                        else if ((a[name[0]][name[1]] < b[name[0]][name[1]]) || (a[name[0]][name[1]] == undefined && b[name[0]][name[1]] != undefined)) {
                            return (direction === 'ASC') ? -1 : 1;
                        }
                    }
                }
            });
        }
    }

    resetFilterValues() {
        this.filterFieldValue = '';
        this.filterValueValue = '';
    }

    handleSortFieldChange(event) {
        this.sortFieldValue = event.detail.value;
    }

    handleFilterFieldChange(event) {
        this.filterFieldValue = event.detail.value;
        this.setFilterValues();
    }

    setFilterValues() {
        //Clear any null values from the current fields list of values
        let valueData = this.filterFieldValue.split('.');
        let fieldData;
        if (valueData.length == 1) {
            fieldData = [...new Set(this.animalTreatmentSortFilter.map(x => x[valueData]).filter(x => x != null))];
        }
        else {
            fieldData = [...new Set(this.animalTreatmentSortFilter.map(x => x[valueData[0]][valueData[1]]).filter(x => x != null))];
        }
        //Populate filter value options from non-null data
        this.filterValueOptions = fieldData.map(x => ({label: x.toString(), value: x.toString()}));
    }

    handleSortDirectionChange(event) {
        this.sortDirectionValue = event.detail.value;
    }

    handleFilterValueChange(event) {
        this.filterValueValue = event.detail.value;
    }

    handlePdf() {
        let url = '/apex/TreatmentToDoPdf';
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        });
    }

    handleRemoveSort(event) {
        const name = event.detail.item.name;
        this.addedSort = this.addedSort.filter(x => x.name !== name);
        this.sortFilterData();
    }

    handleRemoveFilter(event) {
        const name = event.detail.item.name;
        this.addedFilter = this.addedFilter.filter(x => x.name !== name);
        this.sortFilterData();
        this.resetFilterValues();
    }

    handleUpdate() {
        this.resetFilterValues();
        refreshApex(this.animalTreatments)
        .then(() => {
            this.sortFilterData();
        });
    }
}