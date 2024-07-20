public class CaseUtil {
    public static void contagem(List<Case> Casos,Map<Id,Case> oldMap){
        for(Case atual: Casos){
            if(atual.Status == 'Reaberto' && atual.Status != oldMap.get(atual.id).Status){
                atual.ContarReabertura__c += 1;
            }
        }
    }
}