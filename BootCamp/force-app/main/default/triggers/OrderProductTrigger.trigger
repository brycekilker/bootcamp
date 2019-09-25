trigger OrderProductTrigger on OrderItem (after insert, before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
       OrderProductTriggerHandler.beforeInsertMethod(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
       OrderProductTriggerHandler.afterInsertMethod(Trigger.new);
    }
}