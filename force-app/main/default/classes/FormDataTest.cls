@isTest
public class FormDataTest {

    @isTest
    static void testOne() {
        String contentType = FormData.GetContentType();
        String boundary = FormData.WriteBoundary();
        String boundary2 = FormData.WriteBoundary(FormData.EndingType.CrLf);
        
        String form64 = '';
        form64 += FormData.append('id', 'test');
        form64 += FormData.append('message', 'test');
        
        Blob formBlob = FormData.makeBlob(form64);
        FormData.writeFileBody('test', formBlob, 'test');
        FormData.makeBlobWithFile('test', formBlob, 'test', null); 
    }
}