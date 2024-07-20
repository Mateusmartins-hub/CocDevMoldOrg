@isTest
private class MessagingDateTest {
	@isTest
    private static void horarioComercialTeste(){ 
        List<String> retorno = MessagingDate.HorarioComercial();
        if(retorno[0] == 'Atendimento'){
        	System.debug('Dentro do horário comercial');
        }else if(retorno[0] == 'Almoço' && retorno[1] == 'Fora'){
            System.debug('Fora do horário comercial');
        }
    } 
}