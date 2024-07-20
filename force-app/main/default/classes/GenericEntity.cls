global class GenericEntity {
    public String saveEntity(String name, String data) {
        SObject entity = Schema.getGlobalDescribe().get(name).newSObject(null, true);
        Map<String, Object> resp = (Map<String, Object>)JSON.deserializeUntyped(data);
        for (String key : resp.keySet()) {
            if (key.equals('CloseDate')) {
                String keyValue = resp.get(key).toString();
                entity.put(key, date.valueOf(keyValue));
                continue;
            }
            entity.put(key, resp.get(key));
        }
        insert entity;
        return JSON.serialize(entity);
    }

    public String updateEntity(String name, String data) {
        Map<String, Object> resp = (Map<String, Object>)JSON.deserializeUntyped(data);
        SObject entity = Schema.getGlobalDescribe().get(name).newSObject(null, true);
        String query;
        for (String key : resp.keySet()) {
            if ((key == 'Id') || (key == 'id')) {
                entity.put('Id', resp.get(key));
                String column = key;
                if (name == 'Case') {
                    column = 'CaseNumber';
                }
                query = column + ' = ' + '\'' + resp.get(key) + '\'';
            }
        }
        List<SObject> dbResult = Database.query('SELECT Id' + ' from ' + name + ' WHERE ' + query);
        if (name == 'Case' && dbResult.size() <= 0) {
            try {
                String entityId = (String)(resp.get('Id') != null ? resp.get('Id') : resp.get('id'));
                dbResult = Database.query('SELECT Id from ' + name + ' WHERE Id = \'' + entityId + '\'');
            } catch(Exception e) {
            }
        }
        if (dbResult.size() > 0) {
            entity = dbResult[0];
            for (String key : resp.keySet()) {
                if (key == 'id' || key == 'Id') { continue; }
                if (key.equals('CloseDate')) {
                    String keyValue = resp.get(key).toString();
                    entity.put(key, date.valueOf(keyValue));
                    continue;
                }
                entity.put(key, resp.get(key));
            }
        }
        update entity;
        return JSON.serialize(entity);
    }

    public String getEntityByCustomData(String entity, String data, String projection) {
        String query = 'SELECT ' + projection + ' from ' + entity;
        List<String> whereConditions = new List<String>();
        if (data.length() > 0) {
            Map<String, Object> resp = (Map<String, Object>)JSON.deserializeUntyped(data);
            for (String key : resp.keySet()) {
                if (key.equals('Id') || key.equals('id') || key.equals('AccountId') || key.equals('ContactId')) {
                    whereConditions.add(key + ' = \'' + resp.get(key) + '\'');
                    continue;
                }
                whereConditions.add(key + ' LIKE ' + '\'%' + resp.get(key) + '%\'');
            }
        }
        String whereStatement = String.join(whereConditions, ' OR ');
        if (whereStatement.length() > 0) {
            query = query + ' WHERE ' + whereStatement;
        }
        List<SObject> response = Database.query(query);
        return JSON.serialize(response);
    }

    public String associateCallData(String name, String callData, String businessData, String properties) {
        SObject entity = Schema.getGlobalDescribe().get(name).newSObject(null, true); String id;
        Map<String, Object> business = (Map<String, Object>)JSON.deserializeUntyped(businessData);
        for (String key : business.keySet()) { entity.put(key, business.get(key)); }
        Map<String, Object> call = (Map<String, Object>)JSON.deserializeUntyped(callData);
        for (String key : call.keySet()) { entity.put(key, call.get(key)); }
        update entity; return JSON.serialize(entity);
    }

    public String registerCall(String callDate, String description, String callType, String customerType, String customerId, String whatId) {
        Task newTask = new Task(
            Description=description,
            Priority='Normal',
            Status='Completed',
            Subject='Ligação 55PBX',
            CallType=callType,
            TaskSubtype='Call',
            ActivityDate=date.valueOf(callDate)
        );

        customerType = customerType.toLowerCase();

        if (customerType.equals('lead')) newTask.WhoId = customerId;

        if (customerType.equals('account')) newTask.WhatId = customerId;

        if (customerType.equals('contact')) {
            newTask.WhoId = customerId;

            if (!whatId.equals('')) newTask.WhatId = whatId;
        }

        insert newTask;

        return JSON.serialize(newTask);
    }
}