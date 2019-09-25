trigger UsageConsumptionTrigger on Usage_Consumption__c (after insert, after update, after delete) {
new UsageConsumptionTriggerHandler().run();
}