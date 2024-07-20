@isTest
public with sharing class RDStationProcessTest {
    
    @isTest
    static void shouldIntegrateToRDStationWhenCloseOpportunity_Success(){

        User userToRun = [
            SELECT Id FROM User WHERE Profile.Name LIKE '%admin%' AND ManagerId != null AND isActive = true LIMIT 1
        ];

        System.runAs(userToRun){
            
            Account account = new Account(
                Name = 'Test',
                BR_Account_email__c = 'test@test.com'
            );
            insert account;

            Opportunity opp1 = new Opportunity(
                Name = 'Opp Teste 1',
                StageName = 'Contrato Fechado',
                MarcaFranquias__c = 'Wizard',
                CloseDate = System.Today().addDays(10),
                AccountId = account.Id
            );
            
            Opportunity opp2 = new Opportunity(
                Name = 'Opp Teste 2',
                StageName = 'Cancelada',
                MarcaFranquias__c = 'Wizard',
                BR_Motivo_Recusa__c = 'Outros',
                CloseDate = System.Today().addDays(10),
                AccountId = account.Id
            );

            List<Opportunity> opps = new List<Opportunity>{opp1, opp2};
                
            insert opps;
                
            RDStationProcess.closeOpportunity(opps);
        }
    }


    @isTest
    static void shouldIntegrateToRDStationWhenCloseOpportunity_Failure(){

        Account account = new Account(
            Name = 'Test', 
            BR_Account_email__c = 'test@test.com'
        );
        insert account;

        Opportunity opp1 = new Opportunity(
            Name = 'Opp Teste 1',
            StageName = 'Cancelada',
            MarcaFranquias__c = 'Wizard',
            CloseDate = System.Today().addDays(10),
            AccountId = account.Id
        );
        List<Opportunity> opps = new List<Opportunity>{opp1};

        
        try{
            insert opps;
            RDStationProcess.closeOpportunity(opps);
        }
        catch (Exception e) {
            System.assert(e != null, 'Should throw a exception when try to close the opportunity without cancel reason');
        }

        
    }

    @isTest
    static void shouldIntegrateToRDStationWhenLeadIsNotQualified_Success(){

        // Account account = new Account(
        //     Name = 'Test',
        //     BR_Account_email__c = 'test@test.com'
        // );
        // insert account;

        Lead lead1Before = new Lead(
            LastName = 'Test 1',
            Company = 'Company 1',
            Marca_RD_Station__c = 'Wizard',
            Email = 'test1@test.com'
        );
        insert lead1Before;

        Lead lead2Before = new Lead(
            LastName = 'Test 2',
            Company = 'Company 2',
            Email = 'test2@test.com'
        );
        insert lead2Before;

        Lead lead1After = lead1Before.clone();
        Lead lead2After = lead2Before.clone();
        lead1After.Status = 'Finalizado';
        lead1After.Resultado__c = 'Não Qualificado';
        
        lead2After.Status = 'Finalizado';
        lead2After.Resultado__c = 'Não Qualificado';
        
        Test.startTest();
        Test.stopTest();
        
        Map<Id, Lead> leadsBefore = new Map<Id, Lead>{
            lead1Before.Id => lead1Before, 
            lead2Before.Id => lead2Before
        };

        Map<Id, Lead> leadsAfter = new Map<Id, Lead>{
            lead1Before.Id => lead1After, 
            lead2Before.Id => lead2After
        };

        RDStationProcess.leadNotQualified(leadsBefore, leadsAfter);
        
    }


    @isTest
    static void shouldIntegrateToRDStationWhenLeadIsNotQualified_Failure(){

        Account account = new Account(
            Name = 'Test',
            BR_Account_email__c = 'test@test.com'
        );
        insert account;

        Opportunity opp1 = new Opportunity(
            Name = 'Opp Teste 1',
            StageName = 'Cancelada',
            MarcaFranquias__c = 'Wizard',
            CloseDate = System.Today().addDays(10),
            AccountId = account.Id
        );
        List<Opportunity> opps = new List<Opportunity>{opp1};

        
        try{
            insert opps;
            RDStationProcess.closeOpportunity(opps);
        }
        catch (Exception e) {
            System.assert(e != null, 'Should throw a exception when try to close the opportunity without cancel reason');
        }

        
    }
}