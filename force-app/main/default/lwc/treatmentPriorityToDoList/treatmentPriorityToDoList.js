import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import FORM_FACTOR from '@salesforce/client/formFactor';
import getAnimalTreatments from '@salesforce/apex/TreatmentToDoListController.getAnimalTreatments';

export default class TreatmentPriorityToDoList extends NavigationMixin(LightningElement) {
    location = 'MRC';
    @track
    addedSort = [];
    @track
    addedFilter = [];
    @track
    filterValueOptions = [];
    animalTreatments;
    animalTreatmentsData;
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
            //{ label: 'Name', value: 'Animal_Name__c' },
            //{ label: 'ID#', value: 'Name' },
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

    get sortString() {
        //Formatted string value for use in sorting data
        let sortValues = '';
        if (this.addedSort.length > 0) {
            sortValues = this.addedSort.map(x => x.qryValue).join(',');
        }
        return sortValues;
    }

    get filterString() {
        //Formatted string value for use in filtering data
        let filterValues = '';
        if (this.addedFilter.length > 0) {
            filterValues = ' AND ' + this.addedFilter.map(x => x.qryValue).join(' AND ') + ' ';
        }
        return filterValues;
    }

    get formattedFilterValue() {
        let formattedValue = '';
        //Handle boolean values separately from strings
        if (this.filterValueValue === 'true' || this.filterValueValue === 'false') {
            formattedValue = this.filterValueValue;
        }
        else {
            formattedValue = '\'' + this.filterValueValue + '\'';
        }
        return formattedValue;
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

    @wire(getAnimalTreatments, { location: '$location', sortString: '$sortString', filterString: '$filterString'})
    wiredAnimalTreatments(result) {
        this.animalTreatments = result;
        if (result.data) {
            this.animalTreatmentsData = result.data;
        }
        else if (result.error) {
            const evt = new ShowToastEvent({
                title: 'Error',
                message: result.error,
                variant: 'error',
            });
            this.dispatchEvent(evt);
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
            let newSort = {label: fieldLabel + ' ' + directionLabel, name: this.sortFieldValue, qryValue: this.sortFieldValue + ' ' + this.sortDirectionValue};
            if (oldSort.length == 0) {
                //add new sort if no previous sort exists for the field
                this.addedSort.push(newSort);
            }
            else {
                //replace previous field sort with new selection
                const index = this.addedSort.map(x => x.name).indexOf(this.sortFieldValue);
                this.addedSort.splice(index, 1, newSort);
            }
        }
    }

    handleClearSortClick() {
        this.addedSort = [];
    }

    handleClearFilterClick() {
        this.addedFilter = [];
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
            let newFilter = {label: fieldLabel + ' = ' + this.filterValueValue, name: this.filterFieldValue, qryValue: this.filterFieldValue + ' = ' + this.formattedFilterValue};
            if (oldFilter.length == 0) {
                //add new filter if no previous filter exists for the field
                this.addedFilter.push(newFilter);
            }
            else {
                //replace previous field filter with new selection
                const index = this.addedFilter.map(x => x.name).indexOf(this.filterFieldValue);
                this.addedFilter.splice(index, 1, newFilter);
            }
        }
        //Clear selected values for next filter options populating
        this.resetFilterValues();
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
        let fieldData = [...new Set(this.animalTreatmentsData.map(x => x[this.filterFieldValue]).filter(x => x != null))];
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
    }

    handleRemoveFilter(event) {
        const name = event.detail.item.name;
        this.addedFilter = this.addedFilter.filter(x => x.name !== name);
        this.resetFilterValues();
    }

    handleUpdate() {
        this.resetFilterValues();
        refreshApex(this.animalTreatments);
    }
}