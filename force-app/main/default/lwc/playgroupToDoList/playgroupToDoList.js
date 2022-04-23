import { api, LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import FORM_FACTOR from '@salesforce/client/formFactor';
import getPlaygroupAnimals from '@salesforce/apex/PlaygroupToDoListController.getPlaygroupAnimals';
import createPlaygroup from '@salesforce/apex/PlaygroupToDoListController.createPlaygroup';
import copyPlaygroupSession from '@salesforce/apex/PlaygroupToDoListController.copyPlaygroupSession';
import editPlaygroup from '@salesforce/apex/PlaygroupToDoListController.editPlaygroup';
import getUserLocation from '@salesforce/apex/PlaygroupToDoListController.getUserLocation';
import getReportId from '@salesforce/apex/PlaygroupToDoListController.getReportId';


export default class PlaygroupToDoList extends NavigationMixin(LightningElement) {
    @track errorMsg;
    @track reportID;
    
    location;
    //exposed properties for "copy playgroup" and "edit playgroup"
    @api
    sessionId;
    @api
    animalsToAdd = [];
    //default action value to new if none supplied
    @api
    action = 'new';
    //internally tracked list of animals since @api does not track the contents of arrays
    @track
    animalsToAddInternal = [];
    @track
    addedSort = [];
    @track
    addedFilter = [];
    @track
    filterValueOptions = [];
    actionLabels = [
        {label: 'Start PG', value: 'new'},
        {label: 'Save & Start PG', value: 'copy'},
        {label: 'Save & Continue', value: 'edit'}
    ];
    //result for refreshApex
    playgroupAnimals;
    //holds actual data from server call
    playgroupAnimalsData;
    //displayed data that sorts/filters on client side
    playgroupAnimalsSortFilter;
    sortFieldValue;
    sortDirectionValue = 'ASC';
    filterFieldValue;
    filterValueValue;
    hasRendered = false;

    get actionLabel() {
        return this.optionsFieldLabel(this.action, this.actionLabels);
    }

   handleGetReportUrl() {
        getReportId()
        .then(result => {
            this.reportID = result;
            var Url='/'+this.reportID;
            window.open(Url, "_blank");
        })

            .catch(error => {
                this.errorMsg = error;
            })
    }

    get sortFieldOptions() {
        return [
            { label: 'Name', value: 'Animal_Name__c' },
            { label: 'ID#', value: 'Name' },
            { label: 'Sex', value: 'Gender__c' },
            { label: 'Kennel Location', value: 'Shelter_Location__c' },
            { label: '# of Playgroups', value: 'Number_of_Playgroups__c' },
            { label: 'Playgroup Today?', value: 'Animal_Playgroups__r.Id' },
            { label: 'Does Not Walk on Leash', value: 'Does_Not_Walk_on_a_Leash__c' },
            { label: 'Playgroup Priority Level', value: 'Playgroup_Priority_Level__c' },
            { label: 'Play Category', value: 'Play_Category__c' },
            { label: 'Handler Code', value: 'Shelter_Color_Coding__c' },
            { label: 'Medical Condition', value: 'Medical_Conditions__r.Id' },
            { label: 'Behavior Condition', value: 'Play_Pauses__r.Id' },
        ];
    }

    get filterFieldOptions() {
        return [
            { label: 'Sex', value: 'Gender__c' },
            { label: 'Kennel Location', value: 'Shelter_Location__c' },
            { label: '# of Playgroups', value: 'Number_of_Playgroups__c' },
            { label: 'Playgroup Today?', value: 'Animal_Playgroups__r.Id' },
            { label: 'Does Not Walk on Leash', value: 'Does_Not_Walk_on_a_Leash__c' },
            { label: 'Playgroup Priority Level', value: 'Playgroup_Priority_Level__c' },
            { label: 'Play Category', value: 'Play_Category__c' },
            { label: 'Handler Code', value: 'Shelter_Color_Coding__c' },
            { label: 'Medical Condition', value: 'Medical_Conditions__r.Id' },
            { label: 'Behavior Condition', value: 'Play_Pauses__r.Id' },
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

    get isNew() {
        return this.action === 'new';
    }

    @wire(getPlaygroupAnimals, { location: '$location'})
    wiredPlaygroupAnimals(result) {
        this.playgroupAnimals = result;
        if (result.data) {
            this.playgroupAnimalsData = result.data;
            this.sortFilterData();
            if (this.sessionId) {
                //Format data for display as selected pill
                for (let i = 0; i < this.animalsToAdd.length; i++) {
                    let animal = this.playgroupAnimalsData.filter(x => x.Id === this.animalsToAdd[i]);
                    if (animal.length > 0) {
                        const dogId = animal[0].Id;
                        const dogName = animal[0].Animal_Name__c + ' (' + animal[0].Name + ')';
                        this.animalsToAddInternal.push({label: dogName, name: dogId});
                    }
                }
            }
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

    renderedCallback() {
        //only execute rendered logic when buttons exist and use hasRendered to only execute once
        if (!this.hasRendered && this.template.querySelectorAll("lightning-button-icon-stateful").length > 0) {
            this.hasRendered = true;
            //selection for "copy or edit playgroup" requires both a sessionId and a list of animals
            if (this.sessionId && this.animalsToAdd.length !== 0) {
                this.toggleSelections();
            }
        }

        //only execute if location is not set
        if(this.location == undefined || this.location == null){
            getUserLocation()
            .then((response) => {
                this.location = response;
            })
            .catch((result) => {
                window.console.log('result: ', JSON.stringify(result));
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: result,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            })
        }
    }

    handleClick(event) {
        //dog info to add to list
        const dogId = event.target.dataset.id;
        const dogName = event.target.dataset.name + ' (' + event.target.dataset.idname + ')';
        //toggle button state
        let iconButton = event.target;
        iconButton.selected = !iconButton.selected;
        if (iconButton.selected) {
            //add selected dog
            this.animalsToAddInternal.push({label: dogName, name: dogId});
        }
        else {
            //remove unselected dog
            this.animalsToAddInternal = this.animalsToAddInternal.filter(x => x.name !== dogId);
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
        this.playgroupAnimalsSortFilter = Array.from(this.playgroupAnimalsData ?? []);
        if (this.filterActive) {
            //handle filtering of data
            for (let i = 0; i < this.addedFilter.length; i++) {
                let name = this.addedFilter[i].name.split('.');
                let filtered = this.addedFilter[i].filtered;
                if (name.length == 1) {
                    this.playgroupAnimalsSortFilter = this.playgroupAnimalsSortFilter.filter(f => (filtered === 'true' ? f[name] == true : (filtered === 'false' ? f[name] == false : f[name] == filtered)));
                }
                else {
                    if (name[0] === 'Medical_Conditions__r') {
                        this.playgroupAnimalsSortFilter = this.playgroupAnimalsSortFilter.filter(f => f.Medical_Conditions__r != null);
                    }
                    else if (name[0] === 'Play_Pauses__r') {
                        this.playgroupAnimalsSortFilter = this.playgroupAnimalsSortFilter.filter(f => f.Play_Pauses__r != null);
                    }
                    else if (name[0] === 'Animal_Playgroups__r') {
                        this.playgroupAnimalsSortFilter = this.playgroupAnimalsSortFilter.filter(f => (filtered === 'true' ? f.Animal_Playgroups__r != null : f.Animal_Playgroups__r == null));
                    }
                    else {
                        this.playgroupAnimalsSortFilter = this.playgroupAnimalsSortFilter.filter(f => f[name[0]][name[1]] == filtered);
                    }
                }
            }
        }
        if (this.sortActive) {
            //handle sorting of data
            this.playgroupAnimalsSortFilter.sort((a, b) => {
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
                        //this handles only whether the comparisons have data or don't have data
                        //need other comparisons if new fields are added that are related fields
                        //instead of child query relations that these currently work for
                        if (a[name[0]] != undefined && b[name[0]] == undefined) {
                            return (direction === 'ASC') ? 1 : -1;
                        }
                        else if (a[name[0]] == undefined && b[name[0]] != undefined) {
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
            fieldData = [...new Set(this.playgroupAnimalsSortFilter.map(x => x[valueData]).filter(x => x != null))];
        }
        else {
            fieldData = [];
            if (valueData[0] === 'Medical_Conditions__r') {
                if (this.playgroupAnimalsSortFilter.filter(x => x.Medical_Conditions__r != null).length > 0) {
                    fieldData = ['Babesia +'];
                }
            }
            else if (valueData[0] === 'Play_Pauses__r') {
                if (this.playgroupAnimalsSortFilter.filter(x => x.Play_Pauses__r != null).length > 0) {
                    fieldData = ['In Heat'];
                }
            }
            else if (valueData[0] === 'Animal_Playgroups__r') {
                if (this.playgroupAnimalsSortFilter.filter(f => f.Animal_Playgroups__r == null).length > 0) {
                    fieldData = [false, ...fieldData];
                }
                if (this.playgroupAnimalsSortFilter.filter(f => f.Animal_Playgroups__r != null).length > 0) {
                    fieldData = [true, ...fieldData];
                }
            }
            else {
                fieldData = [...new Set(this.playgroupAnimalsSortFilter.map(x => x[valueData[0]][valueData[1]]).filter(x => x != null))];
            }
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
        let url = '/apex/PlaygroupToDoPdf?location=' + this.location;
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        });
    }

    handleRemoveAnimal(event) {
        const name = event.detail.item.name;
        //de-select the stateful button for the animal and remove from the tracked array
        let iconButton = this.template.querySelector(`[data-id="${name}"]`);
        iconButton.selected = !iconButton.selected;
        this.animalsToAddInternal = this.animalsToAddInternal.filter(x => x.name !== name);
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

    toggleSelections() {
        //add "copy playgroup" list of animals to tracked array
        for (let i = 0; i < this.animalsToAdd.length; i++) {
            let iconButton = this.template.querySelector(`[data-id="${this.animalsToAdd[i]}"]`);
            if (iconButton) {
                iconButton.selected = !iconButton.selected;
            }
        }
    }

    resetSelected() {
        //resets stateful buttons and tracked array to all de-selected state
        let selected = this.template.querySelectorAll("lightning-button-icon-stateful");
        for(let i = 0; i < selected.length; i++) {
            if (selected[i].selected) {
                selected[i].selected = false;
            }
        }
        this.animalsToAddInternal = [];
    }

    handleAction() {
        //prevent the user from attempting to add a playgroup with no animals selected
        if (this.animalsToAddInternal.length === 0) {
            const evt = new ShowToastEvent({
                title: 'No animal selected',
                message: 'Check animals to add to a playgroup',
            });
            this.dispatchEvent(evt);
        }
        else {
            //get list of animal Ids for controller call
            let animals = this.animalsToAddInternal.map(a => a.name);
            //sessionId having a value means we are copying an existing playgroup
            if (this.sessionId && this.action == 'copy') {
                //copy existing playgroup with list of selected animals
                copyPlaygroupSession({ sessionId: this.sessionId, animalsToAdd: animals })
                    .then(result => {
                        //id: result is the new sessionId value
                        this.dispatchEvent(new CustomEvent('copy', {detail: {id: result, error: null}}));
                    })
                    .catch(error => {
                        this.dispatchEvent(new CustomEvent('copy', {detail: {id: null, error: error}}));
                    })
            }
            else if(this.action == 'edit'){
                editPlaygroup({ sessionId: this.sessionId, animalsToAdd: animals  })
                    .then(result => {
                    //id: result is the new sessionId value
                    this.dispatchEvent(new CustomEvent('edit', {detail: {id: result, error: null}}));
                })
                .catch(error => {
                    this.dispatchEvent(new CustomEvent('edit', {detail: {id: null, error: error}}));
                })
            }
            else {
                //create new playgroup with list of selected animals
                createPlaygroup({ animals: animals })
                    .then(result => {
                        if (!result.startsWith('Error')) {
                            this[NavigationMixin.Navigate]({
                                type: 'standard__recordPage',
                                attributes: {
                                    recordId: result,
                                    actionName: 'view',
                                }
                            });
                        }
                        else {
                            const evt = new ShowToastEvent({
                                title: 'Error',
                                message: result,
                                variant: 'error',
                            });
                            this.dispatchEvent(evt);
                        }
                    })
                    .catch(error => {
                        const evt = new ShowToastEvent({
                            title: 'Error',
                            message: error,
                            variant: 'error',
                        });
                        this.dispatchEvent(evt);
                    });
            }
        }
    }

    handleUpdate() {
        this.resetFilterValues();
        refreshApex(this.playgroupAnimals)
        .then(() => {
            this.sortFilterData();
        });
    }

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }
}