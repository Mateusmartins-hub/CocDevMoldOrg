/*
	@author Diego Moreira
*/
public with sharing class EventRelationDAO {
	private static final EventRelationDAO instance = new EventRelationDAO ();
    
    private EventRelationDAO(){}
    
    public static EventRelationDAO getInstance(){
        return instance;
    }
    
    /*
    	Retorna os compromissos com contatos relacionados
    */
    public List<EventRelation> getEventsRelationsByEventId( String eventId ) {
    	return [SELECT RelationId FROM EventRelation
    				WHERE EventId = :eventId
    				AND IsWhat = false];
    }
}