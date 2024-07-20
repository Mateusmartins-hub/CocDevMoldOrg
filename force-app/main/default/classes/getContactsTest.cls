@isTest
public class getContactsTest {

    @isTest
    static void testOne() {
        Contact c = TestHelper.createContact();
        
        getContacts.getByPhone(new List<String> {'19983437513'});
    }
}