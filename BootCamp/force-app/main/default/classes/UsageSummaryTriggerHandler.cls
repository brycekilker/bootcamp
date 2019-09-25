public with sharing class UsageSummaryTriggerHandler extends TriggerHandler {
    protected override void afterUpdate() {
        System.debug(System.LoggingLevel.FINE, 'UsageSummaryTriggerHandler.afterUpdate');
        System.debug('this is after update' + Trigger.new);
        updateUsageTotal(Trigger.new);
    }

    public static void updateUsageTotal(List <Usage_Summary__c> usageSummaryresults) {
        System.debug('usage Summary Results ' + usageSummaryresults);
        //convert list to map. cant pull trigger.newMap off TriggerHandler libary class for some reason
        Map<Id, Usage_Summary__c> usageSummaryMap = new Map<Id, Usage_Summary__c>();
            for(Usage_Summary__c usageSummary : usageSummaryresults)
            {
                usageSummaryMap.put(usageSummary.Id, usageSummary);
            }

        List<Usage_Consumption__c> usageConsumptionList = [
            SELECT Id, Usage_Summary__c, Usage_Amount__c
            FROM Usage_Consumption__c
            WHERE Usage_Summary__c IN :usageSummaryMap.Keyset()
            ];
        System.debug('do we have the usage consumptions? ' + usageConsumptionList);

        List<Usage_Summary__c> usageSummaryList = [
            SELECT Id, Grand_Total_Usage__c
            FROM Usage_Summary__c
            WHERE Usage_Summary__c.Id IN :usageSummaryMap.Keyset()
        ];
//Loop through the usage consmption list and update corresponding usage summary
    List<Usage_Summary__c> usageSummariesToUpdate = new List<Usage_Summary__c>();

        for(Usage_Summary__c usageSummary : usageSummaryList) {
            usageSummary.Grand_Total_Usage__c = 0;
            for(Usage_Consumption__c usageConsumption : usageConsumptionList) {
                if(usageConsumption.Usage_Summary__c == usageSummary.Id){
                    usageSummary.Grand_Total_Usage__c += usageConsumption.Usage_Amount__c;
                }
            }
            usageSummariesToUpdate.add(usageSummary);
        }
        
        TriggerHandler.bypass('UsageSummaryTriggerHandler');
            if(usageSummariesToUpdate.size() > 0) {
            update usageSummariesToUpdate;
            }
        TriggerHandler.clearBypass('UsageSummaryTriggerHandler');
        calculateTotalCharge(usageSummariesToUpdate);
    }

    public static void calculateTotalCharge(List<Usage_Summary__c> usageSummaries) {
        System.debug('this is in the calculator --------> ' + usageSummaries );
        //Get the values we need for pricing calculations
        List<Usage_Summary__c> calcList = [
            SELECT Id, Grand_Total_Usage__c, Order_Product__c, Base_Charge__c, Overage_Charge__c, Total_Charge__c, Minimum_Paid__c,
                Order_Product__r.Base_Usage_Rate__c, Order_Product__r.Usage_Frequency__c,
                Order_Product__r.Usage_Minimum_Commit__c, Order_Product__r.Usage_Overage_Rate__c,
                Order_Product__r.Usage_Overage_Threshold__c, Order_Product__r.Usage_Product__c,
                Order_Product__r.Usage_Type__c
            FROM Usage_Summary__c
            WHERE Id IN :usageSummaries
        ];
        System.debug('do we have what we need? ' + calcList);
        //List of usage Summaries to update
        List<Usage_Summary__c> usageSummariesToUpdate = new List<Usage_Summary__c>();

        //loop over usage summaries
        for (Usage_Summary__c usageSummary : calcList) {
            if(usageSummary.Grand_Total_Usage__c == null) {
                usageSummary.Grand_Total_Usage__c = 0;
            }
            if(usageSummary.Base_Charge__c == null) {
                usageSummary.Base_Charge__c = 0;
            }
            if(usageSummary.Overage_Charge__c == null) {
                usageSummary.Overage_Charge__c = 0;
            }
            if(usageSummary.Order_Product__r.Usage_Minimum_Commit__c == null) {
                usageSummary.Order_Product__r.Usage_Minimum_Commit__c = 0;
            }
            if(usageSummary.Order_Product__r.Usage_Overage_Threshold__c == null) {
                usageSummary.Order_Product__r.Usage_Overage_Threshold__c = 0;
            }
            if(usageSummary.Order_Product__r.Base_Usage_Rate__c == null) {
                usageSummary.Order_Product__r.Base_Usage_Rate__c = 0;
            }
            if(usageSummary.Order_Product__r.Usage_Overage_Rate__c == null) {
                usageSummary.Order_Product__r.Usage_Overage_Rate__c = 0;
            }
            //1. check overage threshold - if it is under just use the base, 
            //otherwise, multiple base rate * usage over threshold and multiply (grand total - usage threshold) * overage rate
            if(usageSummary.Grand_Total_Usage__c <= usageSummary.Order_Product__r.Usage_Minimum_Commit__c) {
                usageSummary.Base_Charge__c = usageSummary.Order_Product__r.Usage_Minimum_Commit__c * usageSummary.Order_Product__r.Base_Usage_Rate__c;
            } else if (usageSummary.Grand_Total_Usage__c <= usageSummary.Order_Product__r.Usage_Overage_Threshold__c) {
                usageSummary.Base_Charge__c = usageSummary.Grand_Total_Usage__c * usageSummary.Order_Product__r.Base_Usage_Rate__c;
            } else {
                usageSummary.Base_Charge__c = usageSummary.Order_Product__r.Usage_Overage_Threshold__c * usageSummary.Order_Product__r.Base_Usage_Rate__c;
                usageSummary.Overage_Charge__c = (usageSummary.Grand_Total_Usage__c - usageSummary.Order_Product__r.Usage_Overage_Threshold__c) * usageSummary.Order_Product__r.Usage_Overage_Rate__c;
            }
            System.debug('were getting there ' + usageSummary.Base_Charge__c);
            usageSummary.Total_Charge__c = usageSummary.Base_Charge__c + usageSummary.Overage_Charge__c;
            if(usageSummary.Minimum_Paid__c == true) {
                usageSummary.Total_Charge__c -= usageSummary.Order_Product__r.Usage_Minimum_Commit__c * usageSummary.Order_Product__r.Base_Usage_Rate__c;
            }
            usageSummariesToUpdate.add(usageSummary);
        }
        
        TriggerHandler.bypass('UsageSummaryTriggerHandler');
            if(usageSummariesToUpdate.size() > 0) {
            update usageSummariesToUpdate;
            }
        TriggerHandler.clearBypass('UsageSummaryTriggerHandler');
    }
}