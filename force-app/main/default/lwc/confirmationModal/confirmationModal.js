import { LightningElement, api } from 'lwc';
 
export default class ConfirmationModal extends LightningElement {
    @api text = '';
    @api neutralButton = '';
    @api brandButton = '';

    confirmationcloseclick() {
        this.dispatchEvent(new CustomEvent('confirmationcloseclick'));
    }

    confirmationokclick() {
        this.dispatchEvent(new CustomEvent('confirmationokclick'));
    }
}