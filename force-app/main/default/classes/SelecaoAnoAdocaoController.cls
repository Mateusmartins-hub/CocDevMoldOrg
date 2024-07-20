public class SelecaoAnoAdocaoController {

    public String nameQuery {get;set;}
    public String anoSelecionado {get;set;}
    public String professorSelecionado {get;set;}
    public String letraRangeInicio {get;set;}
    public String letraRangeFim {get;set;}
    private String accountId;
    public List<SelectOption> lstAno {get;set;}
    public List<SelectOption> lstProfessor {get;set;}
    public List<SelectOption> lstLetras {get;set;}
    private List<Account_Contact__c> lstAccountContact;
    private Map<String, Integer> mapIndexLetras {get;set;}
    
    public SelecaoAnoAdocaoController() 
    {
        accountId = ApexPages.currentPage().getParameters().get('Conta');
        Integer anoAtual = System.today().year();
        Integer index = 0;
        lstAccountContact = new List<Account_Contact__c>();
        lstAno = new List<SelectOption>();
        lstProfessor = new List<SelectOption>();
        lstLetras = new List<SelectOption>();
        mapIndexLetras = new Map<String, Integer>(); 

        lstAno.add(new SelectOption('Todos', 'Todos'));
        for(Integer i = 0; i < 10; i++)
        {
            lstAno.add(new SelectOption(String.valueOf(anoAtual), String.valueOf(anoAtual)));
            anoAtual--;
        }

        lstProfessor.add(new SelectOption('Todos', 'Todos professores'));

        List<String> lstLetrasAlfabeto = new List<String>{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 
                                                          'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
        
        lstLetras.add(new SelectOption('Nenhum', 'Nenhum'));
        //lstLetrasFinais.add(new SelectOption('Nenhum', 'Nenhum'));
        for(String letra : lstLetrasAlfabeto)
        {
            lstLetras.add(new SelectOption(letra, letra));
            mapIndexLetras.put(letra, index);
            index++;
        }                                                          

        /*lstAccountContact = AccountContactDAO.getInstance().getListAccountContactByAccountId( accountId );
        
        if(lstAccountContact.size() < 999)
        {
            for( Account_Contact__c accountContact : lstAccountContact )
            {
                lstProfessor.add(new SelectOption(accountContact.Contact__c, accountContact.Contact__r.Name));    
            }
        }
        else
        {
            for(Integer i = 0; i < 999; i++)
            {
                Account_Contact__c accountContact = lstAccountContact[i];
                lstProfessor.add(new SelectOption(accountContact.Contact__c, accountContact.Contact__r.Name));    
            }

            String mensagem = 'Não foram listados todos os professores devido ao limite de 1000 registros. Esta conta possui ' + lstAccountContact.size() + 
                              '. Caso o professor desejado não esteja na listagem, realizar a busca por nome para encontra-lo.';

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, mensagem));                
        }*/

        this.professorSelecionado = 'Todos';
        this.letraRangeInicio = 'Nenhum';
        this.letraRangeFim = 'Nenhum';
    }

    public PageReference salvar()
    {
        if( String.isBlank(professorSelecionado) || professorSelecionado == 'Todos')
        {
            letraRangeInicio = (letraRangeInicio != 'Nenhum') ? letraRangeInicio : 'A';
            letraRangeFim = (letraRangeFim != 'Nenhum') ? letraRangeFim : 'Z';

            //Realiza validação do range de letras selecionados no filtro
            if(mapIndexLetras.get(letraRangeInicio) > mapIndexLetras.get(letraRangeFim)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Intervalo de letras inválido!'));
                return null;
            }

            PageReference pageRef = new PageReference('/apex/FichaProfessorNovo?TipoImpressao=Muitos&Ano=' + anoSelecionado + '&Conta=' + accountId + '&Professor=Todos' + '&letraI=' + letraRangeInicio + '&letraF=' + letraRangeFim);
            return pageRef;
        }
        else
        {
            PageReference pageRef = new PageReference('/apex/FichaProfessorNovo?TipoImpressao=Muitos&Ano=' + anoSelecionado + '&Conta=' + accountId + '&Professor=' + professorSelecionado);
            return pageRef;
        }
    }

    public PageReference cancelar()
    {
        PageReference pageRef = new PageReference('/' + accountId);
        return pageRef;
    }

    public void pesquisar()
    {
        professorSelecionado = '';
        lstProfessor = new List<SelectOption>();

        if(String.isNotBlank(this.nameQuery))
        {
            lstAccountContact = AccountContactDAO.getInstance().getListAccountContactByAccountIdAndContactName( accountId, '%' + this.nameQuery + '%' );
            lstProfessor.add(new SelectOption('Todos', 'Todos professores'));
            for( Account_Contact__c accountContact : lstAccountContact )
            {
                lstProfessor.add(new SelectOption(accountContact.Contact__c, accountContact.Contact__r.Name));    
            }
        }
    }
}