trigger AccountDetectDuplicate on Account (before insert) {
/******************************************************
Marcos Aurélio - 24/03/2014
ServiceNOW: INC0809004

Trigger desenvolvida para evitar cadastros duplicados
com base em critérios.

Tipos de Registros Mapeados:    Contato - não é obrigatório cadastrarem o CPF, 
                                          porém essa é a chave caso informado.
                                Distribuidor - CNPJ 
                                Empresas - CNPJ
                                Instituto de Idiomas - CNPJ
                                Livraria - CNPJ 
                                Mantenedoras - CNPJ 
                                Prefeituras - CNPJ 
                                Representantes de vendas - CPF
                                Pessoa Física - CPF
*******************************************************/
    for(Account a:Trigger.new)
    {
        //***Implementação de Regras para Contas do tipo Contato, Representante de Vendas - INICIO***
        Id idRecTypeContato = RecordTypeMemory.getRecType( 'Account', 'Academic_Account' );   
        Id idRecTypeRepSales = RecordTypeMemory.getRecType( 'Account', 'Sales_Representative' );
        Id idRecTypePF = RecordTypeMemory.getRecType( 'Account', 'Pessoa_F_sica' );

        if((a.RecordTypeId==idRecTypeContato) || (a.RecordTypeId==idRecTypeRepSales) || (a.RecordTypeId==idRecTypePF))
        {
            if (a.BR_CPF__c!=null)
            {
                List<Account> acc=[select ID from Account Where BR_CPF__c=:a.BR_CPF__c];

                if(acc.size()>0)
                {
                    a.adderror('Já existe um registro com este CPF!');
                }
            }
        }
        //***Implementação de Regras para Contas do tipo Contato - FIM***
        
        /***Implementação de Regras para Contas do tipo Distribuidor, Empresas, Instituto de Idiomas,
            Livraria,Mantenedoras,Prefeituras   - INICIO***/
        Id idRecTypeDistribuidor     = RecordTypeMemory.getRecType( 'Account', 'Dearler' );
        Id idRecTypeEmpresa          = RecordTypeMemory.getRecType( 'Account', 'Non_Educat_Institution' );
        Id idRecTypeInstitutoIdiomas = RecordTypeMemory.getRecType( 'Account', 'Languages' );
        Id idRecTypeLivraria         = RecordTypeMemory.getRecType( 'Account', 'Bookshop' );
        Id idRecTypeMantenedora      = RecordTypeMemory.getRecType( 'Account', 'Maintainer' );
        Id idRecTypePrefeitura       = RecordTypeMemory.getRecType( 'Account', 'City_Hall' );
        //System.debug('DI' + idRecTypeDistribuidor);
        //System.debug('EM' + idRecTypeEmpresa);
        //System.debug('ID' + idRecTypeInstitutoIdiomas);
        //System.debug('LI' + idRecTypeLivraria);
        //System.debug('MA' + idRecTypeMantenedora);
        //System.debug('PR' + idRecTypePrefeitura);
       
        
        if(a.RecordTypeId==idRecTypeDistribuidor || a.RecordTypeId==idRecTypeEmpresa || a.RecordTypeId==idRecTypeInstitutoIdiomas || 
          a.RecordTypeId==idRecTypeLivraria || a.RecordTypeId==idRecTypeMantenedora || a.RecordTypeId==idRecTypePrefeitura)
        {
            if (a.BR_cnpj__c!=null)
            {
                For (List<Account> acc : [select ID from Account Where BR_cnpj__c=:a.BR_cnpj__c and RecordTypeId =:a.RecordTypeId]){

                    //System.debug('TM ' +  acc.size());
                    if(acc.size()>0)
                    {
                        a.adderror('Já existe um registro com este CNPJ!');
                    }                    
                }
            }
        } 
        /***Implementação de Regras para Contas do tipo Distribuidor, Empresas, Instituto de Idiomas,
            Livraria,Mantenedoras,Prefeituras   - FIM***/
    }   
}