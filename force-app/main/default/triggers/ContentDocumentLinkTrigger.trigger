trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert, before update) {  
    new ContentDocumentLinkTriggerHandler().run();
}