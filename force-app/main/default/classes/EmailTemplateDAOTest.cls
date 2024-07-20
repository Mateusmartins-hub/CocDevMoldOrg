@IsTest
public class EmailTemplateDAOTest {
    @TestSetup
    static void makeData(){
        Folder fd = [SELECT Id FROM Folder WHERE DeveloperName = 'Todos'];        

        EmailTemplate et = new EmailTemplate();
        et.DeveloperName = 'TestTemplate';
        et.Name = 'Test';
        et.TemplateType = 'text';
        et.FolderID = fd.id;
        insert et;        
    }

    @IsTest
    static void getEmailTemplateByDeveloperNameTest() {
        EmailTemplate et = [SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE DeveloperName = 'TestTemplate'];
        EmailTemplate etResult = EmailTemplateDAO.getEmailTemplateByDeveloperName('TestTemplate');
        EmailTemplate etResult2 = EmailTemplateDAO.getInstance().getEmailTemplateByName(et.Name);


        System.AssertEquals(et.Id, etResult.Id);
    }
}