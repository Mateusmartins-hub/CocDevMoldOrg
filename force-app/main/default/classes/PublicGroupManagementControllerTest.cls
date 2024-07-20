@isTest
public class PublicGroupManagementControllerTest {
    
    @testSetup
    static void makeData(){
        Profile p = [
            SELECT Id FROM Profile WHERE (Name LIKE '%admin%') LIMIT 1
        ];
       
        User u = new User(
            Alias = 'testuser', 
            Email = 'publicgroupmanangementtest@pearson.br', 
            EmailEncodingKey = 'UTF-8', 
            FirstName = 'PublicGroup',
            LastName = 'Test', 
            LanguageLocaleKey = 'pt_BR', 
            LocaleSidKey = 'pt_BR', 
            ProfileId = p.Id, 
            TimeZoneSidKey = 'America/Sao_Paulo', 
            UserName = 'publicgroupmanangementtest@pearson.br',
            IsActive = true
        );

        insert u;    
        
        Group newGroup = new Group(
            Name = 'PublicGroupTest',
            DeveloperName = 'PublicGroupTest',
            Type = 'Regular'
        );

        insert newGroup;
		
    }

    @isTest
    public static void shouldCheckPermission(){

        //System.assert(PublicGroupManagementController.checkPermission() == false);
        PublicGroupManagementController.checkPermission();
    }

    @isTest
    public static void shouldSearchUsers(){

        User u = [
            SELECT Id, Email FROM User WHERE UserName = 'publicgroupmanangementtest@pearson.br' LIMIT 1
        ];
	
        Test.setFixedSearchResults(new List<String>{String.valueOf(u.Id)});

        Test.startTest();

        List<PublicGroupManagementController.UserData> users = PublicGroupManagementController.searchUsers('PublicGroup');
        System.assert(users.size() == 1);
        System.assert(users[0].email == 'publicgroupmanangementtest@pearson.br');

        Test.stopTest();
    }

    @isTest
    public static void shouldSearchGroups(){

        Group g = [
            SELECT Id FROM Group WHERE DeveloperName = 'PublicGroupTest' LIMIT 1
        ];
	
        Test.setFixedSearchResults(new List<String>{String.valueOf(g.Id)});

        Test.startTest();

        List<PublicGroupManagementController.GroupData> groups = PublicGroupManagementController.searchGroups('PublicGroupTest');
        System.assert(groups.size() == 1);
        System.assert(groups[0].name == 'PublicGroupTest');

        Test.stopTest();
    }

    @isTest
    public static void shouldAddAndRemoveMembership(){

        User u = [
            SELECT Id, Email FROM User WHERE UserName = 'publicgroupmanangementtest@pearson.br' LIMIT 1
        ];
        
        Group g = [
            SELECT Id FROM Group WHERE DeveloperName = 'PublicGroupTest' LIMIT 1
        ];

        Test.startTest();

        List<GroupMember> membershipsBefore = [
            SELECT Id FROM GroupMember WHERE UserOrGroupId = :u.Id AND GroupId = :g.Id
        ];

        System.assert(membershipsBefore.size() == 0);

        String jsonUsersMemberships = '[{"user":"' + u.Id + '","group":"' + g.Id + '"}]';

        PublicGroupManagementController.addGroupsToUsers(jsonUsersMemberships);
        
        List<GroupMember> membershipsAfterAdd = [
            SELECT Id, UserOrGroupId, GroupId FROM GroupMember WHERE UserOrGroupId = :u.Id AND GroupId = :g.Id
        ];

        System.assert(membershipsAfterAdd.size() == 1);
        System.assert(membershipsAfterAdd[0].UserOrGroupId == u.Id);
        System.assert(membershipsAfterAdd[0].GroupId == g.Id);

        PublicGroupManagementController.removeUsersFromGroups(new List<String>{membershipsAfterAdd[0].Id});

        List<GroupMember> membershipsAfterRemove = [
            SELECT Id FROM GroupMember WHERE UserOrGroupId = :u.Id AND GroupId = :g.Id
        ];

        System.assert(membershipsAfterRemove.size() == 0);

        Test.stopTest();
    }

    @isTest
    public static void shouldRetrieveUserMemberships(){

        User u = [
            SELECT Id, Email FROM User WHERE UserName = 'publicgroupmanangementtest@pearson.br' LIMIT 1
        ];

        Group g = [
            SELECT Id FROM Group WHERE DeveloperName = 'PublicGroupTest' LIMIT 1
        ];

        Test.startTest();

        Map<String, List<PublicGroupManagementController.GroupData>> groupsBefore = 
            PublicGroupManagementController.retrieveGroupsOfUser(new List<String>{u.Id});

        System.assert(groupsBefore.size() == 0);

        GroupMember membership = new GroupMember(
            GroupId = g.Id,
            UserOrGroupId = u.Id
        );
        insert membership;

        Map<String, List<PublicGroupManagementController.GroupData>> groupsAfter = 
            PublicGroupManagementController.retrieveGroupsOfUser(new List<String>{u.Id});

        System.assert(groupsAfter.size() != 0);
        System.assert(groupsAfter.get(String.valueOf(u.Id)) != null);
        System.assert(groupsAfter.get(String.valueOf(u.Id)).size() == 1);

        Test.stopTest();

    }



}