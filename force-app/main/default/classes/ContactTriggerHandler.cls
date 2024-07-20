public without sharing class ContactTriggerHandler extends TriggerHandler{
    
    public override void afterInsert(){
        ContactBO.updateAccountData((List<Contact>)Trigger.new);
    }
    
    public override void afterUpdate() {
        ContactBO.atualizarMediaPesquisaSatisfacao((List<Contact>)Trigger.new, (Map<Id, Contact>)Trigger.oldMap);
        ContactBO.updateAccountData((List<Contact>)Trigger.new);
    }

    public override void beforeInsert(){
        ContactBO.setHierarchyByFunction((List<Contact>)Trigger.new);
    }

    public override void beforeUpdate(){
        ContactBO.setHierarchyByFunction((List<Contact>)Trigger.new);
    }
}