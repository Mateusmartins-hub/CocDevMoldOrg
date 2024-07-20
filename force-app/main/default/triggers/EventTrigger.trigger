trigger EventTrigger on Event (before insert, before delete, before update) {
    new EventTriggerHandler().run();
}