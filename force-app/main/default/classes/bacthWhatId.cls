public class bacthWhatId implements Database.Batchable<sObject>{
    public String idPart = '';
    
    public bacthWhatId(String idPart){
        this.idPart = idPart + '%';
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT OldWhatId__c, WhatId  FROM Event WHERE WhatId = NULL AND OldWhatId__c LIKE : idPart');
    }
    
    public void execute(Database.BatchableContext BC, List<Event> scope){
        
        if(scope.size() > 0){
            Set<String> listID = new Set<String>();
            List<Event> updateEv = new List<Event>();
            
            for(Event e : scope){
                listID.add(e.OldWhatId__c);
            }
            
            if(idPart == '001%'){
                List<Account> obje = [SELECT idSegregacao__c, id FROM Account WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(Account obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == '006%'){
                List<Opportunity> obje = [SELECT idSegregacao__c, id FROM Opportunity WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(Opportunity obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == '01t%'){
                List<Product2> obje = [SELECT idSegregacao__c, id FROM Product2 WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(Product2 obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == '0Q0%'){
                List<Quote> obje = [SELECT idSegregacao__c, id FROM Quote WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(Quote obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == '500%'){
                List<Case> obje = [SELECT idSegregacao__c, id FROM Case WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(Case obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == '800%'){
                List<Contract> obje = [SELECT idSegregacao__c, id FROM Contract WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(Contract obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == 'a07%'){
                List<BR_Procedimento_Pedag_gico__c> obje = [SELECT idSegregacao__c, id FROM BR_Procedimento_Pedag_gico__c WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(BR_Procedimento_Pedag_gico__c obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == 'a08%'){
                List<BR_Relat_rio_de_Visita_Pedag_gica__c> obje = [SELECT idSegregacao__c, id FROM BR_Relat_rio_de_Visita_Pedag_gica__c WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(BR_Relat_rio_de_Visita_Pedag_gica__c obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == 'a0B%'){
                List<BR_Procedimento_NAME__c> obje = [SELECT idSegregacao__c, id FROM BR_Procedimento_NAME__c WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(BR_Procedimento_NAME__c obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == 'a0c%'){
                List<BR_Procedimento_Visita__c> obje = [SELECT idSegregacao__c, id FROM BR_Procedimento_Visita__c WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(BR_Procedimento_Visita__c obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == 'a0D%'){
                List<FR_Plano_de_Acao__c> obje = [SELECT idSegregacao__c, id FROM FR_Plano_de_Acao__c WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(FR_Plano_de_Acao__c obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == 'a0E%'){
                List<FR_Procedimento_Franquias__c> obje = [SELECT idSegregacao__c, id FROM FR_Procedimento_Franquias__c WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(FR_Procedimento_Franquias__c obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == 'a0R%'){
                List<Account_Contact__c> obje = [SELECT idSegregacao__c, id FROM Account_Contact__c WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(Account_Contact__c obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            if(idPart == 'a0Z%'){
                List<Visitas__c> obje = [SELECT idSegregacao__c, id FROM Visitas__c WHERE idSegregacao__c IN:listID];
                
                for(Event e : scope){
                    for(Visitas__c obj:obje){
                        if(obj.idSegregacao__c == e.OldWhatId__c){
                            e.WhatId = obj.Id;
                            updateEv.add(e);
                        }
                    } 
                } 
            }
            
            System.debug('updateEv: '+updateEv);
            update updateEv;
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
    
}