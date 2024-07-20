public class ContentDocumentLinkUtils {
    
    public static void setVisibility(List<ContentDocumentLink> lstContDocLink, String optVisibility) {		        
        for(ContentDocumentLink l : lstContDocLink){ //trigger.new
            l.Visibility = optVisibility; //'AllUsers'; 
        }
	}

}