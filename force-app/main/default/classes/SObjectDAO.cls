/*
Nome do Arquivo:                        SObjectDAO.cls
Empresa:                                Pearson
Desenvolvedor:                          Luiz Prandini
Descrição do Código:                    Classe genérica para inserção de todos os objetos no SF.

Histórico de Alterações:
Versão        Data              Responsável             Descrição da Alteração
1.0         17/09/2014          Luiz Prandini           Criação da controller

*/

public abstract class SObjectDAO{
    
    public Database.SaveResult insertData(SObject sObj){
        Database.SaveResult sr = null;
        
        try {
            sr = Database.insert(sObj);
        }catch(DMLException ex){
            throw ex;
        }
         
        return sr;
    }
    
    public List<Database.SaveResult> insertData(List<SObject> lstSObj){
        List<Database.SaveResult> lstSR = null;
        
        try {
            lstSR = Database.insert(lstSObj);
        }catch(DMLException ex){
             throw ex;
        }
        
        return lstSR;
    }
    
    public Database.SaveResult updateData(SObject sObj){
        Database.SaveResult sr = null;
        
        try{
            sr = Database.update(sObj);
        }catch(DMLException ex){
            throw ex;
        }
        
        return sr;
    }
    
    public List<Database.SaveResult> updateData(List<SObject> lstSObj){
        List<Database.SaveResult> lstSR = null;
        
        try{
            lstSR = Database.update(lstSObj);
        }catch(DMLException ex){
            throw ex;
        }
        
        return lstSR;
    }
    
    public Database.DeleteResult deleteData(String id){
        Database.DeleteResult dr = null;
        
        try{   
            dr = Database.delete(id);
        }catch(DMLException ex){
            throw ex;
        }
        
        return dr;
    }
    
    public List<Database.DeleteResult> deleteData(List<String> lstId){
        List<Database.DeleteResult> lstDR = null;
        
        try{
            lstDR = Database.delete(lstId);
        }catch(DMLException ex){
            throw ex;
        }
        
        return lstDR;
    }
    
    public List<Database.DeleteResult> deleteData(List<SObject> lstSObj){
        List<Database.DeleteResult> lstDR = null;
        
        try{
            lstDR = Database.delete(lstSObj);
        }catch(DMLException ex){
            throw ex;
        }
        
        return lstDR;
    }
}