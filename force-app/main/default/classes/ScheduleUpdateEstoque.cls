global class ScheduleUpdateEstoque implements Schedulable{
    global void  execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateEstoqueBatch(), 150);
    }
}