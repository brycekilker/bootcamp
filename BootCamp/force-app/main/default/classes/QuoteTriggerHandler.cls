public with sharing class QuoteTriggerHandler {
    //before insert method
    public static void beforeInsertMethod(List<SBQQ__Quote__c> triggeredQuotes ){
        updateWatermark(triggeredQuotes);
    }

    public static void beforeUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes){
        syncAddresses(triggeredQuotes);
    }


    //Helper Methods
    private static void updateWatermark(List<SBQQ__Quote__c> triggeredQuotes){
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        for (SBQQ__Quote__c quote : triggeredQuotes) {
            if(quote.SBQQ__Status__c != 'Approved' || quote.SBQQ__Status__c != 'Accepted') {
                quote.SBQQ__WatermarkShown__c = false;
                quote.SBQQ__BillingCIty__c = 'You did it!';
                quoteList.add(quote);
            }
        }

        System.debug('we are firing baby ' + quoteList);
    }

    private static void syncAddresses(List<SBQQ__Quote__c> triggeredQuotes){
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
    }
}
