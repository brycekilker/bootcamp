public with sharing class QuoteTriggerHandler {
    //before insert method
    public static void beforeInsertMethod(List<SBQQ__Quote__c> triggeredQuotes, Map<Id,SBQQ__Quote__c> oldMap ){
        updateWatermark(triggeredQuotes);
    }
    
    public static void afterUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes, Map<Id, SBQQ__Quote__c> oldMap) {
        syncAddresses(triggeredQuotes, oldMap);
        updateDiscountForProductFamily(triggeredQuotes, oldMap);
    }

    // public static void beforeUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes , Map<Id,SBQQ__Quote__c> oldMap){
    //     // updateDiscount(triggeredQuotes, oldMap);
    // }

     public static void beforeUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes){
        updateWatermark(triggeredQuotes);
    }

    public static void afterInsertMethod(List<SBQQ__Quote__c> triggeredQuotes , Map<Id,SBQQ__Quote__c> oldMap){
        syncAddresses(triggeredQuotes, oldMap);
    }

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


   private static void updateDiscountForProductFamily(List<SBQQ__Quote__c> triggeredQuotes, Map<Id, SBQQ__Quote__c> oldMap) {
       //create Id's for Map
        Set<Id> quoteIdSet = new Set<Id>();
        //Loop through triggered quotes and see if they match the old info
        for (SBQQ__Quote__c quote : triggeredQuotes) {
    
            SBQQ__Quote__c priorQuote = oldMap.get(quote.Id);
            if (quote.Hardware_Discount__c == priorQuote.Hardware_Discount__c && 
            quote.Software_Discount__c == priorQuote.Software_Discount__c && 
            quote.Support_Discount__c == priorQuote.Support_Discount__c) {
                quoteIdSet.add(quote.Id);
            }
        }
       //Do a check to see if the quoteSet is 0 and stop the method
        if (quoteIdSet.size() == 0) {
            return;
        }

        //Create a map that has a string as the key and a list of Decimal as the value
        Map<String, List<Decimal>> discounts = new Map<String, List<Decimal>>();
        discounts.put('Hardware', new List<Decimal>{0.0, 0.0});
        discounts.put('Software', new List<Decimal>{0.0, 0.0});
        discounts.put('Support',  new List<Decimal>{0.0, 0.0});

        //Make a list from the quote lines that line up with the quoteIdSet
        List<SBQQ__QuoteLine__c> quoteLines = [
            SELECT SBQQ__Discount__c, SBQQ__ListTotal__c, SBQQ__ProductFamily__c
            FROM SBQQ__QuoteLine__c 
            WHERE SBQQ__Quote__c 
            IN :quoteIdSet
        ];
        
        //Loop through quoteLines list, if the discount field is blank, put a 0
        for (SBQQ__QuoteLine__c quoteLine : quoteLines) {
            if (quoteLine.SBQQ__Discount__c == null) {
                quoteLine.SBQQ__Discount__c = 0;
            }
            //First list value adds the discount
            discounts.get(quoteLine.SBQQ__ProductFamily__c)[0] += quoteLine.SBQQ__Discount__c;
            //Second list value is incremented for each product to find the number of discounted products
            discounts.get(quoteLine.SBQQ__ProductFamily__c)[1] ++;
        }
        //populates the list items into Decimal values
        Decimal hardwareCount = discounts.get('Hardware')[1];
        Decimal softwareCount = discounts.get('Software')[1];
        Decimal supportCount = discounts.get('Support')[1];
        Decimal hardwareDiscount = discounts.get('Hardware')[0];
        Decimal softwareDiscount = discounts.get('Software')[0];
        Decimal supportDiscount = discounts.get('Support')[0];

        //Finds the average if the count does not equal 0
        if (hardwareCount != 0) {
            hardwareDiscount /= hardwareCount;
        }
        if (softwareCount != 0) {
            softwareDiscount /= softwareCount;
        }
        if (supportCount != 0) {
            supportDiscount /= supportCount;
        }

        // update the quote discount fields with the result 
        for (SBQQ__Quote__c quote : triggeredQuotes) {
            if (quote.Hardware_Discount__c == oldMap.get(quote.Id).Hardware_Discount__c) {
                quote.Hardware_Discount__c = hardwareDiscount;
            }
            if (quote.Software_Discount__c == oldMap.get(quote.Id).Software_Discount__c) {
                quote.Software_Discount__c = softwareDiscount;
            }
            if (quote.Support_Discount__c == oldMap.get(quote.Id).Support_Discount__c) {
                quote.Support_Discount__c  = supportDiscount;
            } 
        }
    }

}
