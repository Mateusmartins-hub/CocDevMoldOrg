import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveTask from '@salesforce/apex/CreateTaskFinancialAnalysis.createTask';

export default class createTaskLWC extends LightningElement {
    
    @api recordId;    

    createTask(){
        
        console.log('recordId: ' + this.recordId);
        saveTask({IdOpp: this.recordId})
            .then(task => {
                this.taskId = task.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Sucesso',
                        message: 'Tarefa criada com sucesso.',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erro ao criar a tarefa.',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
}