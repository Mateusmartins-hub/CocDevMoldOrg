public class EnvioAmostraDigitalController {
    
    public class AmostraLink
    {
        @AuraEnabled
        public Id IdObjeto { get; set; }
        
        @AuraEnabled
        public string Prefixo { get; set; }
        
        @AuraEnabled
        public string Email { get; set; }
        
        @AuraEnabled
        public string SistemaEnsino { get; set; }
        
        @AuraEnabled
        public string Erro { get; set; }

        @AuraEnabled
        public string Nome { get; set; }

        @AuraEnabled
        public string OwnerName { get; set; }

        @AuraEnabled
        public string OwnerEmail{ get; set; }
    }
    
    public class Formulario
    {
        @AuraEnabled
        public Id IdFormulario { get; set; }
        
        @AuraEnabled
        public List<Product2> Amostras { get; set; }
    }
    
    @AuraEnabled
    public static AmostraLink GetObject(string id) 
    {
        AmostraLink al = new AmostraLink();
        try {
            Account ac = AccountDAO.buscaConta(id);
            al.IdObjeto = ac.Id;
            al.Prefixo = 'ac';
            al.Email = ac.BR_Account_email__c;
            al.SistemaEnsino = ac.SistemaEnsino__c;
            al.OwnerEmail = ac.Owner.Email;
            al.OwnerName = ac.Owner.Name;
            
        } catch (Exception e) { }
        
        try {
            Lead ld = LeadDAO.BuscaLead(id);
            al.IdObjeto = ld.Id;
            al.Prefixo = 'ld';
            al.Email = ld.Email; 
            al.Nome = ld.Name;
            al.SistemaEnsino = ld.SistemaEnsino__c;
            al.OwnerEmail = ld.Owner.Email;
            al.OwnerName = ld.Owner.Name;
        } catch (Exception e) { }
        
        try {            
            
            Opportunity op = OpportunityDAO.buscaOportunidade(id);
            al.IdObjeto = op.Id;
            al.Prefixo = 'op';
            al.OwnerEmail = op.Owner.Email;
            al.OwnerName = op.Owner.Name;

            Contact aContact = ContactDAO.getContactFromAccountId(op.AccountId);
            
            if(aContact == null || aContact.Email == null)
                al.Email = op.Account.BR_Account_email__c;
            else 
                al.Email = aContact.Email;
            
            al.SistemaEnsino = op.Account.SistemaEnsino__c;
            al.Nome = aContact.Name;
            
            if (op.Probability < 10)
                al.Erro = 'A oportunidade deve estar na fase "Visita inicial" para poder enviar amostra';
            
        } catch (Exception e) { }
        
        if (string.isBlank(al.Email))
            al.Erro = 'Preencha o e-mail para enviar a amosta';
        else if (string.isBlank(al.SistemaEnsino))
            al.Erro = 'Preencha o sistema de ensino para enviar a amosta';
        
        return al;
    }
    
    @AuraEnabled
    public static Formulario GetFormulario(string metodoEnsino) 
    {
        List<Product2> amostras = [SELECT Id, Name, LinkAmostra__c 
                                   FROM Product2 
                                   WHERE IsActive = true 
                                   AND LinkAmostra__c != null 
                                   AND RecordType.DeveloperName =: 'AmostraVirtual'];
        
        List<Formulario__c> form =  [SELECT Id
                                     FROM Formulario__c 
                                     WHERE SistemaEnsino__c =: metodoEnsino 
                                     AND Tipo__c = 'Amostra virtual'
                                     LIMIT 1];
        
        Formulario me = null;
        if (!form.isEmpty())
        {
            me = new Formulario();
            me.IdFormulario = form[0].Id;
            me.Amostras = amostras;
        }
        
        return me;
    }
    
    @AuraEnabled
    public static Boolean ValidaEnvioPosterior(string idObjeto, string idProduto, string metodoEnsino) 
    {
        List<Formulario__c> amostras = [SELECT Id
                                        FROM Formulario__c
                                        WHERE Produto__c =: idProduto
                                        AND SistemaEnsino__c =: metodoEnsino
                                        AND (Conta__c =: idObjeto
                                             OR Lead__c =: idObjeto
                                             OR Oportunidade__c =: idObjeto)]; 
        
        return !amostras.isEmpty();
    }
    
    @AuraEnabled
    public static Boolean SendEmail(AmostraLink objeto, string idFormulario, string amostra) 
    {
        Map<string, string> mapUrlParams = new Map<string, string>();
        mapUrlParams.put('id', idFormulario);
        mapUrlParams.put(objeto.Prefixo, objeto.IdObjeto);
        mapUrlParams.put('av', amostra);

        Formulario_FormularioDigital.EnviarFormulario(objeto.Email, 'AmostraVirtualEmail', mapUrlParams, null, objeto.OwnerEmail, objeto.OwnerName);
        
        return true;
    }
}