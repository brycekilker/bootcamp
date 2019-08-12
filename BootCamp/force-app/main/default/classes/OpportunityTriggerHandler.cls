public with sharing class OpportunityTriggerHandler {

    public static void afterInsertMethod(List<Opportunity> triggeredOpps,  Map<Id, Opportunity>  oldMap){
        // syncOpportunityAddresses(triggeredOpps, oldMap);
    }

    // public static void afterUpdateMethod(List<Opportunity> triggeredOpps,  Map<Id, Opportunity>  oldMap){
    //     // syncOpportunityAddresses(triggeredOpps, oldMap);
    // }

        public static void afterUpdateMethod(List<Opportunity> triggeredOpps,  Map<Id, Opportunity>  oldMap){
  
      
    }

    public static void updateOpportunities(List<Opportunity> opptyList) {
      Set<Id> opptyIds = new Set<Id>();

        for(Opportunity oppty : opptyList ) {
            opptyIds.add(oppty.id);
        }

          FutureMethodHelper.anotherFutureMethod(opptyIds);
        // syncOpportunityAddresses(triggeredOpps, oldMap);
        futureOpportunities();
    }


//Helper methods
    @Future
    private static void futureOpportunities() {

     


        SYstem.debug('this is my future method');
    }

    ///////////---Helper Methods ------ //////
    // public static void syncOpportunityAddresses(List<Opportunity> triggeredOpps, Map<Id, Opportunity> oldMap){
        //Create List of opps to Update
        // List<SBQQ__Quote__c> quotesToUpdate = new List<SBQQ__Quote__c>();

        // //Create a check to see if the opp's quoteId is not null
        // for(Opportunity opportunity: triggeredOpps) {
        //     if(opportunity.SBQQ__PrimaryQuote__c != null) {
        //         //Check if anything has changed between the new and old opportunity
        //         if(
        //             opportunity.Billing_Street__c != oldMap.get(opportunity.Id).Billing_Street__c ||
        //             opportunity.Billing_City__c != oldMap.get(opportunity.Id).Billing_City__c ||
        //             opportunity.Billing_State__c != oldMap.get(opportunity.Id).Billing_State__c ||
        //             opportunity.Billing_Postal_Code__c != oldMap.get(opportunity.Id).Billing_Postal_Code__c ||
        //             opportunity.Billing_Country__c != oldMap.get(opportunity.Id).Billing_Country__c ||
        //             opportunity.Shipping_Street__c != oldMap.get(opportunity.Id).Shipping_Street__c  ||
        //             opportunity.Shipping_City__c != oldMap.get(opportunity.Id).Shipping_City__c ||
        //             opportunity.Shipping_State__c != oldMap.get(opportunity.Id).Shipping_State__c ||
        //             opportunity.Shipping_Postal_Code__c != oldMap.get(opportunity.Id).Shipping_Postal_Code__c ||
        //             opportunity.Shipping_Country__c != oldMap.get(opportunity.Id).Shipping_Country__c
        //         ) {
        //             //update quote field with the opportunity's info
        //             SBQQ__Quote__c quote = new SBQQ__Quote__c (
        //                 Id = opportunity.SBQQ__PrimaryQuote__c, 
        //                 SBQQ__ShippingCountry__c = opportunity.Shipping_Country__c,
        //                 SBQQ__ShippingCity__c = opportunity.Shipping_City__c,       
        //                 SBQQ__ShippingPostalCode__c = opportunity.Shipping_Postal_Code__c,
        //                 SBQQ__ShippingState__c = opportunity.Shipping_Postal_Code__c,
        //                 SBQQ__ShippingStreet__c = opportunity.Shipping_Postal_Code__c,
        //                 SBQQ__BillingCity__c = opportunity.Billing_City__c,
        //                 SBQQ__BillingCountry__c = opportunity.Billing_Country__c,
        //                 SBQQ__BillingPostalCode__c  = opportunity.Billing_Postal_Code__c,
        //                 SBQQ__BillingState__c = opportunity.Billing_State__c,
        //                 SBQQ__BillingStreet__c = opportunity.Billing_Street__c
        //             );
        //             quotesToUpdate.add(quote);
        //             }
        //         }
        //         update quotesToUpdate;
        //     }
        // }
    }