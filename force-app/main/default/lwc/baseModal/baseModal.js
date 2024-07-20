import { LightningElement, api } from 'lwc';

export default class BaseModal extends LightningElement {

    @api title;
    @api buttonConfirm = 'Ok';
    @api showHeader;
    @api showFooter;
    
    handleClose(){
        this.eventDispatcher('close');
    }

    handleCancel(){
        this.eventDispatcher('cancel');
    }
    
    handleConfirm(){
        this.eventDispatcher('confirm');
    }

    eventDispatcher(eventName, eventBody){

        if(!eventName) return;

        let payload = eventBody || {};

        const event = new CustomEvent(eventName, payload);
        this.dispatchEvent(event);
    }
}