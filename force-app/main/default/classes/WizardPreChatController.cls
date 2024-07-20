public class WizardPreChatController {
    
    @AuraEnabled 
    public static User getUser(){
       User u = [Select id,Name, FirstName, LastName, Email from User where id =: UserInfo.getUserId()];
       return u;
    }

}