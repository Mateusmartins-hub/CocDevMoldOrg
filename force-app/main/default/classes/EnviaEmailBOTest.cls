@IsTest
public class EnviaEmailBOTest {
    @TestSetup
    static void setup(){
        
        Profile p = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') or  (Name = 'Administrador do Sistema' ) limit 1];
        
        // Aprovador 
        User u1 = new User(
            Alias = 'standt1', 
            Email='standarduser1@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser1@pearson.br'
            
        );
        insert u1;  
        
        // Solicitante
        User u2 = new User(
            Alias = 'standt2', 
            Email='standarduser2@pearson.br', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='pt_BR', 
            LocaleSidKey='pt_BR', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Sao_Paulo', 
            UserName='standarduser2@pearson.br',
            ManagerId = u1.id 
        );
        insert u2;
        
    }
    
    @isTest
    public static void TestOne(){
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            Test.startTest(); 
            //
            //  IBGE  
            //
            IBGE_Code__c IBGE = new IBGE_Code__c (
                City_name__c = 'São Paulo',
                City_code__c = '50308',
                UF_name__c ='São Paulo',
                UF_acronym__c = 'SP',
                Name = '3550308'
            );
            insert IBGE;
            
            //
            // PF        
            //
            Account A = new Account(
                BR_Account_Id_SSA__c = 'P6666',
                BR_Birthdate__c = '18/08/1990',
                BR_CPF__c = '178.170.628-03',
                BR_Integrate_to_SAP__c = false,
                BR_Integrate_to_SSA__c = true,
                BR_Integration_Status_SSA__c = 'Integrado ERP',
                BR_Main_Address__c = 'Rua Nelson Francisco  ',
                BR_Main_City__c = 'São Paulo',
                BR_Main_Complement__c = 'ap23',
                BR_Main_Country__c = 'BR',
                BR_Main_District__c = 'Limão',
                BR_Main_Nbr__c = '666',
                BR_Main_State__c = 'SP',
                BR_Main_Zip_code__c = '05790-140',
                Name = 'Roberto Carlos',
                IBGE_Code__c = IBGE.ID
                //RecordTypeID = '012d0000000gQD8'
            );
            insert A;
            // 
            //  Contato da conta 
            //
            /*
            Contact Contac = [SELECT ID, AccountId from  Contact where AccountId =: A.ID ];
            Contac.Email = 'teste1@teste.com.br';
            update Contac;
            System.Debug('Contact.ID = ' + Contac.ID);
            */
            
            Contact Contac = New Contact();
            Contac.LastName = A.Name;
            Contac.Email = 'teste1@teste.com.br';
            Contac.AccountId = A.id;
            insert Contac;
            System.Debug('Contact.ID = ' + Contac.ID);
            
            //
            // Conta e Contato relação (PJ com PF)
            // 
            
            Account_Contact__c Account_Contact = new Account_Contact__c(
                Account__c = A.ID,
                Contact__c = Contac.ID
            );
            Account_Contact.Email__c = 'teste1@teste.com';
           	Account_Contact.CPF__c = '50373666403';
             insert Account_Contact;
            
            Opportunity op1 = TestHelper.createOpportunityEnglishEdu();
            op1.AccountId = a.id;
            op1.BR_Account_Contact__c = Account_Contact.Id;
            insert op1;
            
            PricebookEntry ent = TestHelper.createPricebookEntry();
            insert ent;
            
            OpportunityLineItem opL = new OpportunityLineItem();
            opL.PricebookEntryId = ent.Id;
            opL.OpportunityId = op1.Id;
            opL.Quantity = 10;
            opL.TotalPrice = 100;
            opL.BR_StatusProduto__c = true; 
            insert opL;
            
            OpportunityLineItem oplineItem = TestHelper.createOpportunityLineItem();
            insert oplineItem;
            
            /*
            List<OpportunityLineItem> prodOppLst = [SELECT Id, BR_StatusProduto__c  FROM OpportunityLineItem where opportunityid =: op1.Id ];
            
            for (OpportunityLineItem item : prodOppLst){
              item.BR_StatusProduto__c = true;                
            }
            update prodOppLst;
            */
            List<Opportunity> ltOpp = [SELECT id, Opportunity.Account.Name,BR_Account_Contact__r.Name,BR_Account_Contact__c, BR_URL__c from opportunity where id =: op1.id];
                        
            //List<Opportunity> ltOpp = new List<Opportunity>();
            //ltOpp.add(op1);
            
            /*
            Account_Contact__c contaContato = AccountContactDAO.getInstance().buscaContatos(ltOpp[0].BR_Account_Contact__c);
            system.debug('contaContato : ' + contaContato);
            
            //Contact contato = contatoDAO.buscaEmail(contaContato.Contact__c);
            Contact contato = [Select Name, Email From Contact Where Id =: contaContato.Contact__c];
            system.debug('que código porco : ' + contato.Email);
            */
                        
            EnviaEmailBO.getInstance().enviaEmail(ltOpp);
            Test.stopTest();            
      }
    }
}