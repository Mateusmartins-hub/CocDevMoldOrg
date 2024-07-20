global class getContacts {
    @InvocableMethod
    public static List<Contact> getByPhone(List<String> phone) {
        Long L1 = long.valueOf(phone.get(0));
        return [SELECT Id, FirstName, LastName, Name, Phone, Email FROM Contact WHERE TelefoneIndexado__c != null AND TelefoneIndexado__c =: L1 LIMIT 5];
    }
}