trigger QuoteTrigger on SBQQ__Quote__c (before insert, before update) {

    if(Trigger.isBefore && Trigger.isInsert){
        QuoteTriggerHandler.beforeInsertMethod(Trigger.new);
    }

    if(Trigger.isBefore && Trigger.isUpdate){
        QuoteTriggerHandler.beforeUpdateMethod(Trigger.new);
    }
}