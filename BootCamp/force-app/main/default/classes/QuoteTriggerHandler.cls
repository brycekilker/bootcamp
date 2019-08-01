public with sharing class QuoteTriggerHandler {
    //before insert method
    public static void beforeInsertMethod(List<SBQQ__Quote__c> triggeredQuotes ){
        updateWatermark(triggeredQuotes);
    }

    public static void beforeUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes){
        syncAddresses(triggeredQuotes);
        updateDiscount(triggeredQuotes);
    }
    
    public static void afterUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes) {

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


    private static void updateDiscount(List<SBQQ__Quote__c> triggeredQuotes) {
        //it sounds like discount formulas are only accessable via api calls
        /*Planning
            Write a method that will find the average discount for each Product Family, 
            taking into account not only discount % but also the List Total, and populate the values in each of the 3 new fields on the Quote.
            let's think about what needs to happen.
            **THere is an sObject called recalculate formaula fieds, its in chat, it may be useful - sounds like it might not work - each one also counts as a SOQL query
            1. pull all of the discounts in each product family
            2. find the average of those numbers by the percent and list price SUM the discounted amount divided by the total amount discounted by each type. 
                - remember to use the Decimal type declaration devide softwarediscounttotal/ListPriceTotal
            3. 

        
        */
    }

}
