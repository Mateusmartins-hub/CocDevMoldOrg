public class Lead_CPFCNPJ {
    
    public static void validateCPFCNPJ(List<Lead> leads) {
        for(Lead l : leads) {
            String cpf = l.CPF__c;
            String cnpj = l.CNPJ__c;
            
            if(String.isNotBlank(cpf)) {
                if(!isCPF(cpf))
                    l.CPF__c.addError('CPF Inválido.');
                else
                    l.CPF__c = printCPF(cpf);
            }
            
            if(String.isNotBlank(cnpj)) {
                if(!isCNPJ(cnpj))
                    l.CNPJ__c.addError('CNPJ Inválido.');
                else
                    l.CNPJ__c = printCNPJ(cnpj);
            }
        }
    }
    
    public static boolean isCPF(String CPF) {
        CPF = CPF.replaceAll('[^\\d]','');
        
        if (CPF.equals('00000000000') || CPF.equals('11111111111') || CPF.equals('22222222222') || CPF.equals('33333333333') ||
            CPF.equals('44444444444') || CPF.equals('55555555555') || CPF.equals('66666666666') || CPF.equals('77777777777') ||
            CPF.equals('88888888888') || CPF.equals('99999999999') || (CPF.length() != 11))
            return false;
        
        Integer dig10;
        Integer dig11;
        Integer sm = 0;
        Integer i;
        Integer r;
        Integer num;
        Integer peso = 10;
        
        List<String> cpfString = CPF.split('');
        
        for (i = 0; i < 9; i++) {
            num = Integer.valueOf(cpfString[i]); 
            sm = sm + (num * peso);
            peso = peso - 1;
        }
        
        r = 11 - Math.mod(sm,11);
        
        if ((r == 10) || (r == 11))
            dig10 = 0;
        else 
            dig10 = r;
        
        sm = 0;
        peso = 11;
        for(i = 0; i < 10; i++) {
            num = Integer.valueOf(cpfString[i]);
            sm = sm + (num * peso);
            peso = peso - 1;
        }
        
        r = 11 - Math.mod(sm,11);
        if ((r == 10) || (r == 11))
            dig11 = 0;
        else 
            dig11 = r;
        
        if (dig10 == Integer.valueOf(cpfString[9]) && dig11 == Integer.ValueOf(cpfString[10]))
            return true;
        else 
            return false;
    }
    
    public static String printCPF(String CPF) {
        CPF = CPF.replaceAll('[^\\d]','');
        return(CPF.substring(0, 3) + '.' + CPF.substring(3, 6) + '.' + CPF.substring(6, 9) + '-' + CPF.substring(9, 11));
    }
    
    public static boolean isCNPJ(String CNPJ) {
        CNPJ = CNPJ.replaceAll('[^\\d]','');
        if (CNPJ.equals('00000000000000') || CNPJ.equals('11111111111111') || CNPJ.equals('22222222222222') || CNPJ.equals('33333333333333') ||
            CNPJ.equals('44444444444444') || CNPJ.equals('55555555555555') || CNPJ.equals('66666666666666') || CNPJ.equals('77777777777777') ||
            CNPJ.equals('88888888888888') || CNPJ.equals('99999999999999') || (CNPJ.length() != 14))
            return false;
        
        Integer i;
        Integer sm = 0;
        Integer dig13;
        Integer dig14;
        Integer r;
        Integer num;
        Integer peso = 2;
        
        List<String> cnpjString = CNPJ.split('');
        
        for (i = 11; i >= 0; i--) {
            num = Integer.valueOf(cnpjString[i]);
            sm = sm + (num * peso);
            peso = peso + 1;
            if (peso == 10)
                peso = 2;
        }
        
        r = Math.mod(sm, 11);
        if ((r == 0) || (r == 1))
            dig13 = 0;
        else 
            dig13 = Integer.valueOf(11-r);
        
        sm = 0;
        peso = 2;
        for (i = 12; i >= 0; i--) {
            num = Integer.valueOf(cnpjString[i]);
            sm = sm + (num * peso);
            peso = peso + 1;
            if (peso == 10)
                peso = 2;
        }
        
        r = Math.mod(sm, 11);
        if ((r == 0) || (r == 1))
            dig14 = 0;
        else 
            dig14 = Integer.valueOf(11-r);
        
        
        if (dig13 == Integer.valueOf(cnpjString[12]) && dig14 == Integer.valueOf(cnpjString[13]))
            return true;
        else 
            return false ;
    }
    
    public static String printCNPJ(String CNPJ) {
        CNPJ = CNPJ.replaceAll('[^\\d]','');
        return(CNPJ.substring(0, 2) + '.' + CNPJ.substring(2, 5) + '.' + CNPJ.substring(5, 8) + '/' + CNPJ.substring(8, 12) + '-' + CNPJ.substring(12, 14));
    }
}