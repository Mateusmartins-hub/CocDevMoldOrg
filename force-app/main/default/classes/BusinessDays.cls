public class BusinessDays {
    public BusinessHours bHours;
    
    public BusinessDays(String businessHoursName){
        bHours = [SELECT Id FROM BusinessHours WHERE Name =: businessHoursName];
    }
     
    public BusinessDays(){
        bHours = [SELECT Id FROM BusinessHours WHERE IsDefault = true Limit 1];
    }
    
    public Datetime addDays(Datetime startDate, Integer days) {
        startDate = BusinessHours.nextStartDate(bHours.Id, startDate);
		
        for (Integer elapsed = 0; elapsed < days; elapsed++) {
            startDate = startDate.addDays(1);

            if (!BusinessHours.isWithin(bHours.Id, startDate))
                startDate = BusinessHours.nextStartDate(bHours.Id, startDate);
        }
        
        return startDate;
    }
    
    public Datetime subtractDays(Datetime startDate, Integer days) {
        startDate = getPreviousWorkingDay(startDate);
        
        for (Integer elapsed = 0; elapsed < days; elapsed++) {
            startDate = startDate.addDays(-1);
            
            if (!BusinessHours.isWithin(bHours.Id, startDate))
            	startDate = getPreviousWorkingDay(startDate);

        }
        
        return startDate;
    }
    
    public Datetime getPreviousWorkingDay(Datetime d){
        if (!BusinessHours.isWithin(bHours.Id, d)) {
            d = d.addDays(-1);
            return getPreviousWorkingDay(d);
        } else {
            return d;
        }
    }
    
    public Datetime getNextWorkingDay(Datetime d){
        return BusinessHours.nextStartDate(bHours.Id, d);
    }
    
    public Boolean isWorkingDay(Datetime d){
        return BusinessHours.isWithin(bHours.Id, d);
    }
    
    public Integer getNoOfBusinessDaysBetweenDates(DateTime startDate, DateTime endDate){
        Integer count = 0;
        while(startDate <= endDate){
            if(BusinessHours.isWithin(bHours.Id, startDate)){
                count++;
            }
            startDate = startDate.addDays(1);
        }
        return count;
    }
}