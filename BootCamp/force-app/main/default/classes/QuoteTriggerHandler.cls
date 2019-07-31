public with sharing class QuoteTriggerHandler {
    //before insert method
    public static void beforeInsertMethod(List<SBQQ__Quote__c> triggeredQuotes ){
        updateWatermark(triggeredQuotes);
    }

    public static void beforeUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes){
        updateWatermark(triggeredQuotes);
        syncAddresses(triggeredQuotes);
    }


    //Helper Methods
    private static void updateWatermark(List<SBQQ__Quote__c> triggeredQuotes){
        for (SBQQ__Quote__c quote : triggeredQuotes) {
            if(quote.SBQQ__Status__c != 'Approved' || quote.SBQQ__Status__c != 'Accepted') {
                quote.SBQQ__WatermarkShown__c = true;
            } else {
                quote.SBQQ__WatermarkShown__c = false;
            }
            System.debug('we are firing baby ' + quote);
        }
    }

    //This looks at the quote to check if its primary it will update the opporunity
    private static void syncAddresses(List<SBQQ__Quote__c> triggeredQuotes){
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
    }
}
