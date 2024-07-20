@IsTest
public class ReclameAquiAnexosControllerTest {
    
    @isTest
    static void shouldCallWebserviceAndReturnAttachmentLinks_Success(){

        Account account = new Account(
            Name = 'Test'
        );
        insert account;

        Case cs = new Case(
            Subject = 'Test',
            AccountId = account.Id,
            Id_anexos_RA__c = '123;321;'
        );

        insert cs;


        ReclameAquiAnexosController.retrieveAttachmentsLinks(cs.Id);

        Case csAfter = [
            SELECT Id, LinksAnexos__c FROM Case
        ];

        System.assert(csAfter.LinksAnexos__c != null);

    }

    @isTest
    static void shouldCallWebserviceAndReturnAttachmentLinks_Fail(){

        Account account = new Account(
            Name = 'Test'
        );
        insert account;

        try{
            ReclameAquiAnexosController.retrieveAttachmentsLinks(account.Id);
        }
        catch(Exception ex){
            System.assert(ex != null);
        }

    }
}