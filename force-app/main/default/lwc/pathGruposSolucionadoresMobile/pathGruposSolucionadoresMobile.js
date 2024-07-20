import { LightningElement, api, wire } from 'lwc'
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi'
import { refreshApex } from '@salesforce/apex'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import isUserOnQueueMethod from '@salesforce/apex/AllUsersFromQueue.isUserOnQueue'

import { fieldsCase, fieldsParam } from './fieldsCase'
import buildGroups from './buildGroups'

export default class pathGruposSolucionadores extends LightningElement {
    @api recordId
    case
    grupoSolucionadorSelecionado
    loading = true
    displayModal = false
    divScrollableClass
    divGradientClass
    isDivScrollable
    divColScrollableClass
    errorParam
    errorEntitlement
    erroInit = false
    msgErroInit
    isUserOnQueue = false

    constructor() {
        super()
        this.conditions = {
            "checkedGroup": this.buildGrupoCheckado,
            "disabledGroup": this.buildGrupoDesativado,
            "activeGroup": this.buildGrupoAtivo,
            "brokenSLA": this.buildGrupoSLAEstourado,
            "waitingCustomer": this.buildGrupoAguardandoCliente,
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: [...fieldsCase] }) wiredCase({ error, data }) {
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
            this.historicoGruposSolucionadores = JSON.parse(getFieldValue(data, 'Case.HistoricoGruposSolucionadores__c')) || []

            if (this.historicoGruposSolucionadores.length == 0)
                this.historicoGruposSolucionadores.push({ index: 1, nome: getFieldValue(data, 'Case.GrupoSolucionador__c') })

            if (!getFieldValue(data, 'Case.ParametrizacaoCasos__c')) {
                this.erroInit = true
                this.msgErroInit = 'Parametrização não encontrada, por favor, edite a árvore do assunto.'

                return
            }

            isUserOnQueueMethod({queueId: getFieldValue(data, 'Case.OwnerId')})
                .then(result => {
                    this.isUserOnQueue = result
                })
                .catch(error => {
                    let message = 'Erro desconhecido'
                    if (Array.isArray(error.body)) {
                        message = error.body.map(e => e.message).join(', ')
                    } else if (typeof error.body.message === 'string') {
                        message = error.body.message
                    }
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erro ao buscar fila do caso',
                            message,
                            variant: 'error',
                        }),
                    )
                })

            this.gruposSolucionadores
        }
    }

    get gruposSolucionadores() {
        const order = ['checked', 'current', 'unchecked']

        let grupos = []

        fieldsParam.forEach((field, index) => {
            let nomeGrupoParam = getFieldValue(this.case, field)

            if (!nomeGrupoParam)
                return

            index++
            let nomeGrupoCaso = getFieldValue(this.case, 'Case.GrupoSolucionador__c')
            let ordemGrupoCaso = getFieldValue(this.case, 'Case.OrdemGrupoSolucionador__c')
            let milestoneStatusCaso = getFieldValue(this.case, 'Case.MilestoneStatus')
            let statusCaso = getFieldValue(this.case, 'Case.Status')

            const group = buildGroups({
                "currentItemGroup": nomeGrupoParam,
                "currentItemIndex": index,
                "caseGroup": nomeGrupoCaso,
                "caseGroupIndex": ordemGrupoCaso,
                "caseStatus": statusCaso,
                "caseMilestoneStatus": milestoneStatusCaso,
                "groupsHistory": this.historicoGruposSolucionadores
            })

            const buildedGroup = this.conditions[group](nomeGrupoParam, index)

            buildedGroup && grupos.push(buildedGroup)
        })

        grupos.sort(function (a, b) {
            const aOrder = order.indexOf(a.status)
            const bOrder = order.indexOf(b.status)

            if (aOrder > bOrder) {
                return 1
            } if (aOrder < bOrder) {
                return -1
            }

            return 0
        })

        if ((grupos.length > 3 && this.isNumberBetween(screen.width, 0, 600)) ||
            (grupos.length > 4 && this.isNumberBetween(screen.width, 600, 768)) ||
            (grupos.length > 5 && this.isNumberBetween(screen.width, 768, 992)) ||
            (grupos.length > 6 && this.isNumberBetween(screen.width, 992, 5000))) {
            this.divGradientClass = ''
            this.divScrollableClass = 'innerDivScrollable'
            this.divColScrollableClass = 'slds-col slds-size_11-of-12'
            this.isDivScrollable = true
        }
        else {
            this.divScrollableClass = 'innerDivNotScrollable'
            this.divColScrollableClass = 'slds-col slds-size_1-of-1'
            this.isDivScrollable = false
        }

        this.loading = false

        return grupos ? grupos : [{ index: 0, name: "", status: "", icon: { enabled: false }, classes: { div: "", button: "", textButton: "" } }]
    }

    handleCloseClickConfirmationModal() {
        this.displayModal = false
        this.grupoSolucionadorSelecionado = {}
    }

    handleOkClickConfirmationModal() {
        this.loading = true
        this.displayModal = false

        this.historicoGruposSolucionadores.push({ index: this.grupoSolucionadorSelecionado.index, nome: this.grupoSolucionadorSelecionado.name })

        const fields = {}
        fields['Id'] = this.recordId
        fields['GrupoSolucionador__c'] = this.grupoSolucionadorSelecionado.name
        fields['OrdemGrupoSolucionador__c'] = this.grupoSolucionadorSelecionado.index
        fields['Status'] = 'Novo'
        fields['AceitoPor__c'] = ''
        fields['HistoricoGruposSolucionadores__c'] = JSON.stringify(this.historicoGruposSolucionadores)

        const recordInput = { fields }

        updateRecord(recordInput).then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Successo',
                    message: 'Caso atualizado',
                    variant: 'success'
                })
            )
            this.loading = false

            return refreshApex(this.wiredCase)
        }).catch(error => {
            this.loading = false
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erro',
                    message: error.body.message,
                    variant: 'error'
                })
            )
        })
    }

    openModalConfirm(event) {
        if(!this.isUserOnQueue) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Erro',
                    message: 'Você não tem permissão para enviar este caso ao próximo grupo solucionador.',
                    variant: 'error',
                }),
            )
            this.displayModal = false
            return
        }
        
        this.grupoSolucionadorSelecionado = this.gruposSolucionadores[event.currentTarget.dataset.id]
        this.textModal = 'Deseja enviar o caso para o grupo solucionador ' + this.grupoSolucionadorSelecionado.name + '?'
        this.displayModal = true
    }

    buildGrupoAtivo(nomeGrupoParam, i) {
        return { index: i, name: nomeGrupoParam, status: "current", icon: { enabled: false }, classes: { div: "slds-progress__item slds-is-active", button: "slds-button slds-progress__marker btnGroupNoneOutline", textButton: "noselect buttonTextActive" } }
    }

    buildGrupoAguardandoCliente(nomeGrupoParam, i) {
        return { index: i, name: nomeGrupoParam, status: "current", icon: { enabled: false }, classes: { div: "slds-progress__item", button: "slds-button slds-progress__marker btnWarning btnGroupIconWhiteBG", textButton: "noselect buttonTextActiveWaiting" } }
    }

    buildGrupoSLAEstourado(nomeGrupoParam, i) {
        return { index: i, name: nomeGrupoParam, status: "current", icon: { enabled: false }, classes: { div: "slds-progress__item", button: "slds-button slds-progress__marker btnBrokenSla btnGroupIconWhiteBG", textButton: "noselect buttonTextActiveBrokenSla" } }
    }

    buildGrupoDesativado(nomeGrupoParam, i) {
        return { index: i, name: nomeGrupoParam, status: "unchecked", icon: { enabled: false }, classes: { div: "slds-progress__item", button: "slds-button slds-progress__marker btnGroupNoneOutline", textButton: "noselect buttonTextUnchecked" } }
    }

    buildGrupoCheckado(nomeGrupoParam, i) {
        return { index: i, name: nomeGrupoParam, status: "checked", icon: { enabled: true, name: "utility:success", variant: "success" }, classes: { div: "slds-progress__item", button: "slds-button slds-progress__marker slds-progress__marker_icon btnGroupIconWhiteBG", textButton: "noselect buttonTextChecked" } }
    }

    scrollLeft() {
        this.template.querySelector('[data-id="scrollDiv"]').scrollLeft -= 200
    }

    scrollRight() {
        this.template.querySelector('[data-id="scrollDiv"]').scrollLeft += 200
    }

    isNumberBetween(number, a, b) {
        return number > a && number < b
    }
}