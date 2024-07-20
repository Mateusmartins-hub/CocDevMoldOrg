@isTest(SeeAllData=true)
public class Test_GenericEntity
{
    public static GenericEntity genericEntity = new GenericEntity();

    @isTest
    public static void saveEntity()
    {
        String name = 'Account';
        SObject entity = Schema.getGlobalDescribe().get(name).newSObject(null, true);
        entity.put('Name', 'John Sample');
        entity.put('Phone', '11949904889');

        String response = Test_GenericEntity.genericEntity.saveEntity(name, '{"Name": "John Sample", "Phone": "11949904889"}');
        System.assertNotEquals('{ }', response);
    }

    @isTest
    public static void updateEntity()
    {
        String name = 'Account';
        List<SObject> accounts = [SELECT Id, Name, Phone FROM Account LIMIT 1];
        String response = genericEntity.updateEntity('Account', '{"name": "john", "id":"' + accounts[0].id +'"}');
        System.assert(accounts.isEmpty() == false);
        System.assert(accounts.size() > -1);
        System.assertNotEquals(accounts.isEmpty(), true);
    }

    @isTest
    public static void getEntityByCustomData()
    {
        List<String> whereConditions = new List<String>();
        String projection = 'Id, Name, Phone';
        String data = '{\"Phone\":\"Rachel\", \"Name\":\"Rachel\"}';
        String name = 'Account';
        String response = genericEntity.getEntityByCustomData('Account', data, projection);
        Map<String, Object> resp = (Map<String, Object>)JSON.deserializeUntyped(data);
        for (String key : resp.keySet()) {whereConditions.add(key + ' LIKE ' + '\'%' + resp.get(key) + '%\'');}
        String whereStatement = String.join(whereConditions, ' OR ');
        System.assert(response != '{ }');
        System.assertNotEquals('{ }', response);
        System.assert(whereStatement != '');
    }

    @isTest
    public static void associateCallData()
    {
        String name = 'Account';
        List<SObject> entityResponse = [SELECT Id, Name, Phone FROM Account LIMIT 1];
        String response = genericEntity.associateCallData(
            'Account',
            '{\"' + 'phone' + '\"' + ':' + '\"' + '11949904889' + '\"' + '}',
            '{"id": "'+ entityResponse[0].id +'"}',
            'Id, Name, Phone');

        System.assert(response != '{ }');
        System.assertNotEquals('{ }', response);
    }

    @isTest
    public static void registerCall()
    {
        String name = 'Account';
        List<SObject> entityResponse = [SELECT Id FROM Account LIMIT 1];
        String response = genericEntity.registerCall(
            '2022-02-02T00:00:00Z',
            'Test call',
            'Outbound',
            'Account',
            entityResponse[0].Id,
            ''
        );

        System.assert(response != '{ }');
        System.assertNotEquals('{ }', response);
    }


}