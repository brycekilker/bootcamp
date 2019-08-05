public with sharing class QuoteTriggerHandler {
    //before insert method
    public static void beforeInsertMethod(List<SBQQ__Quote__c> triggeredQuotes, Map<Id,SBQQ__Quote__c> oldMap ){
        updateWatermark(triggeredQuotes);
    }
    
    public static void afterUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes, Map<Id, SBQQ__Quote__c> oldMap) {
        syncAddresses(triggeredQuotes, oldMap);
        //updateQuoteLineDiscountField(triggeredQuotes ,oldMap);
    }

    // public static void beforeUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes , Map<Id,SBQQ__Quote__c> oldMap){
    //     checkWatermarkMethod(triggeredQuotes );
    //     calculateAverageDiscountProductFamily(triggeredQuotes ,oldMap);
    // }

    // public static void afterInsertMethod(List<SBQQ__Quote__c> triggeredQuotes , Map<Id,SBQQ__Quote__c> oldMap){
    //     syncOpportunityAddresses(triggeredQuotes ,oldMap);
    // }

    //----------------Helper Methods--------------//
    private static void updateWatermark(List<SBQQ__Quote__c> triggeredQuotes){

        //Checks the watermark Shown field if it is not approved or accepted
        for (SBQQ__Quote__c quote : triggeredQuotes) {
            if(quote.SBQQ__Status__c != 'Approved' || quote.SBQQ__Status__c != 'Accepted') {
                quote.SBQQ__WatermarkShown__c = true;
            } else {
                quote.SBQQ__WatermarkShown__c = false;
            }
        }
        System.debug('we are firing baby, updatedWatermark');
    }

    private static void syncAddresses(List<SBQQ__Quote__c> triggeredQuotes, Map<Id, SBQQ__Quote__c> oldMap){
        //Create List of opps to Update
        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        //Create a check to see if the quote's oppId is not null && its the primary
        for(SBQQ__Quote__c quote: triggeredQuotes) {
            if(quote.SBQQ__Opportunity2__c != null) {
                if(quote.SBQQ__Primary__c) {
                    //Check if anything has changed between the new and old quote
                    if(quote.SBQQ__BillingName__c != oldMap.get(quote.Id).SBQQ__BillingName__c ||
                       quote.SBQQ__BillingCountry__c != oldMap.get(quote.Id).SBQQ__BillingCountry__c ||
                       quote.SBQQ__BillingCity__c != oldMap.get(quote.Id).SBQQ__BillingCity__c ||
                       quote.SBQQ__BillingPostalCode__c != oldMap.get(quote.Id).SBQQ__BillingPostalCode__c ||
                       quote.SBQQ__BillingState__c != oldMap.get(quote.Id).SBQQ__BillingState__c ||
                       quote.SBQQ__BillingStreet__c != oldMap.get(quote.Id).SBQQ__BillingStreet__c ||
                       quote.SBQQ__ShippingName__c != oldMap.get(quote.Id).SBQQ__ShippingName__c ||
                       quote.SBQQ__ShippingCountry__c != oldMap.get(quote.Id).SBQQ__ShippingCountry__c ||
                       quote.SBQQ__ShippingCity__c != oldMap.get(quote.Id).SBQQ__ShippingCity__c ||
                       quote.SBQQ__ShippingPostalCode__c != oldMap.get(quote.Id).SBQQ__ShippingPostalCode__c ||
                       quote.SBQQ__ShippingState__c != oldMap.get(quote.Id).SBQQ__ShippingState__c ||
                       quote.SBQQ__ShippingStreet__c != oldMap.get(quote.Id).SBQQ__ShippingStreet__c 
                    ) {
                        //Create an opportunity and populate it with the info from the primary quote
                        Opportunity opp = new Opportunity(
                            Id = quote.SBQQ__Opportunity2__c,
                            Billing_Street__c = quote.SBQQ__BillingStreet__c,
                            Billing_City__c = quote.SBQQ__BillingCity__c,
                            Billing_State__c = quote.SBQQ__BillingState__c,
                            Billing_Postal_Code__c = quote.SBQQ__BillingPostalCode__c,
                            Billing_Country__c = quote.SBQQ__BillingCountry__c,
                            Shipping_Street__c = quote.SBQQ__ShippingStreet__c,
                            Shipping_City__c = quote.SBQQ__ShippingCity__c,
                            Shipping_State__c = quote.SBQQ__ShippingState__c,
                            Shipping_Postal_Code__c = quote.SBQQ__ShippingPostalCode__c,
                            Shipping_Country__c = quote.SBQQ__ShippingCountry__c
                        );
                        oppsToUpdate.add(opp);
                    }
                }
            }
        }
        update oppsToUpdate;
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
