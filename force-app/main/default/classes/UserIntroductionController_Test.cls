@isTest
public class UserIntroductionController_Test {
    @isTest static void Test1(){
        UserIntroductionController.updateUser(UserIntroductionController.getUser(UserInfo.getUserId()));
    }
}