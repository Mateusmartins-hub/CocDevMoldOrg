@IsTest
public class ConstantsTest {

    @IsTest
    static void TesteUnico(){
        
        Test.startTest();

        // fala sério. Precisa mudar isso logo para as configurações. Mas teremos de alterar TODAS as classes que usam isso.
        Constants c = new Constants(); 
        Test.stopTest();
    }
}