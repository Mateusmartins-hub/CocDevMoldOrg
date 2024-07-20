public class MessagingDate {
 /* public static Datetime now {
        get {
            if (now == null) {
                return now = Datetime.now();
            } else {
                return now;
            }
        }
        set;
    }*/
    @InvocableMethod(label = 'Dentro do horário comercial?')
    public static List<String> HorarioComercial() {
        system.debug('Entrou no métoodo >>>>>>>>>>>>>>>>');
	List<String> BHName = new List<String>{'Brazil', 'Horário de Almoço'};
        //String Almoco= String.valueOf(+Name[1]);
        system.debug('list' + BHName );
        
        // Get Business hours based on name, input from bot
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name =:BHName[0] ];
        BusinessHours al = [SELECT Id FROM BusinessHours WHERE Name =:BHName[1] ];
        
        system.debug('bh' + bh);
        system.debug('al' + al);
        
        // Create Datetime with current date/time in local time zone
        Datetime now = datetime.now();
        System.debug('now>>>>>>>>>>>>' + now);
        
        // Find whether the time is within business hours
        Boolean isWithin= BusinessHours.isWithin(bh.id, now);
        Boolean IntervaloAlmoco= BusinessHours.isWithin(al.id, now);
        system.debug('isWithin>>>>>>>>>>' +isWithin);
        system.debug('IntervaloAlmoco>>>>>>>>>' + IntervaloAlmoco);
    
        /*if( DateTime.now().hour() > 12 && DateTime.now().hour() <= 14 ){
            isWithin = false;
            return new List<Boolean>{isWithin, IntervaloAlmoco};
        }else{
            IntervaloAlmoco = false;*/
        List<String> List1 = new List<String> ();
        if(IntervaloAlmoco== true ){
            List1.add('Almoço');
                }if(isWithin == true && IntervaloAlmoco== false){
            List1.add('Atendimento');
                }else{
                    List1.add('Fora');
                }
        Return List1;
	}
}