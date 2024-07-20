@RestResource(urlMapping='/ProcessoHybrisAttachment/*')
global without sharing class RestHybrisAttachment {
    @HttpPost
    global static retornoAttachmentCaso insertAttachment(List<ParamAttachment> attachments) {
        try {
            retornoAttachmentCaso t = new retornoAttachmentCaso();
            
            String caseNumber = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/')+1);
            
            List<Case> casos = [SELECT Id, CaseNumber FROM Case WHERE CaseNumber =: caseNumber];
            Case caso;
            
            if(casos.isEmpty())
                throw new CustomException('Caso não encontrado');
            else
                caso = casos[0];
            
            List<Attachment> anexos = buildAttachments(attachments, caso.Id);
            insert anexos;
            
            t.status = true;
            t.message = 'Arquivo(s) anexado(s) com sucesso!';
            t.numCaso = caso.CaseNumber;
            return t;
        } catch(Exception e) {
            retornoAttachmentCaso t = new retornoAttachmentCaso();
            t.status = false;
            t.message = e.getMessage();
            
            return t;
        }
    }
    
    private static List<Attachment> buildAttachments(List<ParamAttachment> paramAttachments, Id parentId) {
        List<Attachment> anexos = new List<Attachment>();

        for(ParamAttachment p : paramAttachments) {
            Attachment att = new Attachment();
            att.Name = p.name;
            att.Body = EncodingUtil.base64Decode(p.b64);
            att.ParentId = parentId;
            
            anexos.add(att);
        }

        return anexos;
    }
    
    global class retornoAttachmentCaso {
        public Boolean status;
        public String numCaso;
        public String message;
    }
    
    global class ParamAttachment {
        public String name;
        public String b64;
    }
    
    public class CustomException extends Exception {}
}