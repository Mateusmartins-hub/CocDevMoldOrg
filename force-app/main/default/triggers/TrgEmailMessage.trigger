trigger TrgEmailMessage on EmailMessage (before insert, before update, after insert, after update) {
    new EmailMessageTriggerHandler().run();
}