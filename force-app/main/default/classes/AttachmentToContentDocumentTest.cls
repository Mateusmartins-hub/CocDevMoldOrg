@IsTest
private class AttachmentToContentDocumentTest {
     static testmethod void test() {

        User userToRun = [
            SELECT Id FROM User 
            WHERE Profile.Name LIKE '%admin%' 
            AND isActive = true 
            AND ManagerId != null 
            AND UserPermissionsKnowledgeUser  = true 
            AND Profile.PermissionsManageKnowledge = true
            //AND Profile.PermissionsViewDraftArticles = true
            LIMIT 1
        ];

        System.runAs(userToRun){

            List<Solution> solutions = new List<Solution>();

            for (Integer i = 0; i < 100; i++){
                Solution aSolution = new Solution();
                aSolution.SolutionName = 'Test ' + i;
                aSolution.BR_Grupo_Solucionador__c = 'Arquitetura';
                aSolution.BR_Nivel_de_Acesso__c = 'Externo (Cliente)';
                aSolution.BR_Passo_a_Passo__c = 'Just a text ' + i;
                aSolution.Marca_Produto__c = 'Yazigi';
                aSolution.Status = 'Draft';
                aSolution.SolutionNote = 'Test not number ' + i;
                solutions.Add(aSolution);
            }
            
            insert solutions;

            List<Attachment> atts = new List<Attachment>();
            for (solution sol : solutions){
                Attachment att = new Attachment();
                att.ParentId = sol.Id;
                att.Name = sol.SolutionName;
                att.Body = Blob.valueOf('Body test');
                att.Description = sol.SolutionNote;            
                atts.add(att);
            }
            insert atts;

            List<Solucoes__kav> solsKav = new List<Solucoes__kav>();
            Integer aNumber = 1000;
            for (solution sol : solutions){
                Solucoes__kav solKav = new Solucoes__kav();
                solKav.SolutionRef__c = sol.Id;
                solKav.Title = 'Test';
                solKav.UrlName =  aNumber + '';
                solsKav.add(solKav);         
                aNumber++;
            }
            insert solsKav;     
            
            Test.startTest();
            AttachmentToContentDocument attachmentToContent = new AttachmentToContentDocument();
            Database.executeBatch(attachmentToContent);
            Test.stopTest();                
        }
     }
 
}