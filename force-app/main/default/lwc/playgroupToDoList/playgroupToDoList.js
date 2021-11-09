import { api, LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import FORM_FACTOR from '@salesforce/client/formFactor';
import getPlaygroupAnimals from '@salesforce/apex/PlaygroupToDoListController.getPlaygroupAnimals';
import createPlaygroup from '@salesforce/apex/PlaygroupToDoListController.createPlaygroup';
import copyPlaygroupSession from '@salesforce/apex/PlaygroupToDoListController.copyPlaygroupSession';
import editPlaygroup from '@salesforce/apex/PlaygroupToDoListController.editPlaygroup';

export default class PlaygroupToDoList extends NavigationMixin(LightningElement) {
    location = 'MRC';
    //exposed properties for "copy playgroup"
    @api
    sessionId;
    @api
    animalsToAdd = [];
    @api
    action;
    //internally tracked list of animals since @api does not track the contents of arrays
    @track
    animalsToAddInternal = [];
    hasRendered = false;

    @wire(getPlaygroupAnimals, { location: '$location'})
    playgroupAnimals;

    renderedCallback() {
        //only execute rendered logic when buttons exist and use hasRendered to only execute once
        if (!this.hasRendered && this.template.querySelectorAll("lightning-button-icon-stateful").length > 0) {
            this.hasRendered = true;
            //selection for "copy playgroup" requires both a sessionId and a list of animals
            if (this.sessionId && this.animalsToAdd.length !== 0) {
                this.addAnimals();
            }
            //on initial load, add PG Re-Eval styling
            this.styleCategory();
        }
    }

    handleClick(event) {
        //dog info to add to list
        const dogId = event.target.dataset.id;
        const dogName = event.target.dataset.name;
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

    styleCategory() {
        let category = this.template.querySelectorAll('[data-id="category"]');
        //adds red bold styling to categories with PG Re-Eval value
        for (let i = 0; i < category.length; i++) {
            if (category[i].value === 'PG Re-Eval') {
                category[i].classList.add('categoryHighlight');
            }
            else {
                category[i].classList.remove('categoryHighlight');
            }
        }
    }

    handleRemoveAnimal(event) {
        const name = event.detail.item.name;
        //de-select the stateful button for the animal and remove from the tracked array
        let iconButton = this.template.querySelector(`[data-id="${name}"]`);
        iconButton.selected = !iconButton.selected;
        this.animalsToAddInternal = this.animalsToAddInternal.filter(x => x.name !== name);
    }

    addAnimals() {
        //add "copy playgroup" list of animals to tracked array
        this.animalsToAddInternal = Array.from(this.animalsToAdd);
        for (let i = 0; i < this.animalsToAdd.length; i++) {
            //select each stateful button for the animal list
            let iconButton = this.template.querySelector(`[data-id="${this.animalsToAdd[i].name}"]`);
            if(iconButton){
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

    get smallForm() {
        return FORM_FACTOR === 'Small';
    }

    handleAdd() {
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
            else if(this.action == 'new'){
                createPlaygroup({ animals: animals })
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
                            this[NavigationMixin.GenerateUrl]({
                                type: 'standard__recordPage',
                                attributes: {
                                    recordId: result,
                                    actionName: 'view',
                                },
                            }).then((url) => {
                                //showing new sessionId not allowed in Mobile toast messages
                                const message = FORM_FACTOR === 'Large' ? 'Playgroup {0} created!' : 'Playgroup created!';
                                const event = new ShowToastEvent({
                                    title: 'Success!',
                                    message: message,
                                    messageData: [
                                        {
                                            url: url,
                                            label: result,
                                        },
                                    ],
                                    variant: 'success',
                                });
                                this.dispatchEvent(event);
                                //reset and refresh
                                this.resetSelected();
                                refreshApex(this.playgroupAnimals);
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
        refreshApex(this.playgroupAnimals)
            .then(() => {
                //re-evaluate whether category needs styling on refreshes
                this.styleCategory();
            });
    }
}