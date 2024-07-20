@isTest
public class OpportunityLineItemBOTest {
    
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
    public static void testOne() {
        
        User u = [select id, email from User where UserName = 'standarduser2@pearson.br' limit 1];
        System.runAs(u){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockCapturaSAP());
            
            OpportunityLineItem opL = TestHelper.CreateOpportunityLineItem();
            insert opL;
            
            Opportunity op = [SELECT Id, AccountId FROM Opportunity WHERE Id =: opL.OpportunityId];
            
            String idRecTypeAseg = RecordTypeMemory.getRecType( 'Account_Segmentation__c', 'School_Segmentation');
            Account_Segmentation__c aseg = new Account_Segmentation__c();
        	aseg.Account__c = op.AccountId;
        	aseg.RecordTypeId = idRecTypeAseg;
            aseg.Current_year__c = String.valueOf(System.today().year());
            insert aseg;
            
            Opportunity op2 = TestHelper.createOpportunity();
            op2.AccountId = op.AccountId;
            op2.BR_Account_Segmentation__c = aseg.Id;
            op2.BR_Desconto_1_ano__c = 10;
            insert op2;
            
            Product2 prd = new Product2();
            prd.Name = 'Test';
            prd.CurrencyIsoCode = 'BRL';
            insert prd;
            
            PricebookEntry ent = new PricebookEntry();
            ent.Pricebook2Id = Test.getStandardPricebookId();
            ent.Product2Id = prd.Id;
            ent.UnitPrice = 10;
            ent.IsActive = true;
            insert ent;
            
            OpportunityLineItem opL2 = new OpportunityLineItem();
            opL2.PricebookEntryId = ent.Id;
            opL2.OpportunityId = op2.Id;
            opL2.Quantity = 10;
            opL2.TotalPrice = 100;
            insert opL2;
            
            OpportunityLineItemBO.getInstance().updateDiscountItem(op2.Id, op2.RecordTypeId, op2.BR_Desconto_1_ano__c);
            
            List<OpportunityLineItem> lstOppLI = new List<OpportunityLineItem>();
            lstOppLI.add(opL2);
            OpportunityLineItemBO.updateStock(lstOppLI);
            Test.stopTest();
        }
        
    }
    
}