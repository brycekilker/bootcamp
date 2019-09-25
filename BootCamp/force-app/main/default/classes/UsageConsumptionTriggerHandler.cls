public with sharing class UsageConsumptionTriggerHandler extends TriggerHandler {
    public UsageConsumptionTriggerHandler() {
        System.debug(LoggingLevel.DEBUG, 'UsageConsumptionTriggerHandler constructor');
    }

    protected override void afterInsert() {
        System.debug(System.LoggingLevel.DEBUG, 'UsageConsumptionTriggerHandler.afterInsert');
        System.debug('UsageConsumptionTriggerHandler.afterInsert: this is after insert ' + Trigger.new);
        updateTotalCharge(Trigger.new);
    }

    protected override void afterUpdate() {
        System.debug(System.LoggingLevel.FINE, 'UsageConsumptionTriggerHandler.afterUpdate');
        System.debug('this is after update' + Trigger.new);
        updateTotalCharge(Trigger.new);
    }
 
    protected override void afterDelete() {
        System.debug(System.LoggingLevel.FINE, 'UsageConsumptionTriggerHandler.afterDelete');
        updateTotalCharge(Trigger.old);
    }
    //I'm sure I could do this whole thing more succinctly
    public static void updateTotalCharge(List<Usage_Consumption__c> usageConsumptionRecords) {        
        Map<Id, Decimal> UsageSummaryMapToUpdate = new Map<Id, Decimal>();
       //Make a map of usage summary Id's and consumption usage ammount
        for (Usage_Consumption__c record : usageConsumptionRecords) {
            UsageSummaryMapToUpdate.put(record.Usage_Summary__c, record.Usage_Amount__c);
        }

        List<Usage_Summary__c> usageSummariesToUpdate = new List<Usage_Summary__c>();

        for(Id usageSummaryId : UsageSummaryMapToUpdate.keySet()) {
            Usage_Summary__c usageSummary = [SELECT Id, Last_Consumption_Update__c
            FROM Usage_Summary__c
            WHERE Id = :usageSummaryId
            ];
            //basically making this update to fire the trigger
            usageSummary.Last_Consumption_Update__c = Date.today();
            usageSummariesToUpdate.add(usageSummary);
        }
//TODO GET THIS TO TRIGGER MY TRIGGER ON USAGE SUMMMARY
        if(usageSummariesToUpdate.size() > 0) {
            update usageSummariesToUpdate;
        }
    }

}
