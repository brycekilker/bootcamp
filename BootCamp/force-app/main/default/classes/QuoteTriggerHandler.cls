public with sharing class QuoteTriggerHandler {
    //before insert method
    public static void beforeInsertMethod(List<SBQQ__Quote__c> triggeredQuotes, Map<Id,SBQQ__Quote__c> oldMap ){
        updateWatermark(triggeredQuotes);
    }
    
    public static void afterUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes, Map<Id, SBQQ__Quote__c> oldMap) {
        syncAddresses(triggeredQuotes, oldMap);
    }

    public static void beforeUpdateMethod(List<SBQQ__Quote__c> triggeredQuotes , Map<Id,SBQQ__Quote__c> oldMap){
        updateDiscountForProductFamily(triggeredQuotes, oldMap);
        // manualUpdateOfDiscounts(triggeredQuotes, oldMap);
    }

    // public static void afterInsertMethod(List<SBQQ__Quote__c> triggeredQuotes , Map<Id,SBQQ__Quote__c> oldMap){
    //     syncAddresses(triggeredQuotes, oldMap);
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
            System.debug('we are firing baby ' + quote);
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
                    if(
                       quote.SBQQ__BillingCountry__c != oldMap.get(quote.Id).SBQQ__BillingCountry__c ||
                       quote.SBQQ__BillingCity__c != oldMap.get(quote.Id).SBQQ__BillingCity__c ||
                       quote.SBQQ__BillingPostalCode__c != oldMap.get(quote.Id).SBQQ__BillingPostalCode__c ||
                       quote.SBQQ__BillingState__c != oldMap.get(quote.Id).SBQQ__BillingState__c ||
                       quote.SBQQ__BillingStreet__c != oldMap.get(quote.Id).SBQQ__BillingStreet__c ||
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
                System.debug('this is quote.Software_Discount -------------> ' + quote.Software_Discount__c);
                System.debug('this is the old software Discount =------> ' + priorQuote.Software_Discount__c);
            }
        }
       //Do a check to see if the quoteSet is 0 and stop the method
        if (quoteIdSet.size() == 0) {
            return;
        }

        //Create a map that has a string as the key and a list of Decimal as the value
        Map<String, List<Decimal>> discountAmount = new Map<String, List<Decimal>>();
        discountAmount.put('Hardware', new List<Decimal>{0.0, 0.0});
        discountAmount.put('Software', new List<Decimal>{0.0, 0.0});
        discountAmount.put('Support',  new List<Decimal>{0.0, 0.0});

        System.debug('this is discountAmount -----> ' + discountAmount);

        //Make a list from the quote lines that line up with the quoteIdSet
        List<SBQQ__QuoteLine__c> quoteLinesToUpdate = [
            SELECT SBQQ__Discount__c, SBQQ__ListTotal__c, SBQQ__ProductFamily__c
            FROM SBQQ__QuoteLine__c 
            WHERE SBQQ__Quote__c 
            IN :quoteIdSet
        ];

        System.debug('this is quoteLinesToUpdate -----> ' + quoteLinesToUpdate);
        
        //Loop through quoteLinesToUpdate list, if the discount field is blank, put a 0
        for (SBQQ__QuoteLine__c quoteLine : quoteLinesToUpdate) {
            if (quoteLine.SBQQ__Discount__c == null) {
                quoteLine.SBQQ__Discount__c = 0;
            }
            //First list value adds the discount
            discountAmount.get(quoteLine.SBQQ__ProductFamily__c)[0] += quoteLine.SBQQ__Discount__c;
            //Second list value is incremented for each product to find the number of discounted products
            discountAmount.get(quoteLine.SBQQ__ProductFamily__c)[1] ++;
        }
        //populates the list items into Decimal values
        //Discount
        Decimal hardwareDiscount = discountAmount.get('Hardware')[0];
        Decimal softwareDiscount = discountAmount.get('Software')[0];
        Decimal supportDiscount = discountAmount.get('Support')[0];
        //# for the average
        Decimal hardwareCount = discountAmount.get('Hardware')[1];
        Decimal softwareCount = discountAmount.get('Software')[1];
        Decimal supportCount = discountAmount.get('Support')[1];

        //Finds the average if the count does not equal 0
        if (hardwareCount != 0) {
            hardwareDiscount = hardwareDiscount / hardwareCount;
        }
        if (softwareCount != 0) {
            softwareDiscount =  softwareDiscount / softwareCount;
        }
        if (supportCount != 0) {
            supportDiscount = supportDiscount / supportCount;
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

    // public static void manualUpdateOfDiscounts(List<SBQQ__Quote__c> triggeredQuotes, Map<Id, SBQQ__Quote__c> oldMap) {
    //      //create Id's for Map
    //     Set<Id> quoteIdSet = new Set<Id>();
        
    //     for(SBQQ__Quote__c quote : triggeredQuotes) {
    //         SBQQ__Quote__c priorQuote = oldMap.get(quote.Id);

    //             //See if there are manual changes, we want to update the quote line values
    //           if (quote.Hardware_Discount__c != priorQuote.Hardware_Discount__c  ||
    //             quote.Software_Discount__c != priorQuote.Software_Discount__c || 
    //             quote.Support_Discount__c != priorQuote.Support_Discount__c) {
    //             quoteIdSet.add(quote.Id);
    //             System.debug('this is the second hit from manual discount -------------> ' + quoteIdSet);
    //         }
    //     }
    //    //Do a check to see if the quoteSet is 0 and stop the method
    //     if (quoteIdSet.size() == 0) {
    //         return;
    //     }

    //     //Now I need to find the quote lines to update.
    //     List<SBQQ__Quote__c> quotes = [
    //         SELECT Id, Hardware_Discount__c, Software_Discount__c, Support_Discount__c
    //         FROM SBQQ__Quote__c
    //         WHERE Id IN : quoteIdSet
    //     ];

    //     System.debug('these are quotes we grabbed --------> ' + quotes);

    // }

}
