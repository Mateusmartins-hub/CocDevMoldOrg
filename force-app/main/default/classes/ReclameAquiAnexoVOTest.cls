@isTest
public class ReclameAquiAnexoVOTest {
  
    @isTest
    static void testOne() {
        string json = '{"attachmentLink":"test", "attachmentName":"Test"}';
        
        ReclameAquiAnexoVO.parse(json);
    }
}