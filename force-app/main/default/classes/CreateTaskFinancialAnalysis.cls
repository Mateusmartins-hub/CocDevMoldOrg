public with sharing class CreateTaskFinancialAnalysis {

    
//@AuraEnabled(cacheable=true)
@AuraEnabled
public static Task createTask(Id IdOpp)
{
    System.debug('ENTROU NO METHOD COM O PARAM: '+ IdOpp);
    Group g = [Select Id from Group where Type = 'Queue' AND DeveloperName = 'Analise_Financeira' LIMIT 1];
    ID qID = g.ID;       
    
    System.debug('ENTROU NO METHOD COM O GROUP ID: '+ qID);
    Task tsk = new Task();
    tsk.Subject = 'Análise Financeira - Escolas';
    tsk.Status = 'Open';
    tsk.Description = 'Realizar a análise financeira da oportunidade relacionada a esta tarefa';
    tsk.Priority = 'Normal';
    tsk.WhatId = IdOpp;
    tsk.OwnerId = qID;
    
    insert tsk;
    return tsk;
}
}