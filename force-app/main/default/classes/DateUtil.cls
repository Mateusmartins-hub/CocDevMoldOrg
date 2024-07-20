public class DateUtil {
    
    public static Date dateTimeToDate(DateTime dt) {
        return Date.newInstance(dt.year(), dt.month(), dt.day());
    }
    
	public static String formatDate(Date data) 
    {
        return format(data.day(), data.month(), data.year());
    }
    
    public static String formatDateTime(DateTime data) 
    {
        return format(data.day(), data.month(), data.year());
    }
    
    private static String format(integer day, integer month, integer year)
    {
        String dia = String.valueOf(day);
        dia = day >= 10 ? dia : '0' + dia;

        String mes = String.valueOf(month);
        mes = month >= 10 ? mes : '0' + mes;

        return dia + '/' + mes + '/' + String.valueOf(year);
    }

    public static String formatDate(Datetime fDate){
        Datetime tday   = fDate;
        String ano      = String.valueOf(tday.year());
        String mes      = (tday.month() < 10) ? '0'+ String.valueOf(tday.month()) : String.valueOf(tday.month());
        String dia      = (tday.day() < 10) ? '0'+ String.valueOf(tday.day()) : String.valueOf(tday.day());
        String hora     = (tday.hour() < 10) ? '0'+ String.valueOf(tday.hour()) : String.valueOf(tday.hour());
        String minuto   = (tday.minute() < 10) ? '0'+ String.valueOf(tday.minute()) : String.valueOf(tday.minute());
        String segundo  = (tday.second() < 10) ? '0'+ String.valueOf(tday.second()) : String.valueOf(tday.second());

        String dataFormated = ano+mes+dia+'T'+hora+minuto+segundo+'Z';
        return dataFormated;

    }
}