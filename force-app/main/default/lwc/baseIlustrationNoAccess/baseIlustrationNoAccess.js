import { LightningElement, api } from 'lwc';

export default class BaseIlustrationNoAccess extends LightningElement {
    @api message;
    @api color = 'blue';

    get svgClass(){
        return `slds-illustration__svg ${this.color}`;
    }
    
}