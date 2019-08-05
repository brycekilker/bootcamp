public with sharing class OpportunityTriggerHandler {

    public static void afterInsertMethod(List<Opportunity> triggeredOpps,  Map<Id, Opportunity>  oldMap){
        syncOpportunityAddresses(triggeredOpps, oldMap);
    }

    public static void afterUpdateMethod(List<Opportunity> triggeredOpps,  Map<Id, Opportunity>  oldMap){
        syncOpportunityAddresses(triggeredOpps, oldMap);
    }

    ///////////---Helper Methods ------ //////
    public static void syncOpportunityAddresses(List<Opportunity> triggeredOpps, Map<Id, Opportunity> oldMap){
        //Create List of opps to Update
        List<SBQQ__Quote__c> quotesToUpdate = new List<SBQQ__Quote__c>();

        //Create a check to see if the opp's quoteId is not null
        for(Opportunity opportunity: triggeredOpps) {
            if(opportunity.SBQQ__PrimaryQuote__c != null) {
                //Check if anything has changed between the new and old opportunity
                if(
                    opportunity.Billing_Street__c != oldMap.get(opportunity.Id).Billing_Street__c ||
                    opportunity.Billing_City__c != oldMap.get(opportunity.Id).Billing_City__c ||
                    opportunity.Billing_State__c != oldMap.get(opportunity.Id).Billing_State__c ||
                    opportunity.Billing_Postal_Code__c != oldMap.get(opportunity.Id).Billing_Postal_Code__c ||
                    opportunity.Billing_Country__c != oldMap.get(opportunity.Id).Billing_Country__c ||
                    opportunity.Shipping_Street__c != oldMap.get(opportunity.Id).Shipping_Street__c  ||
                    opportunity.Shipping_City__c != oldMap.get(opportunity.Id).Shipping_City__c ||
                    opportunity.Shipping_State__c != oldMap.get(opportunity.Id).Shipping_State__c ||
                    opportunity.Shipping_Postal_Code__c != oldMap.get(opportunity.Id).Shipping_Postal_Code__c ||
                    opportunity.Shipping_Country__c != oldMap.get(opportunity.Id).Shipping_Country__c
                ) {
                    //update quote field with the opportunity's info
                    SBQQ__Quote__c quote = new SBQQ__Quote__c (
                            Id = opportunity.SBQQ__PrimaryQuote__c, 
                            SBQQ__ShippingCountry__c = opportunity.Shipping_Country__c,
                            SBQQ__ShippingCity__c = opportunity.Shipping_City__c,       
                            SBQQ__ShippingPostalCode__c = opportunity.Shipping_Postal_Code__c,
                            SBQQ__ShippingState__c = opportunity.Shipping_Postal_Code__c,
                            SBQQ__ShippingStreet__c = opportunity.Shipping_Postal_Code__c,
                            SBQQ__BillingCity__c = opportunity.Billing_City__c,
                            SBQQ__BillingCountry__c = opportunity.Billing_Country__c,
                            SBQQ__BillingPostalCode__c  = opportunity.Billing_Postal_Code__c,
                            SBQQ__BillingState__c = opportunity.Billing_State__c,
                            SBQQ__BillingStreet__c = opportunity.Billing_Street__c
                    );
                    quotesToUpdate.add(quote);
                    }
                }
                update quotesToUpdate;
            }
        }
    }

///Helper Methods
    //This method needs to look at related quotes and update the address fields
    // I think we are going to have to map through the opportunities to get the quotes because they are too deep
    //We will have to query those out similar to what we did in exercise 1.
    //***I dont think these values im inputting make sense anymore I need to clean this up. */
    // private static void updateQuotes(Map<Id,SBQQ__Quote__c> newMap, Map<Id, SBQQ__Quote__c> oldMap) {

    //     //something here is wrong with how I am accessing the primary quote info.
    //     List<Opportunity> oppList = new List<Opportunity>();

    //     for(SBQQ__Quote__c quote : newMap.values()) {
    //         if(quote.SBQQ__Primary__c = true) {
    //             primaryIds.add(quote.id);
    //             if(quote.Bill_To_Address__c != oldMap.get(quote.Id).Bill_To_Address__c || quote.Bill_To_Address__c != oldMap.get(quote.Id).Bill_To_Address__c ) {
    //                 Opportunity opp = new Opportunity(
    //                     Ship_To_address__c = newMap.get(opp.SBQQ__PrimaryQuote__c).Ship_To_Address__c,
    //                     Bill_To_address__c = newMap.get(opp.SBQQ__PrimaryQuote__c).Bill_To_Address__c
    //                 );
    //                 oppList.add(opp);
    //             }
    //         if(oppList.size != null) {
    //             update oppList;
    //             }
    //         }
    //     }

        // Set<Id> primaryIds = new Set<id>();

        // List<Opportunity> primaryQuotes = [
        //     SELECT Ship_To_Address__c, Bill_To_Address__c
        //     FROM Opportunity
        //     WHERE SBQQ__PrimaryQuote__c in :primaryIds
        // ];

        // List<Opportunity> opportunityIds = new List<Opportunity>();

        // for(SBQQ__Quote__c qote: newMap.values()){
        //     if(newMap.get(quote.Id).Bill_To_Address__c != oldMap.get(quote.Id).Bill_To_Adress__c ||
        //         newMap.get(quote.Id).Ship_To_Address__c != oldMap.get(quote.Id).Ship_To_Adress__c ){
           
        //         }
        //     } 
        //     //This is where I need to update the opportunity addresses   

        //     }

