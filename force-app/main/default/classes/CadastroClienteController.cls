public with sharing class CadastroClienteController {
    
    public CadastroClienteController(){
        
        cadCli = new SolicitacaoCadastroCliente__c();
        showpageBlockPF = false;
        CheckProfileApprovers();
        
        //ProfileApprovers();
        if (apexpages.currentpage().getparameters().get('id') == null){
            
            cadcli.BR_Status__c = 'Em Elaboração';
            
        } else {
            
            string Id = apexpages.currentpage().getparameters().get('id');
            
            List<SolicitacaoCadastroCliente__c> listaCadCli = [SELECT Id,
                                                               BR_Bairro__c,
                                                               BR_CNPJ__c,
                                                               BR_Conta__c,
                                                               BR_CPF__c,
                                                               BR_email__c,
                                                               BR_Main_Address__c,
                                                               BR_Main_City__c,
                                                               BR_Main_Complement__c,
                                                               BR_Main_Nbr__c,
                                                               BR_Main_State__c,
                                                               BR_Main_Zip_code__c,
                                                               BR_Name__c,
                                                               BR_Nascimento__c,
                                                               BR_Phone__c,
                                                               BR_RazaoSocial__c,
                                                               BR_Status__c,
                                                               CreatedDate,
                                                               InscricaoEstadual__c,
                                                               Name,
                                                               Pessoa_de_Contato__c,
                                                               Tipo_de_Pessoa__c,
                                                               Unidade__c,
                                                               BR_RegionalVendas__c,
                                                               BR_GrupoClassificaContrib__c,
                                                               BR_GrupoClientes__c,
                                                               BR_ClienteBloqueado__c,
                                                               BR_CRTN__c,
                                                               CreatedById,
                                                               CreatedBy.FirstName,
                                                               CreatedBy.LastName, 
                                                               BR_Observacoes__c,
                                                               TipoRegistroConta__c
                                                               FROM SolicitacaoCadastroCliente__c
                                                               where id =: Id limit 1];
            if (listaCadCli.size() > 0){
                CadCli = listaCadCli[0];
                
                System.debug(CadCli.Tipo_de_Pessoa__c);
                if (CadCli.Tipo_de_Pessoa__c == 'Pessoa Física'){
                    showBlockPF();
                }
                
                if (CadCli.TipoRegistroConta__c != null){
                    selectedAccountType = CadCli.TipoRegistroConta__c;
                }
            }
        }
        
    }
    
    public SolicitacaoCadastroCliente__c CadCli {get;set;}
    
    // salvar os dados do formulário
    public PageReference CustomSave() {
        
        if(cadcli.BR_Status__c == 'Em Elaboração')
            cadcli.BR_Status__c = 'Em Análise de Cadastro';
        else if (cadcli.BR_Status__c == 'Rejeitado' ||
                cadcli.BR_Status__c == 'Erro de Integração' ||
                cadcli.BR_Status__c == 'Enviado para Integração' ||
                cadcli.BR_Status__c == 'Cliente Integrado'){
                    // não pode editar
                    ApexPages.Message alerta = new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                                     'No Status atual esta solicitação não pode ser alterada.');
                    ApexPages.addMessage(alerta);
                    
                    PageReference pageRef = new PageReference('/apex/CadastroCliente');
                    return pageRef;
        }
        
        
        Boolean isValid = true;        
        
        //valida o CPF ou CNPJ
        if (showpageBlockPF == true){
         
            if (cadcli.BR_CPF__c == null){
                cadcli.addError('CPF é requerido, corrija a informação.');
                isValid = false;
            } else if (validate.getInstance().isCPF(cadcli.BR_CPF__c.replace('.','').replace('-','')) == false) {
                // CPF inválido
                cadcli.addError('CPF inválido, corrija a informação.');
                isValid = false;
            }
            
            if (cadcli.BR_Name__c == null){
                cadcli.addError('É necessário informar o nome, corrija a informação.');
                isValid = false;
            }
            
            if (cadcli.InscricaoEstadual__c == null)
                cadcli.InscricaoEstadual__c = 'ISENTO';
            
        } else {
            
            if (cadcli.BR_CNPJ__c == null){
                cadcli.addError('CNPJ é requerido, corrija a informação.');
                isValid = false;
            }
            
            if (validate.getInstance().isCNPJ(cadcli.BR_CNPJ__c.replace('.','').replace('/','').replace('-','')) == false) {
                // CPF inválido
                cadcli.addError('CNPJ inválido, corrija a informação.');
                isValid = false;
            }
            
            if (cadcli.BR_RazaoSocial__c == null){
                cadcli.addError('É necessário informar a Razão Social, corrija a informação.');
                isValid = false;
            }
            if (cadcli.InscricaoEstadual__c.contains('.') || cadcli.InscricaoEstadual__c.contains('-')){
                cadcli.addError('Na Inscrição Estadual preencha somente números.');
                isValid = false;
            }
            
            if (cadcli.InscricaoEstadual__c == null)
                cadcli.InscricaoEstadual__c = 'ISENTO';
        }
        
        if (CadCli.Unidade__c == null){
            cadcli.addError('É necessário informar a Unidade, corrija a informação.');
            isValid = false;
        }
        
        if (CadCli.BR_GrupoClientes__c == null){
            cadcli.addError('É necessário informar Grupo de Clientes, corrija a informação.');
            isValid = false;
        }
        
        if (CadCli.BR_Main_Address__c == null || CadCli.BR_Bairro__c == null || CadCli.BR_Main_City__c == null ||
            CadCli.BR_Main_Nbr__c == null || CadCli.BR_Main_State__c == null || CadCli.BR_Main_Zip_code__c == null ||
            CadCli.BR_Phone__c == null || CadCli.BR_email__c == null) {
                cadcli.addError('É necessário informar todos os campos do endereço, exceto complemento. corrija a informação.');
                isValid = false;
            }
        
        if (Cadcli.BR_RegionalVendas__c == null){
            cadcli.addError('É necessário selecionar uma regional de vendas, corrija a informação.');
            isValid = false;
        }
        
        if (selectedAccountType == null || selectedAccountType == '-- Nenhum --'){
            cadcli.addError('É necessário selecionar um Tipo Registro da Conta, corrija a informação.');
            isValid = false;
        } else {
            CadCli.TipoRegistroConta__c = selectedAccountType;
        }
        
        if (selectedEscritorioVenda == null || selectedEscritorioVenda == '-- Nenhum --' ){
            cadcli.addError('É necessário selecionar um escritório de vendas, corrija a informação.');
            isValid = false;
        } 
        else
            CadCli.BR_EscritorioVendas__c = selectedEscritorioVenda;
       
        if (selectedEquipeVenda == null || selectedEquipeVenda == '-- Nenhum --' ){
            cadcli.addError('É necessário selecionar uma equipe de vendas, corrija a informação.');
            isValid = false;
        }
        else
        	CadCli.BR_EquipeVendas__c = selectedEquipeVenda;
        
        if (CADCLI.BR_Observacoes__c == null){
            cadcli.addError('É necessário informar o motivo do cadastro, corrija a informação.');
            isValid = false;
        }
        
        System.Debug('é valido : ' + isValid);
        if (isValid){ 
            
            if (cadcli.BR_Status__c == 'Em Análise de Cadastro'){
                
                if(cadcli.Id == null){
                    insert cadcli; 
                }
                else{
                    update cadcli;
                }
                
                try{
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Enviando requisição de aprovação de cadastro de cliente.');
                    req.setObjectId(cadcli.Id);
                    Approval.ProcessResult result = Approval.process(req);
                }
                catch (Exception ex){
                    System.debug('Exception caught' + ex);
                }
            }
            else if (cadcli.BR_Status__c == 'Em Análise de Cadastro' 
                     || cadcli.BR_Status__c == 'Em Análise do Coordenador'){
                         update cadcli;
                     }
            
            PageReference pageRef = new PageReference('/apex/CadastroClienteLista');
            
            return (pageRef);
            
        } else {
            PageReference pageRef = new PageReference('/apex/CadastroCliente');
        	return pageRef;
        }
    }
    
    public PageReference Cancel(){
        PageReference pageRef = new PageReference('/apex/CadastroClienteLista');
        return pageRef;
    }
    
    Public Boolean showpageBlockPF{get; set;}
    Public Boolean showpageBlockSAP{get; set;}
    
    // troggle entre o painel de Pessoa física e jurídica
    Public void showBlockPF(){
        
        if (showpageBlockPF)
            showpageBlockPF = false;
        else
            showpageBlockPF = true;
    }
    
    // recupera o nome do usuário logado.
    public String getSolicitante() {        
        if (CadCli.CreatedById != null)
        	return CadCli.CreatedBy.FirstName + ' ' +  CadCli.CreatedBy.LastName;
        else
            return UserInfo.getFirstName() + ' ' + UserInfo.getLastName(); 
    }
    
    public String getProfileApproverName(){
        
        String uProfileId = UserInfo.getProfileId();
            
        Profile p = [select Name from profile where id =: uProfileId limit 1];
        
        return p.Name;
    }
    
    public void CheckProfileApprovers(){
        
        String uProfileId = UserInfo.getProfileId();
        
        Profile p = [select Name from profile where id =: uProfileId limit 1];
        
        System.debug('profile ' + p.Name);
        
        if (p.Name == 'Financeiro' || p.Name == 'Coordenador Cadastro' || p.Name == 'Administrador do sistema' )
            showpageBlockSAP = true;
        else
            showpageBlockSAP = false;
        
    }
    
    public PageReference SearchAccountByCpf(){
        
        ApexPages.getMessages().clear();
        PageReference pageRef = new PageReference('/apex/CadastroCliente');
        
        System.debug('busca CPF ' + CadCli.BR_CPF__c);
        if (CadCli.BR_CPF__c == null){
            
            cadcli.addError('Informe um CPF, corrija a informação.');
            
        } else if (validate.getInstance().isCPF(CadCli.BR_CPF__c.replace('.','').replace('-','')) == false) {
            
            cadcli.addError('CPF inválido, corrija a informação.');
            
        } else {
            
            list<Account> acc = [select id, 
                                 Name, 
                                 RecordTypeId,
                                 BR_CPF__c,
                                 BR_Approval_status__c,
                                 BR_Main_Address__c,
                                 BR_Main_Nbr__c,
                                 BR_Bairro__c,
                                 BR_Main_District__c,
                                 BR_Main_City__c,
                                 BR_Main_Zip_code__c,
                                 BR_Main_State__c,
                                 BR_Account_Id_SAP__c,
                                 BR_Account_email__c,
                                 BR_Area_code__c,
                                 Phone,
                                 Marca__c
                                 from account 
                                 where BR_CPF__c =: CadCli.BR_CPF__c limit 1];
            
            System.debug('qtde accounts ' + acc.size());
            if (acc.size() > 0){
                ApexPages.Message alerta = new ApexPages.Message(ApexPages.Severity.INFO, 
                                                                 'Conta localizada. Valide os dados antes de submeter ao time de cadastro.');
                ApexPages.addMessage(alerta);
                
                System.debug('marca ' + acc[0].Marca__c);
                
                CadCli.BR_Name__c = acc[0].Name;
                CadCli.InscricaoEstadual__c = 'ISENTO';
                if (verificaMarca(acc[0].Marca__c))
                	CadCli.Unidade__c = acc[0].Marca__c;
                CadCli.BR_Main_Address__c = acc[0].BR_Main_Address__c;
                CadCli.BR_Main_Nbr__c = acc[0].BR_Main_Nbr__c;
                CadCli.BR_Bairro__c = acc[0].BR_Bairro__c;
                CadCli.BR_Main_City__c = acc[0].BR_Main_City__c;
                CadCli.BR_Main_State__c = acc[0].BR_Main_State__c;
                CadCli.BR_Main_Zip_code__c = acc[0].BR_Main_Zip_code__c;
                CadCli.BR_Phone__c =  acc[0].Phone;
                CadCli.BR_email__c = acc[0].BR_Account_email__c;
                CadCli.BR_Conta__c = acc[0].id;
            	CadCli.BR_Name__c = acc[0].Name;
                CadCli.BR_RazaoSocial__c = acc[0].Name;
            } 
        }
        
        return pageRef;
    }
    
    public PageReference SearchAccountByCnpj(){
        
        ApexPages.getMessages().clear();
        PageReference pageRef = new PageReference('/apex/CadastroCliente');
        
        System.debug('busca CNPJ ' + CadCli.BR_CNPJ__c);
        if (CadCli.BR_CNPJ__c == null){
            
            cadcli.addError('Informe um CPF, corrija a informação.');
            
        } else if (validate.getInstance().isCNPJ(cadcli.BR_CNPJ__c.replace('.','').replace('/','').replace('-','')) == false) {
            
            cadcli.addError('CPF inválido, corrija a informação.');
            
        } else {
            
            list<Account> acc = [select id, 
                                 Name, 
                                 RecordTypeId,
                                 BR_CNPJ__c,
                                 BR_Company_Name__c,
                                 BR_tax_registration_number__c,
                                 BR_Approval_status__c,
                                 BR_Main_Address__c,
                                 BR_Main_Nbr__c,
                                 BR_Bairro__c,
                                 BR_Main_District__c,
                                 BR_Main_City__c,
                                 BR_Main_Zip_code__c,
                                 BR_Main_State__c,
                                 BR_Account_Id_SAP__c,
                                 BR_Account_email__c,
                                 BR_Area_code__c,
                                 Phone,
                                 Marca__c
                                 from account 
                                 where BR_CNPJ__c =: CadCli.BR_CNPJ__c limit 1];
            
            if (acc.size() > 0){
                ApexPages.Message alerta = new ApexPages.Message(ApexPages.Severity.INFO, 
                                                                 'Conta localizada. Valide os dados antes de submeter ao time de cadastro.');
                ApexPages.addMessage(alerta);
                
                System.debug('marca ' + acc[0].Marca__c);
                
                CadCli.BR_RazaoSocial__c = acc[0].BR_Company_Name__c;
                CadCli.InscricaoEstadual__c = acc[0].BR_tax_registration_number__c;
                
                if (verificaMarca(acc[0].Marca__c))
                	CadCli.Unidade__c = acc[0].Marca__c;
                CadCli.BR_Main_Address__c = acc[0].BR_Main_Address__c;
                CadCli.BR_Main_Nbr__c = acc[0].BR_Main_Nbr__c;
                CadCli.BR_Bairro__c = acc[0].BR_Bairro__c;
                CadCli.BR_Main_City__c = acc[0].BR_Main_City__c;
                CadCli.BR_Main_State__c = acc[0].BR_Main_State__c;
                CadCli.BR_Main_Zip_code__c = acc[0].BR_Main_Zip_code__c;
                CadCli.BR_Phone__c =  acc[0].Phone;
                CadCli.BR_email__c = acc[0].BR_Account_email__c;
                CadCli.BR_Conta__c = acc[0].id;
                CadCli.BR_Name__c = acc[0].Name;
                CadCli.BR_RazaoSocial__c = acc[0].Name;
            } 
        }
        
        return pageRef;
    }
    
    // algumas marcas que estão nos accounts, não existem na lista passada pelo time de cadastro. 
    // para evitar que a solicitação receba uma exceção é validada a marca existente no account.
    private boolean verificaMarca(String marca){
        boolean match = false;
        
        system.debug('marca selecionada : ' + marca);
        
        List<Schema.PicklistEntry>  fieldResult = 
            SolicitacaoCadastroCliente__c.Unidade__c.getDescribe().getPicklistValues();
        
        for( Schema.PicklistEntry f : fieldResult ){
            
            system.debug('item do picklist ' + f.getValue());
            if (f.getValue() == marca){
                match = true;
                break;
            }
        }
        
        return match;
    }
    
    public String selectedAccountType {get;set;}
    
    public list<SelectOption> getAccountTypes(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        // lista apenas os tipos que estiverem habilitados
        List<RecordType> types = [SELECT Id,Name, Description FROM RecordType WHERE SobjectType = 'Account' AND IsActive = true];
        
        options.Add(new SelectOption('-- Nenhum --','-- Nenhum --'));
        
        if (types.size() > 0) {
            for (RecordType t : types){
            	options.Add(new SelectOption(t.Id,t.name));    
            }
        }
            
        return options;
    }
        
    public list<SelectOption> optionsEscritorioVenda {get;set;}
    public String selectedEscritorioVenda {get;set;}   
    public list<SelectOption> getEscritorioVenda(){
        
        system.debug('getEscritorioVenda: Unidade ' + cadcli.Unidade__c);
        
        optionsEscritorioVenda = new list<SelectOption>();
        optionsEscritorioVenda.add(new SelectOption('-- Nenhum --','-- Nenhum --'));
                
        switch on cadcli.Unidade__c {
            when 'Dom Bosco', 'COC','NAME', 'Atitude'{
        		optionsEscritorioVenda.add(new SelectOption('E001','E001 - E. V. Público'));
        		optionsEscritorioVenda.add(new SelectOption('E002','E002 - E. V. Privado'));        
            }
            when 'Skill'{
                optionsEscritorioVenda.add(new SelectOption('SK','SK - SKILL'));
                optionsEscritorioVenda.add(new SelectOption('PG','PG - Projeto Governo'));
            }
            when 'Wizard'{
                optionsEscritorioVenda.add(new SelectOption('WZ','WZ - WIZARD'));
                optionsEscritorioVenda.add(new SelectOption('PG','PG - Projeto Governo'));
            }
            when 'Yazigi'{
                optionsEscritorioVenda.add(new SelectOption('YZ','YZ - YAZIGI'));
                optionsEscritorioVenda.add(new SelectOption('PG','PG - Projeto Governo'));
            }
            when 'HED' {
                optionsEscritorioVenda.add(new SelectOption('EV01','EV01 - E. V. São Paulo'));
            }
            when 'Corporate', 'Coleção Mentes', 'Leitura e Companhia'{
                optionsEscritorioVenda.add(new SelectOption('E002','E002 - E. V. Privado'));
            }
            when else {
        		optionsEscritorioVenda.clear(); // pra garantir rsrsr        
            }
        }
            
        return optionsEscritorioVenda;
    }
    
    public list<SelectOption> optionsEquipeVenda {get;set;}
    public String selectedEquipeVenda {get;set;}   
    public list<SelectOption> getEquipeVenda(){
        
        system.debug('getEquipeVenda: Escritório ' + selectedEscritorioVenda);
        
        optionsEquipeVenda = new list<SelectOption>();
        
        
        optionsEquipeVenda.add(new SelectOption('-- Nenhum --','-- Nenhum --'));
        switch on selectedEscritorioVenda {
            when 'FR'{
        		optionsEquipeVenda.add(new SelectOption('FR','FR - Franquias'));
            }            
            when 'E001'{
                optionsEquipeVenda.add(new SelectOption('001','001 - G. V. Público'));
            }            
            when 'E002'{
                optionsEquipeVenda.add(new SelectOption('002','002 - G. V. Privado'));
            }
            when 'PG'{
                optionsEquipeVenda.add(new SelectOption('FR','FR - FRANQUIAS'));
            }              
            when 'SK'{
                optionsEquipeVenda.add(new SelectOption('FR','FR - Franquias'));
                optionsEquipeVenda.add(new SelectOption('SK0','SK0 - SKILL CENTRO OESTE'));
                optionsEquipeVenda.add(new SelectOption('SK1','SK1 - SKILL SÃO PAULO CAPI'));
                optionsEquipeVenda.add(new SelectOption('SK2','SK2 - SKILL SÃO PAULO INTE'));
                optionsEquipeVenda.add(new SelectOption('SK3','SK3 - SKILL NORTE NORDESTE'));
                optionsEquipeVenda.add(new SelectOption('SK4','SK4 - SKILL RJ/MG/ES'));
                optionsEquipeVenda.add(new SelectOption('SK5','SK5 - SKILL SUL'));
                optionsEquipeVenda.add(new SelectOption('SK6','SK6 - SKILL SÃO PAULO VALE'));
            }
            when 'WZ'{
                optionsEquipeVenda.add(new SelectOption('FR','FR - Franquias'));
                optionsEquipeVenda.add(new SelectOption('WZ0','WZ0 - WIZARD CENTRAL MG'));
                optionsEquipeVenda.add(new SelectOption('WZ1','WZ1 - WIZARD CAPITAL PR'));
                optionsEquipeVenda.add(new SelectOption('WZ2','WZ2 - WIZARD DF'));
                optionsEquipeVenda.add(new SelectOption('WZ3','WZ3 - WIZARD ES'));
                optionsEquipeVenda.add(new SelectOption('WZ4','WZ4 - WIZARD GO/TO'));
                optionsEquipeVenda.add(new SelectOption('WZ5','WZ5 - WIZARD INTERNACIONAL'));
                optionsEquipeVenda.add(new SelectOption('WZ6','WZ6 - WIZARD INTERIOR PR'));
                optionsEquipeVenda.add(new SelectOption('WZ7','WZ7 - WIZARD LESTE RJ'));
                optionsEquipeVenda.add(new SelectOption('WZ8','WZ8 - WIZARD MG'));
                optionsEquipeVenda.add(new SelectOption('WZ9','WZ9 - WIZARD NORDESTE'));
                optionsEquipeVenda.add(new SelectOption('WZA','WZA - WIZARD NORTE NORDEST'));
                optionsEquipeVenda.add(new SelectOption('WZB','WZB - WIZARD NORTE'));
                optionsEquipeVenda.add(new SelectOption('WZC','WZC - WIZARD OESTE'));
                optionsEquipeVenda.add(new SelectOption('WZD','WZD - WIZARD OESTE RJ'));
                optionsEquipeVenda.add(new SelectOption('WZE','WZE - WIZARD SC/RS-OESTE'));
                optionsEquipeVenda.add(new SelectOption('WZF','WZF - WIZARD RJ'));
                optionsEquipeVenda.add(new SelectOption('WZG','WZG - WIZARD RS'));
                optionsEquipeVenda.add(new SelectOption('WZH','WZH - WIZARD SC'));
                optionsEquipeVenda.add(new SelectOption('WZI','WZI - WIZARD SUL MG'));
                optionsEquipeVenda.add(new SelectOption('WZJ','WZJ - WIZARD SP1'));
                optionsEquipeVenda.add(new SelectOption('WZK','WZK - WIZARD SP2'));
                optionsEquipeVenda.add(new SelectOption('WZL','WZL - WIZARD SP3'));
                optionsEquipeVenda.add(new SelectOption('WZM','WZM - WIZARD SP4'));
                optionsEquipeVenda.add(new SelectOption('WZN','WZN - WIZARD SP5'));
                optionsEquipeVenda.add(new SelectOption('WZO','WZO - WIZARD SERRA GAÚCHA'));
                
            }
            when 'YZ'{
                optionsEquipeVenda.add(new SelectOption('FR','FR - Franquias'));
                optionsEquipeVenda.add(new SelectOption('Y7A','Y7A - REGIÃO DO ABC'));
                optionsEquipeVenda.add(new SelectOption('Y7C','Y7C - YZ SÃO PAULO'));
                optionsEquipeVenda.add(new SelectOption('YZ0','YZ0 - YÁZIGI MT/MG/GO/DF'));
                optionsEquipeVenda.add(new SelectOption('YZ1','YZ1 - YÁZIGI ES/RJ NÃO UTL'));
                optionsEquipeVenda.add(new SelectOption('YZ2','YZ2 - YÁZIGI SC'));
                optionsEquipeVenda.add(new SelectOption('YZ3','YZ3 - YÁZIGI SP CAPITAL'));
                optionsEquipeVenda.add(new SelectOption('YZ4','YZ4 - YÁZIGI RS'));
                optionsEquipeVenda.add(new SelectOption('YZ5','YZ5 - YÁZIGI SP AMERICANA'));
                optionsEquipeVenda.add(new SelectOption('YZ6','YZ6 - YÁZIGI SP BAURÚ / PR'));
                optionsEquipeVenda.add(new SelectOption('YZ7','YZ7 - YÁZIGI SP VLE PARAÍB'));
                optionsEquipeVenda.add(new SelectOption('YZ8','YZ8 - YÁZIGI NORTE/MA'));
                optionsEquipeVenda.add(new SelectOption('YZ9','YZ9 - YÁZIGI NORDESTE'));
                optionsEquipeVenda.add(new SelectOption('YZB','YZB - COORD SP/CAP/LIT SUL'));
                optionsEquipeVenda.add(new SelectOption('YZC','YZC - YAZIGI RJ'));
                optionsEquipeVenda.add(new SelectOption('YZD','YZD - YAZIGI ES'));
            }
            when 'EV01' {
               	optionsEquipeVenda.add(new SelectOption('005','005 - Wilson Brunelli'));
                optionsEquipeVenda.add(new SelectOption('017','017 - WMiguel Gonçalves'));
                optionsEquipeVenda.add(new SelectOption('018','018 - Campanha Geral'));
                optionsEquipeVenda.add(new SelectOption('019','019 - Vendas Site – 10%'));
                optionsEquipeVenda.add(new SelectOption('020','020 - Vendas Site - 20%'));
                optionsEquipeVenda.add(new SelectOption('021','021 - Vendas Site - 30%'));
                optionsEquipeVenda.add(new SelectOption('022','022 - Vendas Site - 40%'));
                optionsEquipeVenda.add(new SelectOption('023','023 - Aniversar.do mês 50%'));
                optionsEquipeVenda.add(new SelectOption('024','024 - Campanha – 75%'));
                optionsEquipeVenda.add(new SelectOption('025','025 - Campanha Dic.Escolar'));
                optionsEquipeVenda.add(new SelectOption('026','026 - Campanha Insper'));
                optionsEquipeVenda.add(new SelectOption('027','027 - Feirão Virtual'));
                optionsEquipeVenda.add(new SelectOption('028','028 - Campanha Versan'));
                optionsEquipeVenda.add(new SelectOption('029','029 - Out. - Mês do Prof.'));
                optionsEquipeVenda.add(new SelectOption('030','030 - Uniube'));
                optionsEquipeVenda.add(new SelectOption('031','031 - Unopar'));
                optionsEquipeVenda.add(new SelectOption('032','032 - Eniac'));
                optionsEquipeVenda.add(new SelectOption('033','033 - Databyte'));
                optionsEquipeVenda.add(new SelectOption('034','034 - Michigan'));
                optionsEquipeVenda.add(new SelectOption('035','035 - Pronatec (Senac)'));
                optionsEquipeVenda.add(new SelectOption('036','036 - Recepção (Show Room)'));
                optionsEquipeVenda.add(new SelectOption('037','037 - Renato Correa'));
                optionsEquipeVenda.add(new SelectOption('038','038 - Thaís Zocoler'));
                optionsEquipeVenda.add(new SelectOption('039','039 - Anhanguera'));
                optionsEquipeVenda.add(new SelectOption('040','040 - Autor'));
                optionsEquipeVenda.add(new SelectOption('050','050 - Vendedor Interno'));
                optionsEquipeVenda.add(new SelectOption('100','100 - Vendedor Geral'));
            }
        }
            
        return optionsEquipeVenda;
    }
    
}