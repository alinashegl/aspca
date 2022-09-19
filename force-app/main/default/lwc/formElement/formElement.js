import { LightningElement, api } from 'lwc';

const LISTCLASS = 'slds-list slds-border_bottom';
export default class FormElement extends LightningElement {
    _mode;
    _type;
    _label;
    _value;
    _options;
    _size;
    _variant;
    _helpText;
    href;
    editMode = false;
    isRequired = false;
    isReadOnly = false;
    isConnected = false;

    isText;
    isTextArea;
    isPicklist;
    isMultiSelect;
    isCheckbox;
    isLink;
    isLookup;
    isDate;
    isDateTime;
    isNumber;
    isCurrency;
    isPercent;
    isLinkAction;
    isImageAction;
    isButtonIcon;
    listClass = 'slds-list_stacked '+LISTCLASS;
    detailClass = 'slds-item_detail vk-form-font';
    helpTextClass = '';
    editIconClass = 'slds-button slds-button_icon';
    isTableElement = false;

    @api rowIndex;
    @api colIndex;
    @api name;
    @api title;
    @api placeHolder;    

    @api linkLabel;
    @api actionName;

    @api numberFormat;
    @api currencyCode;
    @api maxFractionDigits;
    @api minFractionDigits;
    @api minValue;
    @api maxValue;

    @api iconName;
    @api iconSize;
    @api iconVariant = 'bare';
    @api imageSource;
    @api disabled;

    @api set mode(value){
        this._mode = value ? value : 'view';
        this.editMode = value === 'edit';
        this.handleElementClass();
    }
    get mode(){
        return this._mode;
    }
    @api set type(value){
        value = value ? value : 'text';
        this._type = value;
        console.log(value);
        this.isText = value.toLowerCase() === 'text' || value.toLowerCase() === 'string';
        this.isTextArea = value.toLowerCase() === 'textarea';
        this.isPicklist = value.toLowerCase() === 'picklist';
        this.isMultiSelect = value.toLowerCase() === 'multi-select';
        this.isCheckbox = value.toLowerCase() === 'checkbox' || value.toLowerCase() === 'boolean';
        this.isLookup = value.toLowerCase() === 'lookup' || value.toLowerCase() === 'reference';
        this.isDate = value.toLowerCase() === 'date';
        this.isDateTime = value.toLowerCase() === 'date-time' || value.toLowerCase() === 'datetime';
        this.isNumber = value.toLowerCase() === 'number' || value.toLowerCase() === 'integer';
        this.isCurrency = value.toLowerCase() === 'currency';
        this.isPercent = value.toLowerCase() === 'percent';
        this.isLink = value.toLowerCase() === 'link';
        this.isLinkAction = value.toLowerCase() === 'link-action';
        this.isImageAction = value.toLowerCase() === 'image-action';
        this.isButtonIcon = value.toLowerCase() === 'button-icon';
    }
    get type(){
        return this._type;
    }
    @api set label(value){
        this._label = value ? value : '';
    }
    get label(){
        return this._label;
    }
    @api set value(value){
        this._value = value ? value : '';
        if(this.isLookup && this.isConnected) this.populateLookupValue(this._value);
    }
    get value(){
        return this._value;
    }
    @api set options(value){
        this._options = value ? JSON.parse(JSON.stringify(value)) : [];
    }
    get options(){
        return this._options;
    }
    @api set required(value){
        this.isRequired = value ? value : false;
    }
    get required(){
        return this.isRequired;
    }
    @api set readOnly(value){
        this.isReadOnly = value ? value : false;
    }
    get readOnly(){
        return this.isReadOnly;
    }
  /*  
    get isDisabled(){
        return this.isReadOnly ? true: false;
    } 
*/
    @api set size(value){
        this._size = value ? value : '';
    }
    get size(){
        return this._size;
    }
    @api set target(value){
        this._target = value ? value : '_blank';
    }
    get target(){
        return this._target;
    }
    @api set variant(value){ //label-inline, label-hidden, and label-stacked
        this._variant = value ? value : 'label-stacked';
    }
    get variant(){
        return this._variant;
    }
    @api set helpText(value){
        this._helpText = value ? value : '';
    }
    get helpText(){
        return this._helpText;
    }
    @api set tableElement(value){
        this.isTableElement = value ? value : false;
        this.handleElementClass();
    }
    get tableElement(){
        return this.isTableElement;
    }
    
    connectedCallback(){
        this.isConnected = true;
        this.href = this.isLink && this._value ? '/'+this._value : '';
        this.readOnly = this.isLink;
        if(this.isLookup) this.populateLookupValue(this._value);
    }

    disconnectedCallback() {
        this.isConnected = false;
    }

    populateLookupValue(value){
        if(this._options){
            this._options.forEach(opt => {
                if(value && value === opt.value){
                    this.linkLabel = opt.label;
                    this.href = '/'+value;
                }
            });
        }else{
            this.linkLabel = value;
            this.href = '/'+value;
        }
    }

    handleElementClass(){
        this.listClass = this.editMode ? 'slds-list' : LISTCLASS;
        if(!this.isTableElement){
            this.listClass += this._variant === 'label-inline' ? ' slds-list_horizontal' : ' slds-list_stacked';
            this.helpTextClass = this._variant === 'label-inline' ? 'slds-col_bump-left' : '';
        }else{
            this.editIconClass += ' table-edit-icon';
            this.listClass = 'slds-list_stacked';
            this.detailClass = 'slds-item_detail';
        }
    }

    handleEditing(){
        if(!this.isReadOnly) this.editElement();
    }

    @api
    editElement(){
        if(this.isMultiSelect && this._value){
            let selValues = this._value.split(";");
            this.options.forEach(element => {
                if(selValues.includes(element.value)){
                    element.selected = true;
                }
            });
        }
        this.editMode = true;
        let obj = {};
        if(this.isTableElement){
            obj = {rowIndex: this.rowIndex, colIndex: this.colIndex};
        }else{
            this.template.querySelector('.slds-list').classList.remove('slds-border_bottom');
        }
        this.dispatchEvent(new CustomEvent('edit', {detail: obj}));
    }

    sendValue(event){
        let obj = {};
        obj.value = event.target.value;
        if(this.isTableElement){
            obj.rowIndex = this.rowIndex;
            obj.colIndex = this.colIndex; 
            obj.name = this.name;
        }
        this.dispatchEvent(new CustomEvent('valuechange', {detail: obj}));
    }

    handleMultiSelectChange(event){
        //let selections = this.template.querySelector('c-mutli-select-picklist');
        let obj = {};
        obj.value = event.detail;
        if(this.isTableElement){
            obj.rowIndex = this.rowIndex;
            obj.colIndex = this.colIndex; 
            obj.name = this.name;
        }
        this.dispatchEvent(new CustomEvent('multiselectchange', {detail: obj}));
        console.log(obj);
    }
    
    @api
    closeEditMode(){
        this.editMode = false;
        if(!this.isTableElement) this.template.querySelector('.slds-list').classList.add('slds-border_bottom');
    }

    handleLookupChange(event){
        this.linkLabel = event.detail.label;

        let obj = {rowIndex: this.rowIndex, colIndex: this.colIndex, name: this.name, value: event.detail.value, label: event.detail.label};
        this.dispatchEvent(new CustomEvent('valuechange', {detail: obj}));
    }

    handleAction(event){
        let currentNode = event.target;
        if(!currentNode.name) currentNode = currentNode.parentNode;
        let actionName = currentNode.name;
        let obj ={rowIndex: this.rowIndex, colIndex: this.colIndex, actionName: actionName};
        this.dispatchEvent(new CustomEvent('action', {detail: obj}));
    }
}