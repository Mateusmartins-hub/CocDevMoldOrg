import { LightningElement, api, wire } from 'lwc'
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi'
import { refreshApex } from '@salesforce/apex'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

import { fieldsCase, fieldsParam } from './fieldsCase'
 
export default class BreadCrumbGruposSolucionadores extends LightningElement {
    @api recordId
    case

    @wire(getRecord, { recordId: '$recordId', fields: [...fieldsCase] })
    wiredCase({ error, data }) {

        if (error) {
            let message = 'Erro desconhecido'
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ')
            } else if (typeof error.body.message === 'string') {
                message = error.body.message
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erro ao buscar o caso',
                    message,
                    variant: 'error',
                }),
            )
        } else if (data) {
            this.case = data
        }
    }

    get grupoSolucionadorAtual() {
        return getFieldValue(this.case, 'Case.GrupoSolucionador__c');
    }

    get historicoGruposSolucionadores() {
        let historico = getFieldValue(this.case, 'Case.HistoricoGruposSolucionadores__c');
        return historico && JSON.parse(getFieldValue(this.case, 'Case.HistoricoGruposSolucionadores__c'))
    }
}