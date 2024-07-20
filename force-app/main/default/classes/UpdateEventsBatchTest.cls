@isTest
public class UpdateEventsBatchTest {
    @isTest
    public static void Executar()
    {
        Account ac = TestHelper.CreateAccount();
        insert ac;
        
        Event e = new Event();
        e.WhatId = ac.Id;
        e.Subject = 'teste';
        e.StartDateTime = Datetime.now();
        e.EndDateTime = DateTime.now().addMinutes(30);
        insert e;
        
		Database.executeBatch(new UpdateEventsBatch(60));
    }
}