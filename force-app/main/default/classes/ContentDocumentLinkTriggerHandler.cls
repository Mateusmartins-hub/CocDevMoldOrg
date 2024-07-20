public class ContentDocumentLinkTriggerHandler extends TriggerHandler {
    
    public static final String VISIBILITY_ALL_USERS = 'AllUsers';

    public override void beforeInsert() {
        ContentDocumentLinkUtils.setVisibility((List<ContentDocumentLink>) Trigger.new, VISIBILITY_ALL_USERS);
    }

    public override void beforeUpdate() {
        ContentDocumentLinkUtils.setVisibility((List<ContentDocumentLink>) Trigger.new, VISIBILITY_ALL_USERS);
    }
    
}