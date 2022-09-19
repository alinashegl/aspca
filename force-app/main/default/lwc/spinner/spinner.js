import { LightningElement, api } from 'lwc';

const SPINNER_CLASS = 'slds-spinner';
const MESSAGE_CLASS = 'spinner-msg';
export default class Spinner extends LightningElement {
    _size = 'medium'; //Supports all the valid values of lightning:spinner, 
                      //but spinner message will be supported only for small, medium and large.
    _variant = 'base' //Valid values: base, brand, inverse
    _message = 'Loading...';
    _hideBackground = false;

    containerClass = 'slds-spinner_container';
    spinnerClass = SPINNER_CLASS+' '+SPINNER_CLASS+'_'+this._size+' '+SPINNER_CLASS+'_'+this._variant;
    messageClass = MESSAGE_CLASS+' '+MESSAGE_CLASS+'_'+this._size+' slds-color_'+this._variant;

    @api
    set size(value){
        this._size = value ? value : 'medium';
    }
    get size(){
        return this._size;
    }

    @api 
    set variant(value){
        this._variant = value ? value : 'base';
    }
    get variant(){
        return this._variant;
    }

    @api
    set message(value){
        this._message = value ? value : 'Loading...';
    }
    get message(){
        return this._message;
    }

    connectedCallback(){
        this.spinnerClass = SPINNER_CLASS+' '+SPINNER_CLASS+'_'+this._size+' '+SPINNER_CLASS+'_'+this._variant;
        this.messageClass = MESSAGE_CLASS+' '+MESSAGE_CLASS+'_'+this._size+' slds-color_'+this._variant;
        if(this._size == 'xx-small' || this._size == 'x-small') this.messageClass = 'slds-hide';
        this.containerClass += this._variant == 'inverse' ? ' slds-inverse_background' : '';
    }
}