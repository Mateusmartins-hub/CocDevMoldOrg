public with sharing class UserIntroductionController {

    @AuraEnabled(cacheable=true)
    public static User getUser(String userId) {

        User user = [ SELECT Id, IntroductionToCommunity__c, Username	
            FROM User
            WHERE Id = :userId limit 1];

        return user;

    }

    @AuraEnabled
    public static Boolean updateUser(User user) {

        update user;
        return true;

    }
}