@isTest 
public with sharing class OpportunityTriggerHandlerTest {

@isTest 
public static void syncOpportunityAddressesTest() {
    //Create test opportunity with data
    Opportunity testOpp = new Opportunity();
    testOpp.StageName = 'Prospecting';
    testOpp.CloseDate = Date.today();
    testOpp.name = 'testOppty';
    testOpp.Billing_City__c = 'Missoula';
    testOpp.Billing_Street__c = 'Penn';
    testOpp.Billing_State__c = 'Montana';
    testOpp.Billing_Postal_Code__c = '55545';
    testOpp.Billing_Country__c = 'USA';
    testOpp.Shipping_Street__c = 'Pencil';
    testOpp.Shipping_City__c = 'Missoula';
    testOpp.Shipping_State__c = 'Montana';
    testOpp.Shipping_Postal_Code__c = '55455';
    testOpp.Shipping_Country__c = 'USA';

    insert testOpp;
    System.debug('inserted test Opp -----> ' + testOpp);

//We are now taking the same opportunity and updating everything to similuate the test
//First we need to query it out.ApexPages
    SBQQ__Quote__c testQuote = new SBQQ__Quote__c();
    testQuote.SBQQ__Opportunity2__c = testOpp.Id;
    testQuote.SBQQ__Primary__c = True;
    testQuote.SBQQ__BillingCountry__c = 'USA';
    testQuote.SBQQ__BillingCity__c = 'Missoula';
    testQuote.SBQQ__BillingPostalCode__c = '55545';
    testQuote.SBQQ__BillingState__c = 'Montana';
    testQuote.SBQQ__BillingStreet__c = 'Penn';
    testQuote.SBQQ__ShippingCountry__c = 'USA';
    testQuote.SBQQ__ShippingCity__c = 'Missoula';
    testQuote.SBQQ__ShippingPostalCode__c = '55455';
    testQuote.SBQQ__ShippingState__c = 'Montana';
    testQuote.SBQQ__ShippingStreet__c = 'Pencil';

    insert testQuote;
    System.debug('this is the test quote ' + testQuote);

//I dont think we need this until the assertion.
    Opportunity newTestOpp = [
        SELECT Id, 
            Name
        FROM Opportunity
        WHERE Id = :testOpp.Id
        LIMIT 1
    ];

    System.debug('We got the updateOppList --------> ' + newTestOpp);

    newTestOpp.Billing_City__c = 'Madison';
    newTestOpp.Billing_Street__c = 'Rhode';
    newTestOpp.Billing_State__c = 'Michigan';
    newTestOpp.Billing_Postal_Code__c = '55546';
    newTestOpp.Billing_Country__c = 'Peru';
    newTestOpp.Shipping_Street__c = 'Rhine';
    newTestOpp.Shipping_City__c = 'Bozeman';
    newTestOpp.Shipping_State__c = 'Missouri';
    newTestOpp.Shipping_Postal_Code__c = '55665';
    newTestOpp.Shipping_Country__c = 'Peru';

    update newTestOpp;
    System.debug('updateOppList results -------------> ' + newTestOpp);

}

}
