@isTest
public class RDStationContactTest {

    @isTest
    static void testOne() {
        RDStationContact con = new RDStationContact();
        RDStationContact.parse(JSON.serialize(con));
        RDStationContact.unparse(con);
    }
}