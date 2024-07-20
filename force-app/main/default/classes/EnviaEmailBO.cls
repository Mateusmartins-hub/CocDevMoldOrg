public with sharing class EnviaEmailBO {

  public EnviaEmailBO() {}

  public static final EnviaEmailBO instance = new EnviaEmailBO();

  public static EnviaEmailBO getInstance()
  {
    return instance;
  }

  public void enviaEmail(List<Opportunity> lstOpp){

    list<String> lOppId = new list<String>();
    for(Opportunity opp : lstOpp){
      lOppId.add(opp.Id);
    }
    
    List< OpportunityLineItem > lProd = OpportunityLineItemDAO.getListOliByIdsOpp(lOppId);
      
    map<String,String> mProd = new map<String,String>();
    for(OpportunityLineItem prod : lProd){
       if( prod.BR_StatusProduto__c == true){
        String dadosTabela = mProd.get(prod.OpportunityId);
      if(dadosTabela == null){
         dadosTabela = '<table>';
         dadosTabela += '<tr>';
         dadosTabela += '<td><b>Produto ERP | </b></td>';
         dadosTabela += '<td><b>Livro | </b></td>';
         dadosTabela += '<td><b>Quantidade</b></td>';
         dadosTabela += '</tr>';
      }
            system.debug('JK PRODUTO ' + prod);
            dadosTabela += '<tr>';
            dadosTabela += '<td>' + prod.PricebookEntry.Product2.BR_ISBN__c + '| </td>';
            dadosTabela += '<td>' + prod.PricebookEntry.Product2.Name + '| </td>';
            dadosTabela += '<td>' + prod.Quantity + '</td>';
            dadosTabela += '</tr>';
            mProd.put(prod.OpportunityId, dadosTabela);
     }
      }
    system.debug('lProd ' + lProd);
    String emailTemplateName = 'AdocaoRecorrente';
    String htmlBody;
    String assunto;
    system.debug('Email ');    
    EmailTemplate emailTemplate = emailTemplateDAO.getInstance().getEmailTemplateByName(emailTemplateName);
    assunto = emailTemplate.Subject;
    
    list<Messaging.SingleEmailMessage> lEmail = new list<Messaging.SingleEmailMessage>();
    
    for(Opportunity opp : lstOpp){
      system.debug('aqui oportunidade ' + opp);
            String dadosTabela = (mProd.containsKey(opp.Id) ? mProd.get(opp.Id) + '</table>' : '');
            system.debug('dados tabela ' + dadosTabela);
          Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        htmlBody = emailTemplate.HtmlValue;  
      opp.BR_AdocaoRecorrenteEnviada__c = true;
      htmlBody = htmlBody.replace('{!Opportunity.Account}', opp.Account.Name);
      htmlBody = (opp.BR_Account_Contact__r.Name != null) ? (htmlBody.replace('{!Opportunity.BR_Account_Contact__c}', opp.BR_Account_Contact__r.Name)) : htmlBody;
      htmlBody = htmlBody.replace('{!Opportunity.BR_ProdutosEnvioEmail__c}', dadosTabela);
      htmlBody = (opp.BR_URL__c != null) ? (htmlBody.replace('{!Opportunity.BR_URL__c}', opp.BR_URL__c)) : htmlBody;
      Account_Contact__c contaContato = AccountContactDAO.getInstance().buscaContatos(opp.BR_Account_Contact__c);
      Contact contato = contatoDAO.buscaEmail(contaContato.Contact__c);
        email.setToAddresses(new List<String>{contato.Email});
            system.debug('email : ' + contato.Email);
        email.setSubject(assunto);
      email.setHtmlBody(htmlBody);
        lEmail.add(email);
    }
    system.debug('lEmail ' + lEmail);
    Messaging.sendEmail(lEmail);

    update lstOpp;
  }

    
}