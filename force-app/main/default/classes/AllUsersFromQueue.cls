public without sharing class AllUsersFromQueue {
    public Map<id, Set<Id>> mapOfGroupIdToUsersOnly = new Map<id, Set<Id>>();
    public Map<id, Set<Id>> mapOfGroupIdToInnerGroups = new Map<id, Set<Id>>();
    public Map<Id, Set<Id>> mapUserId = new Map<Id, Set<Id>>();
    private static List<GroupMember> membrosGrupo;
    
    public AllUsersFromQueue(){
        createMapsOfGroups();
    }
    
    public Map<Id, Set<Id>> getUsers(Id parentGroupId, Set<Id> GroupsId) {
        for (Id gId : GroupsId) {
            Id parent = parentGroupId == null ? gId : parentGroupId;
            if(mapOfGroupIdToUsersOnly != null && mapOfGroupIdToUsersOnly.containsKey(gId)) {
                if (!mapUserId.containsKey(parent))
                    mapUserId.put(parent, new Set<Id>());
                
                mapUserId.get(parent).addAll(mapOfGroupIdToUsersOnly.get(gId));
            }
            
            if(mapOfGroupIdToInnerGroups.containsKey(gId)) {
                Set<Id> ids = new Set<Id>();
                for(Id eachInnerGroup : mapOfGroupIdToInnerGroups.get(gId))
                    ids.add(eachInnerGroup);
                
                getUsers(parent, ids);
            }
        }
        
        return mapUserId;
    }
    
    public void createMapsOfGroups(){

        if(membrosGrupo == null) {
            membrosGrupo = [SELECT UserOrGroupId, GroupId, Group.Name FROM GroupMember WHERE Group.Type = 'Queue' OR Group.Type = 'Regular'];
        }
        
        for(GroupMember eachGroupMember : membrosGrupo) {
            if(String.valueOf(eachGroupMember.UserOrGroupId).startsWith('005')) {
                if(!mapOfGroupIdToUsersOnly.containsKey(eachGroupMember.GroupId))
                    mapOfGroupIdToUsersOnly.put(eachGroupMember.GroupId, new Set<Id>());
                
                mapOfGroupIdToUsersOnly.get(eachGroupMember.GroupId).add(eachGroupMember.UserOrGroupId);
            } else if(String.valueOf(eachGroupMember.UserOrGroupId).startsWith('00G')) {
                if(!mapOfGroupIdToInnerGroups.containsKey(eachGroupMember.GroupId))
                    mapOfGroupIdToInnerGroups.put(eachGroupMember.GroupId, new Set<Id>());
                
                mapOfGroupIdToInnerGroups.get(eachGroupMember.GroupId).add(eachGroupMember.UserOrGroupId);
            }
        }
    }
    
    // Método Estático para ser chamado via Component
    @AuraEnabled
    public static Boolean isUserOnQueue(String queueId) {    
        return isUserOnQueue(new List<String>{queueId})[0];
    }
    
    // Método Estático para ser chamado via Flow
    @InvocableMethod(label='Usuário pertence à fila?')
    public static List<Boolean> isUserOnQueue(List<String> queuesId) {     
        String queueId = queuesId[0];
        Map<Id, User> mapUsers = new Map<Id, User>([SELECT Id, Profile.Name, ProfileId FROM User WHERE Id = :UserInfo.getUserId()]);
        
        AllUsersFromQueue users = new AllUsersFromQueue();
        Map<Id, Set<Id>> usuariosDoGrupo = users.getUsers(null, new Set<Id>{queueId});
        
        if(!mapUsers.get(UserInfo.getUserId()).Profile.Name.contains('Inteligência & MKT') &&
           !mapUsers.get(UserInfo.getUserId()).Profile.Name.contains('Sucesso do Cliente') &&
           !mapUsers.get(UserInfo.getUserId()).Profile.Name.contains('Admin') &&
           usuariosDoGrupo.containsKey(queueId) &&
           !usuariosDoGrupo.get(queueId).contains(UserInfo.getUserId()))
            return new List<Boolean>{false};
        else        
            return new List<Boolean>{true};
    }
}