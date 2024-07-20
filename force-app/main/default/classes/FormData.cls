public class FormData {
    private final static String Boundary = '1ff13444ed8140c7a32fc4e6451aa76d';
    public enum EndingType {Cr, CrLf, None}
    
    public static String GetContentType() {
        return 'multipart/form-data; charset="UTF-8"; boundary="' + Boundary + '"';
    }
    
    private static String SafelyPad(String value,String valueCrLf64,String lineBreaks) {
        String valueCrLf = '';
        Blob valueCrLfBlob = null;
        
        while (valueCrLf64.endsWith('=')) {
            value += ' ';
            valueCrLf = value + lineBreaks;
            valueCrLfBlob = Blob.valueOf(valueCrLf);
            valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
        }
        
        return valueCrLf64;
    }
    
    public static String WriteBoundary() {
        String value = '--' + Boundary + '\r\n';
        Blob valueBlob = Blob.valueOf(value);
        
        return EncodingUtil.base64Encode(valueBlob);
    }
    
    public static String WriteBoundary(EndingType ending) {
        String value = '';
        
        if (ending == EndingType.Cr) {
            value += '\n';
        } else if (ending == EndingType.None) {
            value += '\r\n';
        }
        
        value += '--' + Boundary + '--';
        
        Blob valueBlob = Blob.valueOf(value);
        
        return EncodingUtil.base64Encode(valueBlob);
    }
    
    public static String WriteBodyParameter(String key, String value) {
        String contentDisposition = 'Content-Disposition: form-data; name="' + key + '"';
        
        String contentDispositionCrLf = contentDisposition + '\r\n\r\n';
        
        Blob contentDispositionCrLfBlob = Blob.valueOf(contentDispositionCrLf);
        
        String contentDispositionCrLf64 = EncodingUtil.base64Encode(contentDispositionCrLfBlob);
        
        String content = SafelyPad(contentDisposition, contentDispositionCrLf64, '\r\n\r\n');
        String valueCrLf = value + '\r\n';
        
        Blob valueCrLfBlob = Blob.valueOf(valueCrLf);
        
        String valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob); 
        
        Integer file64Length = valueCrLf64 .length();
        String last4Bytes = valueCrLf64 .subString(valueCrLf64 .length()-4,valueCrLf64 .length());        
        
        content += SafelyPad(value, valueCrLf64, '\r\n');
        return content;
    }
    
    public static String writeFileBody(String key, Blob attachBody, String filename) {
        String header = '--' + boundary + '\r\n' +
            + 'Content-Type: application/octet-stream\r\n'+
            + 'Content-Disposition: form-data; name="' + key + '";filename="' + filename + '"';        
        
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
        while(headerEncoded.endsWith('=')){
            header += ' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String footer = '--' + boundary + '--';     
        String bodyEncoded = EncodingUtil.base64Encode(attachBody);
        return headerEncoded+bodyEncoded;
    }   
    public static String append(String key, String value){
        String formParam = WriteBoundary() + WriteBodyParameter(key, value);
        return formParam;
    }
    
    public static Blob makeBlobWithFile(String key, Blob attachBody, String filename, String otherParamsEncoded){
        String header = '--' + boundary + '\r\n' +
            + 'Content-Type: application/octet-stream\r\n'+
            + 'Content-Disposition: form-data; name="'+key+'";filename="' + filename +'"';        
        
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
        while(headerEncoded.endsWith('=')){
            header += ' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String footer = '--' + boundary + '--';     
        String bodyEncoded = EncodingUtil.base64Encode(attachBody);       
        Blob formBlob = null;    
        String last4Bytes = bodyEncoded .subString(bodyEncoded.length()-4,bodyEncoded.length());
        
        if(last4Bytes.endsWith('==')) {
            last4Bytes = last4Bytes.subString(0,2) + '0K';
            bodyEncoded = bodyEncoded.subString(0,bodyEncoded.length()-4) + last4Bytes;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            formBlob = EncodingUtil.base64Decode(otherParamsEncoded+headerEncoded+bodyEncoded+footerEncoded);
            
        } else if(last4Bytes.endsWith('=')) {
            last4Bytes = last4Bytes.subString(0,3) + 'N';
            bodyEncoded = bodyEncoded.subString(0,bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            formBlob = EncodingUtil.base64Decode(otherParamsEncoded+headerEncoded+bodyEncoded+footerEncoded);
        } else {
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            formBlob = EncodingUtil.base64Decode(otherParamsEncoded+headerEncoded+bodyEncoded+footerEncoded);
        }
        
        return formBlob;
        
    }
    
    public static Blob makeBlob(String ParamsEncoded){
        String footer = '--' + boundary + '--';   
        Blob formBlob = null;    
        
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        formBlob = EncodingUtil.base64Decode(ParamsEncoded+footerEncoded);
        
        return formBlob;
    }
}