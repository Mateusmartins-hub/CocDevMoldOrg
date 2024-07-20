/*
Nome do Arquivo:                        PricebookDAO.cls
Empresa:                                Pearson
Desenvolvedor:                          Luiz Prandini
Descrição do Código:                    Classe DAO para a Pricebook.

Histórico de Alterações:
Versão          Data            Responsável         Descrição da Alteração
1.0             15/10/2014      Luiz Prandini       Criação do Controller

*/ 

public with sharing class PricebookDAO extends SObjectDAO{
    
    private static final PricebookDAO instance = new PricebookDAO();
    
    private PricebookDAO(){
    }
    
    /**
* Método responsável por prover a instância dessa classe.
*/  
    public static PricebookDAO getInstance(){
        return instance;
    }
    
    public Pricebook2 findByName(string namePriceBook){	
        
        if( !Test.isRunningTest() ){
            return [SELECT Id,  Name  FROM Pricebook2  WHERE Name = : namePriceBook];
            
        }else{
            System.debug('ENTROU AQUI ');
            return TestHelper.createPricebook();
        }
        
    }
    
    public Pricebook2 getPricebookById(Id pbId){
        if( !Test.isRunningTest() ){
            return [SELECT Id, Name FROM Pricebook2  WHERE Id =: pbId];
            
        }else{
            System.debug('ENTROU AQUI ');
            return TestHelper.createPricebook();
        }
    }
    
    public List<Pricebook2> getActivePricebookList(){
        return [SELECT Id,
                Name
                FROM Pricebook2
                WHERE IsActive = true ];
    }
    
}