public class GEN_ChartController {
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getCOsData(Date dStartIn, Date dEndIn) {



        if (dStartIn == null && dEndIn == null){
            List<AggregateResult> COs = [
                SELECT BR_Conta__r.Lideranca_Consultoria__r.Name Lider, BR_Conta__r.Consultor_Escolar__r.Name Consultor, BR_Conta__r.Name Escola, 
                SUM(Presencial__c) Presenciais, SUM(Naopresencial__c) Online
                FROM FR_Procedimento_Franquias__c WHERE BR_Conta__c != ''
                GROUP BY BR_Conta__r.Lideranca_Consultoria__r.Name, BR_Conta__r.Consultor_Escolar__r.Name, BR_Conta__r.Name LIMIT 2000
            ];
            return COs;
        }else{
            Date dStart = dStartIn;
            Datetime DatetimeStar = datetime.newInstance(dStart.year(), dStart.month(),dStart.day());

            Date dEnd = dEndIn;
            Datetime DatetimeEnd = datetime.newInstance(dEnd.year(), dEnd.month(),dEnd.day());

            List<AggregateResult> COsData = [
                SELECT BR_Conta__r.Lideranca_Consultoria__r.Name Lider, BR_Conta__r.Consultor_Escolar__r.Name Consultor, BR_Conta__r.Name Escola, 
                SUM(Presencial__c) Presenciais, SUM(Naopresencial__c) Online
                FROM FR_Procedimento_Franquias__c WHERE CreatedDate > =: DatetimeStar and CreatedDate < =:DatetimeEnd AND BR_Conta__c != ''
                GROUP BY BR_Conta__r.Lideranca_Consultoria__r.Name, BR_Conta__r.Consultor_Escolar__r.Name, BR_Conta__r.Name LIMIT 2000
            ];
            return COsData;
        }
    } 
}    

/*
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getCOs() {
        List<AggregateResult> COs = [
            /*SELECT BR_Conta__r.Lideranca_Consultoria__r.Name Lider, BR_Conta__r.Consultor_Escolar__r.Name Consultor, BR_Conta__r.Name Escola, 
            SUM(Visitas_Realizadas__c) Presenciais, SUM(Naopresencial__c) Online
            FROM FR_Procedimento_Franquias__c WHERE BR_Conta__c != ''
            GROUP BY BR_Conta__r.Lideranca_Consultoria__r.Name, BR_Conta__r.Consultor_Escolar__r.Name, BR_Conta__r.Name LIMIT 2000

            SELECT BR_Conta__r.Lideranca_Consultoria__r.Name Lider, BR_Conta__r.Consultor_Escolar__r.Name Consultor, BR_Conta__r.Name Escola, 
            SUM(Visitas_Realizadas__c) Presenciais, SUM(Naopresencial__c) Online
            FROM FR_Procedimento_Franquias__c where CreatedDate >= 
            2023-07-01T07:00:00.000+0000 and CreatedDate <= 2023-07-31T07:00:00.000+0000 AND BR_Conta__c != ''
            GROUP BY BR_Conta__r.Lideranca_Consultoria__r.Name, BR_Conta__r.Consultor_Escolar__r.Name, BR_Conta__r.Name LIMIT 2000
        ];
        return COs;
    }   

}*/