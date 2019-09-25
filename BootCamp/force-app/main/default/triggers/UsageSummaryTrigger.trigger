trigger UsageSummaryTrigger on Usage_Summary__c (after insert, after update, after delete) {
new UsageSummaryTriggerHandler().run();
}