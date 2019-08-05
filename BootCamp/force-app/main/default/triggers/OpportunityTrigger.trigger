trigger OpportunityTrigger on Opportunity (after insert, after update) {

    if (Trigger.isAfter && Trigger.isInsert) {
       OpportunityTriggerHandler.afterInsertMethod(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.afterUpdateMethod(Trigger.new, Trigger.oldMap);  	
    }
}