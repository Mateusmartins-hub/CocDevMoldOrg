trigger UpdateActivityFields_Event on Event (before insert, before update) { 
    List<Id> ids = new List<Id>();
    for(Event e : trigger.new) { 
        ids.add(e.WhatId);
    }

    Map<Id, Account> mapConta = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :ids]);

    for(Event e : trigger.new) { 
        e.Start_Date_Time__c = e.StartDateTime;

        if (mapConta.containsKey(e.WhatId))
        {
            if (!string.isBlank(e.subject) && !e.subject.contains(mapConta.get(e.WhatId).Name))
                e.Subject = e.Subject + ' - ' + mapConta.get(e.WhatId).Name;
        }
    } 
}