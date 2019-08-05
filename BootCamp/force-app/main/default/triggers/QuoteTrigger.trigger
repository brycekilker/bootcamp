trigger QuoteTrigger on SBQQ__Quote__c (before insert, after insert,
 before update, after update, before delete, after delete, after undelete) {
    if (Trigger.isBefore && Trigger.isInsert) {
       QuoteTriggerHandler.beforeInsertMethod(Trigger.new,Trigger.oldMap);
    }

    // if (Trigger.isBefore && Trigger.isUpdate) {
    //    QuoteTriggerHandler.beforeUpdateMethod(Trigger.new,Trigger.oldMap);
    // }

    // if (Trigger.isAfter && Trigger.isInsert) {
    //    QuoteTriggerHandler.afterInsertMethod(Trigger.new,Trigger.oldMap);
    // }

    if (Trigger.isAfter && Trigger.isUpdate) {
        QuoteTriggerHandler.afterUpdateMethod(Trigger.new,Trigger.oldMap);  	

    }
}