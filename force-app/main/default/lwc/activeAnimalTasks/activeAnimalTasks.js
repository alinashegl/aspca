import { LightningElement, api, wire, track } from 'lwc';
import getAnmialTasks from '@salesforce/apex/HomePageController.getAnmialTasks';

export default class ActiveAnimalTasks extends LightningElement {
    columns = [{
        label: 'Animal Name',
        fieldName: 'animalName',
        type: 'text',
        sortable: true
    },
    {
        label: 'Task Subject',
        fieldName: 'taskUrl',
        wrapText: true,
        type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'subject'
            },
            target: '_blank'
        }
    },
    {
        label: 'Task Type',
        fieldName: 'taskType',
        type: 'text',
        sortable: true
    },
    {
        label: 'ID#',
        fieldName: 'animalNameId',
        type: 'text',
        sortable: true
    },
    {
        label: 'Gender',
        fieldName: 'animalGender',
        type: 'text',
        sortable: true
    },
    {
        label: 'Kennel Location',
        fieldName: 'kennelLocation',
        type: 'text',
        sortable: true
    },
    {
        label: 'Shelter Color Code',
        fieldName: 'colorCode',
        type: 'text',
        sortable: true
    }
    ];

    error;
    taskList =[];
    @track totalRecordCount = 0;
    rowLimit = 10;
    rowOffSet = 0;
    showSpinner = false;

    connectedCallback(){
        this.loadData();
    }

    loadData() {
        //this.showSpinner = true;
        return getAnmialTasks({ limitSize: this.rowLimit, offset: this.rowOffSet })
            .then(result => {
                if(result && result.length > 0){
                    this.totalRecordCount =  result.length;
                    let updatedRecords = [...this.taskList, ...result];
                    this.taskList = updatedRecords;
                    this.error = undefined;
                }
            })
            .catch(error => {
                this.error = error;
                this.taskList = undefined;
            }).finally(()=>{
                this.showSpinner = false;
            })
    }

    handleScroll(event) {
		let area = this.template.querySelector('.scrollArea');
        let threshold = 2 * event.target.clientHeight;
        let areaHeight = area.clientHeight;
        let scrollTop = event.target.scrollTop;
        if(areaHeight - threshold < scrollTop) {
			if(this.rowOffSet === 2000){
				this.rowLimit = 2000;
			} else {
				this.rowOffSet += 10;
			}
			this.loadData();
        }
    }

}