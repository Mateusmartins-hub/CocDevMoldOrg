import { LightningElement, api, wire, track } from "lwc";
import { getRecord, createRecord, updateRecord } from "lightning/uiRecordApi";
import USER_ID from '@salesforce/user/Id';
import findCPFRecords from '@salesforce/apex/LGPD_AnonimizacaoController.findCPFRecords';
import findCPFEmailRecords from '@salesforce/apex/LGPD_AnonimizacaoController.findCPFEmailRecords';
import executeBatchJob from '@salesforce/apex/LGPD_AnonimizacaoController.executeBatchJob';
import getBatchJobStatus from '@salesforce/apex/LGPD_AnonimizacaoController.getBatchJobStatus';
export default class LgpdAnonimizacao extends LightningElement {
    @api recordId;
    showModal = false;
    selectedEmails = [];
    @track emailsToSelect = [];
    isLoading = false;
    isExecuting = false;
    nomeCompleto;
    cpf;
    email;
    jobId;
    jobItemsProcessed = 0;
    hasJobItemsProcessed = false;
    totalJobItems = 1;
    hasErrors;
    numberOfErrors = 0;
    jobProgress = 'Holding';
    @track jobStatus = 0;
    @track recordsFound = [];
    listId = [];

    @wire(getRecord, {
        recordId: "$recordId",
        fields: ["Case.BR_NomeCompleto__c", "Case.BR_CPF__c", "Case.SuppliedEmail", "Case.LGPD_JobId__c"]
    })
    caso({ data }) {
        if (data) {
            this.nomeCompleto = data.fields.BR_NomeCompleto__c.value;
            this.cpf = data.fields.BR_CPF__c.value;
            this.email = data.fields.SuppliedEmail.value;
            this.jobId = data.fields.LGPD_JobId__c.value;
            if (this.jobId) {
                this.isExecuting = true;
                this.jobStatus = 100;
                this.jobProgress = 'Completed';
            } else {
                findCPFRecords({ cpf: this.cpf }).then(data => {
                    if (data) {
                        for (var d = 0; d < data.length; d++) {
                            this.emailsToSelect.push({ label: data[d], value: data[d] });
                        }
                    }
                });
            }
        }
    }

    get emailsToSelect() {
        return this.emailsToSelect;
    }

    handleSelectEmail(e) {
        this.selectedEmails = e.detail.value;
    }

    handleClick() {
        this.recordsFound = [];
        findCPFEmailRecords({ cpf: this.cpf, emailSet: this.selectedEmails }).then(data => {
            if (data) {
                for (var d = 0; d < data.length; d++) {
                    var sobject = data[d].recordName;
                    var childs = [];
                    for (var e = 0; e < data[d].records.length; e++) {
                        childs.push({
                            id: data[d].records[e].id,
                            name: data[d].records[e].name,
                            date: data[d].records[e].createdDate
                        });
                        this.listId.push(data[d].records[e].id);
                    }
                    this.recordsFound.push({ sobject, childs });
                }
            }
        });
        this.showModal = true;
    }

    closeModal() {
        this.showModal = false;
    }

    confirmModal() {
        this.showModal = false;
        this.isExecuting = true;
        executeBatchJob({ ids: this.listId }).then(data => {
            console.log(this.listId);
            console.log(data);
            if (data) {
                this.jobId = data;
            }
        });
        try {
            var chaves = this.cpf + ', ';
            for (var f = 0; f < this.selectedEmails.length; f++) {
                chaves += this.selectedEmails[f] + ', ';
            }
            chaves = chaves.substring(0, chaves.lastIndexOf(','));
            this.selectedEmails.push(this.cpf);
            let fields = { 'Caso__c': this.recordId, 'Chaves_Utilizadas__c': chaves, 'Usuario__c': USER_ID };
            let objRecordInput = { 'apiName': 'Anonimizacao_de_Dados__c', fields };
            createRecord(objRecordInput);
        } catch (error) {
            console.log(error);
        }
        this._interval = setInterval(() => {
            if ('Aborted' != this.jobProgress && 'Completed' != this.jobProgress && 'Failed' != this.jobProgress) {
                getBatchJobStatus({ jobID: this.jobId }).then(data => {
                    console.log(data);
                    if (data) {
                        if (data.JobItemsProcessed && data.JobItemsProcessed > 0) {
                            this.jobItemsProcessed = data.JobItemsProcessed;
                            this.hasJobItemsProcessed = true;
                        }
                        if (data.TotalJobItems && data.TotalJobItems > 0) {
                            this.totalJobItems = data.TotalJobItems;
                        }
                        if (data.Status) {
                            this.jobProgress = data.Status;
                        }
                        if (data.NumberOfErrors && data.NumberOfErrors > 0) {
                            this.hasErrors = true;
                            this.numberOfErrors = data.NumberOfErrors;
                        }
                        this.jobStatus = Math.round((this.jobItemsProcessed / this.totalJobItems) * 100);
                    }
                });
            } else {
                if ('Completed' == this.jobProgress && this.numberOfErrors == 0) {
                    let record = {
                        fields: {
                            Id: this.recordId,
                            LGPD_JobId__c: this.jobId,
                        },
                    };
                    try {
                        updateRecord(record);
                    } catch (error) {
                        console.log(error);
                    }
                    updateRecord(record);
                }
                clearInterval(this._interval);
            }
        }, 3000);
    }

    disconnectedCallback() {
        clearInterval(this._interval);
    }
}