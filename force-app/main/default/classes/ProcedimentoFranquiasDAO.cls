/**
 * Created by re035946 on 08/02/2018.
 */
public class ProcedimentoFranquiasDAO {
	public static FR_Procedimento_Franquias__c getObjectByID(String pfId){
		return [SELECT
				Id,
				RecordTypeId,
				RecordType.DeveloperName,
				Name,
				BR_Conta__c,
				OwnerId,
				BR_StatusConsultoria__c,
				BR_TipoConsultoria__c
				FROM FR_Procedimento_Franquias__c
				WHERE Id =: pfId];
	}
}