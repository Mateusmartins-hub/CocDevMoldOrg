public without sharing class PublicGroupManagementController {

    @AuraEnabled
    public static Boolean checkPermission(){
        try{
            return FeatureManagement.checkPermission('Gerenciar_grupos_publicos');
        } catch (Exception e) {
            return false;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<UserData> searchUsers(String searchTerm){
        try{
                
            List<List<sObject>> result = [FIND :searchTerm IN NAME FIELDS RETURNING User(Id, Name, Email, Alias WHERE IsActive = true)];

            List<UserData> returnList = new List<UserData>();

            for(List<sObject> resultLine: result){
                for(sObject line : resultLine){
                    User user = (User)line;

                    UserData data = new UserData(
                        user.Id,
                        user.Name, 
                        user.Alias, 
                        user.Email,
                        user
                    );

                    returnList.add(data);
                }
            }
            return returnList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<GroupData> searchGroups(String searchTerm){
        try{

            List<List<sObject>> result = [FIND :searchTerm IN ALL FIELDS RETURNING Group(Id, Name WHERE Type = 'Regular')];
            
            List<GroupData> returnList = new List<GroupData>();

            for(List<sObject> resultLine: result){
                for(sObject line : resultLine){

                    Group groupData = (Group)line;

                    GroupData data = new GroupData(
                        groupData.Id,
                        null,
                        groupData.Name, 
                        groupData
                    );

                    returnList.add(data);
                }
            }
            return returnList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addGroupsToUsers(String userToGroupJson){
        try{
        
            List<Object> userToGroup = (List<Object>)JSON.deserializeUntyped(userToGroupJson);
            
            List<GroupMember> memberships = new List<GroupMember>();
            
            for(Object userGroup : userToGroup){
                
                Map<String, Object> userGroupMap = (Map<String, Object>)userGroup;
                
                GroupMember membership = new GroupMember(
                    GroupId = Id.valueOf((String)userGroupMap.get('group')),
                    UserOrGroupId = Id.valueOf((String)userGroupMap.get('user'))
                );

                memberships.add(membership);
            }

            insert memberships;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void removeUsersFromGroups(List<String> membershipsIds){
        try{
            List<GroupMember> memberships = [
                SELECT Id FROM GroupMember WHERE Id IN :membershipsIds
            ];

            delete memberships;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, List<GroupData>> retrieveGroupsOfUser(List<String> usersId){
        try {

            Map<String, List<GroupData>> mapToReturn = new Map<String, List<GroupData>>();
            
            List<GroupMember> memberships = [
                SELECT Id, Group.Name, GroupId, UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN :usersId
            ];

            for(GroupMember membership : memberships){

                List<GroupData> groups = mapToReturn.get(membership.UserOrGroupId);

                if(groups == null){
                    groups = new List<GroupData>();
                }

                groups.add(
                    new GroupData(membership.GroupId, membership.Id, membership.Group.Name, membership)
                );
                
                mapToReturn.put(membership.UserOrGroupId, groups);
            }

            return mapToReturn;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @TestVisible
    class UserData{
        public UserData(String id, String name, String alias, String email, Object record){
            this.id = id;
            this.name = name;
            this.alias = alias;
            this.email = email;
            this.record = record;
        }

        @AuraEnabled
        public String id;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public String alias;

        @AuraEnabled
        public String email;

        @AuraEnabled 
        public Object record;
    }

    @TestVisible
    class GroupData{

        public GroupData(String id, String membershipId, String name, Object record){
            this.id = id;
            this.membershipId = membershipId;
            this.name = name;
            this.record = record;
        }

        @AuraEnabled
        public String id;

        @AuraEnabled
        public String membershipId;

        @AuraEnabled
        public String name;

        @AuraEnabled 
        public Object record;

    }
}