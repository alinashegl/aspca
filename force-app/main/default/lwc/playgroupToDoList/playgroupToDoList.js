import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import FORM_FACTOR from '@salesforce/client/formFactor';
import getPlaygroupAnimals from '@salesforce/apex/PlaygroupToDoListController.getPlaygroupAnimals';
import createPlaygroup from '@salesforce/apex/PlaygroupToDoListController.createPlaygroup';

export default class PlaygroupToDoList extends NavigationMixin(LightningElement) {
    location = 'MRC';
    @track
    animalsToAdd = [];

    @wire(getPlaygroupAnimals, { location: '$location'})
    playgroupAnimals;

    handleClick(event) {
        //dog info to add to list
        const dogId = event.target.dataset.id;
        const dogName = event.target.dataset.name;
        //toggle button state
        let iconButton = event.target;
        iconButton.selected = !iconButton.selected;
        if (iconButton.selected) {
            //add selected dog
            this.animalsToAdd.push({label: dogName, name: dogId});
        }
        else {
            //remove unselected dog
            this.animalsToAdd = this.animalsToAdd.filter(x => x.name !== dogId);
        }
    }

    handleRemoveAnimal(event) {
        const name = event.detail.item.name;
        let iconButton = this.template.querySelector(`[data-id="${name}"]`);
        iconButton.selected = !iconButton.selected;
        this.animalsToAdd = this.animalsToAdd.filter(x => x.name !== name);
    }

    resetSelected() {
        let selected = this.template.querySelectorAll("lightning-button-icon-stateful");
        for(let i = 0; i < selected.length; i++) {
            if (selected[i].selected) {
                selected[i].selected = false;
            }
        }
        this.animalsToAdd = [];
    }

    handleAdd() {
        if (this.animalsToAdd.length === 0) {
            const evt = new ShowToastEvent({
                title: 'No animal selected',
                message: 'Check animals to add to a playgroup',
            });
            this.dispatchEvent(evt);
        }
        let animals = this.animalsToAdd.map(a => a.name);
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