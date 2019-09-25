/**
 * Salesforce CPQ Test Utilities (without Billing)
 * This code is provided without warranty and must be used within the guidelines
 * of any signed agreement
 *
 * Assumptions: 
 * Salesforce CPQ is installed, Salesforce Billing is not installed. 
 *
 * This is the helper test utility class to aid CPQ_TestsA in creating, testing, and validating data.
 *   
 * If the org eventually gets Salesforce Billing installed within it, decomment lines with #SFBILLING at the end of them,
 * or install the SFCPQ AND Billing test class accelerator.
 * 
 * @author Kevin Antonioli kevin.antonioli@atginfo.com (with )
 * @updated 02.09.2019 by Kevin Antonioli kevin.antonioli@atginfo.com
 *
 */
@IsTest
public without sharing class CPQ_TestUtilsA {

    /** Create product **/
    public static Product2 createProduct(String name, String productType, String productCode, Id billingRuleId, Id taxRuleId, Id revRecRuleId, Boolean populateDefaultValues, Boolean doInsert) {
        Product2 obj = (Product2)Product2.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            true // loadDefaultValues
        );
        obj.Name = name;
        obj.isActive = true;
        obj.ProductCode = productCode;
        obj.SBQQ__QuantityEditable__c = true;
        obj.SBQQ__DefaultQuantity__c = 1.0;
        obj.SBQQ__AssetConversion__c = 'One per quote line';
        obj.SBQQ__SubscriptionCategory__c = 'Bundle';
       

        if(productType == 'Subscription') {
            obj.SBQQ__SubscriptionTerm__c = 12;
            obj.SBQQ__SubscriptionType__c = 'Renewable';
            obj.SBQQ__SubscriptionPricing__c = 'Fixed Price';
            obj.SBQQ__PricingMethod__c = 'List';
            obj.SBQQ__SubscriptionBase__c = 'Regular';
        } else if(productType == 'Non-Subscription') {
        	obj.SBQQ__SubscriptionBase__c = 'List';
        }

        // Required to Order a quote when Billing is installed:
        obj.SBQQ__ChargeType__c = 'Recurring';
        obj.SBQQ__BillingType__c = 'Advance';
        obj.SBQQ__BillingFrequency__c = 'Monthly';
        //obj.blng__BillingRule__c = billingRuleId == null ? null : billingRuleId; //#SFBILLING
        //obj.blng__TaxRule__c = taxRuleId == null ? null : taxRuleId; //#SFBILLING
        //obj.blng__RevenueRecognitionRule__c = revRecRuleId == null ? null : revRecRuleId; //#SFBILLING

        if(doInsert) {
            insert obj;
        }

        return obj;
    }

        /** Create overload with annual value product **/
    public static Product2 createProduct(String name, String productType, String productCode, 
    Id billingRuleId, Id taxRuleId, Id revRecRuleId, Boolean populateDefaultValues, Boolean doInsert,
    String usageFrequency, Integer usageOverageRate, Integer usageOverageThreshold, String usageType) {
        Product2 obj = (Product2)Product2.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            true // loadDefaultValues
        );
        obj.Name = name;
        obj.isActive = true;
        obj.ProductCode = productCode;
        obj.SBQQ__QuantityEditable__c = true;
        obj.SBQQ__DefaultQuantity__c = 1.0;
        obj.SBQQ__AssetConversion__c = 'One per quote line';
        obj.SBQQ__SubscriptionCategory__c = 'Bundle';
        obj.Usage_Overage_Threshold__c = usageOverageThreshold;
        obj.Usage_Overage_Rate__c = usageOverageRate;
        obj.Usage_Type__c = usageType;
        obj.Usage_Frequency__c = usageFrequency;
        obj.Usage_Minimum_Commit__c = 10;
        obj.Base_Usage_Rate__c = 1;
       

        if(productType == 'Subscription') {
            obj.SBQQ__SubscriptionTerm__c = 12;
            obj.SBQQ__SubscriptionType__c = 'Renewable';
            obj.SBQQ__SubscriptionPricing__c = 'Fixed Price';
            obj.SBQQ__PricingMethod__c = 'List';
            obj.SBQQ__SubscriptionBase__c = 'Regular';
        } else if(productType == 'Non-Subscription') {
        	obj.SBQQ__SubscriptionBase__c = 'List';
        }

        // Required to Order a quote when Billing is installed:
        obj.SBQQ__ChargeType__c = 'Recurring';
        obj.SBQQ__BillingType__c = 'Advance';
        obj.SBQQ__BillingFrequency__c = 'Monthly';
        //obj.blng__BillingRule__c = billingRuleId == null ? null : billingRuleId; //#SFBILLING
        //obj.blng__TaxRule__c = taxRuleId == null ? null : taxRuleId; //#SFBILLING
        //obj.blng__RevenueRecognitionRule__c = revRecRuleId == null ? null : revRecRuleId; //#SFBILLING

        if(doInsert) {
            insert obj;
        }

        return obj;
    }
    
    /** Create pricebook **/
    public static PriceBook2 createPriceBook(String name, Boolean isActive, String currencyIsoCode, Boolean populateDefaultValues, Boolean doInsert){
        PriceBook2 obj = (PriceBook2)PriceBook2.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            true // loadDefaultValues
        );
        obj.Name = name;
        obj.IsActive = isActive;

        // Note: decomment if multicurrency is enabled:
        //obj.CurrencyIsoCode = currencyIsoCode;

        if(doInsert) {
            insert obj;
        }
        return obj;
    }

    /** Create pricebook entry **/
    public static PricebookEntry createPriceBookEntry(Product2 product, Pricebook2 priceBook, Boolean populateDefaultValues, Boolean doInsert) {
        PricebookEntry obj = (PricebookEntry)PricebookEntry.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            populateDefaultValues // loadDefaultValues
        );
        obj.UnitPrice = 100;
        obj.Pricebook2Id = priceBook == null ? Test.getStandardPricebookId() : priceBook.Id;
        obj.Product2Id = product.Id;
        obj.UnitPrice = 1;
        obj.isActive = true;

        if(doInsert) {
            insert obj;
        }
        return obj;
    }

    /** Create quote **/
    public static SBQQ__Quote__c createQuote(Account acct, Opportunity opp, Boolean isPrimary, Boolean populateDefaultValues, Boolean doInsert) {
        SBQQ__Quote__c obj = (SBQQ__Quote__c)SBQQ__Quote__c.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            true // loadDefaultValues
        );
        obj.SBQQ__Primary__c = isPrimary;
        obj.SBQQ__StartDate__c = Date.today().addYears(-1);
        obj.SBQQ__EndDate__c = Date.today();
        obj.SBQQ__Opportunity2__c = opp == null ? null : opp.Id;
        obj.SBQQ__SubscriptionTerm__c = 12;
        obj.SBQQ__ExpirationDate__c = Date.today() + 30;
        obj.SBQQ__Account__c = acct == null ? null : acct.Id;
        obj.SBQQ__Type__c = 'Quote';

        if(doInsert) {
            insert obj;
        }
        return obj;
    }

    /** Create quote line **/
    public static SBQQ__QuoteLine__c createQuoteLine(Product2 product, PriceBookEntry pbe, SBQQ__Quote__c quote, Boolean populateDefaultValues, Boolean doInsert, Boolean optional) {
        SBQQ__QuoteLine__c obj = (SBQQ__QuoteLine__c)SBQQ__QuoteLine__c.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            populateDefaultValues // loadDefaultValues
        );
        obj.SBQQ__Product__c = product.Id;
        obj.SBQQ__Quote__c = quote.Id;
        obj.SBQQ__PricebookEntryId__c = pbe == null ? null : pbe.Id;
        obj.SBQQ__PricingMethod__c = 'List';
        obj.SBQQ__ListPrice__c = 100;
        obj.SBQQ__Quantity__c = 1;
        obj.SBQQ__PriorQuantity__c = 0;
        obj.SBQQ__RegularPrice__c = 100;
        obj.SBQQ__NetPrice__c = 100;
        obj.SBQQ__Number__c = 1;
        obj.SBQQ__ProrateMultiplier__c = 1;
        obj.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        obj.SBQQ__SubscriptionScope__c = 'Quote';
        obj.SBQQ__DefaultSubscriptionTerm__c = 1;
        obj.SBQQ__ChargeType__c = product.SBQQ__ChargeType__c;
        obj.SBQQ__BillingType__c = product.SBQQ__BillingType__c;
        obj.SBQQ__BillingFrequency__c = product.SBQQ__BillingFrequency__c;
        obj.SBQQ__Optional__c = optional;
        obj.Base_Usage_Rate__c = 1;
        obj.Usage_Minimum_Commit__c = 10;

        if(doInsert) {
            insert obj;
        }
        return obj;
    }

    /** Create Asset */
    public static Asset createAsset(Account acct, Product2 product, SBQQ__QuoteLine__c quoteLine, Boolean populateDefaultValues, Boolean doInsert) {
        Asset obj = (Asset)Asset.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            populateDefaultValues // loadDefaultValues
        );
        obj.Name = 'Test Asset';
        obj.AccountId = acct.Id;
        obj.Product2Id = product.Id;
        // Decomment if multicurrency is enabled:
        //obj.CurrencyIsoCode = 'USD';
        obj.Status = 'Registered';
        obj.PurchaseDate = System.Today();
        obj.SBQQ__QuoteLine__c = quoteLine == null ? null : quoteLine.Id;
        obj.SerialNumber = '1234567890';
      
        if(doInsert) {
            insert obj;
        }
        return obj;
    }

     public static Contract createContract(Account acct, Id pricebookId, Opportunity opp, Order order, SBQQ__Quote__c quote, Boolean doInsert) {
        Contract obj = (Contract)Contract.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            true // loadDefaultValues
        );
        obj.AccountId = acct.Id;
        obj.ContractTerm = 12;
        obj.SBQQ__Quote__c = quote == null ? null : quote.Id;
        obj.SBQQ__Opportunity__c = opp == null ? null : opp.Id;
        obj.SBQQ__Order__c = order == null ? null : order.Id;
        obj.SBQQ__RenewalTerm__c = 12;
        obj.StartDate = System.Today();

        if(doInsert) {
            insert obj;
        }
        return obj;
    }

    /** Create Subscription **/
    public static SBQQ__Subscription__c createSubscription(Account acct, Contract con, SBQQ__QuoteLine__c quoteLine, Boolean populateDefaultValues, Boolean doInsert) {
        SBQQ__Subscription__c obj = (SBQQ__Subscription__c)SBQQ__Subscription__c.sObjectType.newSObject(
            null, // null will make it the default record type for the user
            true // loadDefaultValues
        );
        obj.SBQQ__Account__c = acct.Id;
        obj.SBQQ__Contract__c = con.Id;
        obj.SBQQ__QuoteLine__c = quoteLine.Id;
        obj.SBQQ__OriginalQuoteLine__c = quoteLine.Id;
        obj.SBQQ__Quantity__c = 1.00;
        obj.SBQQ__RenewalQuantity__c = 1.00;
        obj.SBQQ__Product__c = quoteLine.SBQQ__Product__c;
        obj.SBQQ__Number__c = 1;
        obj.SBQQ__ProrateMultiplier__c = 1.0000;

        if(doInsert) {
            insert obj;
        }
        return obj;
    }

    /************************************/
    /***** ORDER automation RELATED *****/
    /************************************/

    /** Create Order from Quote **/
    public static Order createAutomatedOrderFromQuote(Id quoteId) {
        SBQQ__Quote__c q = new SBQQ__Quote__c(Id = quoteId, SBQQ__Ordered__c= true);
        update q;

        /** Query order from quote id */
        List<Order> orderList = queryRecordsFromIdsAndObjectName(
             new Set<Id>{quoteId},              // Set<Id> idSet (to bind to in where clause)
            'Order',                            // String objectName
            'WHERE SBQQ__Quote__c IN :idSet'    // String whereClause
        );
        return orderList[0];
    }

    /** Create Order from Opportunity **/
    public static Order createAutomatedOrderFromOpportunity(Id oppId) {
        Opportunity obj = new Opportunity(Id = oppId, SBQQ__Ordered__c= true);
        update obj;

        /** Query order from opp id */
        List<Order> orderList = queryRecordsFromIdsAndObjectName(
             new Set<Id>{oppId},                // Set<Id> idSet (to bind to in where clause)
            'Order',                            // String objectName
            'WHERE OpportunityId IN :idSet'     // String whereClause
        );   
        return orderList[0];
    }

    /**
     * Activate order - status and status code are both updated
     * This should update all lines as well. Order lines are queried and returned
     */
    public static List<OrderItem> activateOrder(Order order) {
        order.Status = 'Activated';
        order.StatusCode = 'Activated';

        // order.blng__BillingDayOfMonth__c = '1'; //#SFBILLING

        // Update Order:
        update order;
        
        /** Query order items by order id */
        return queryRecordsFromIdsAndObjectName(
             new Set<Id>{order.Id},     // Set<Id> idSet (to bind to in where clause)
            'OrderItem',                // String objectName
            'WHERE OrderId IN :idSet'   // String whereClause
        );                                   
    }

    /** Contract an Order **/
    public static List<Contract> contractOrder(Order order, Boolean startTests, Boolean stopTests) {
        // Update status and status code
        order.SBQQ__Contracted__c = true;

        if(startTests) { Test.startTest(); }
        // Update Order:
        update order;
        if(stopTests) { Test.stopTest(); }

        /** Query contract with lines (subscriptions) by order **/
        return queryRecordsAndChildrenFromIdsAndObjectNames(
            new Set<Id>{order.Id},              // Set<Id> idSet (to bind to in where clause)
            'Contract',                         // String parentObjName
            'SBQQ__Subscription__c',            // String childObjName
            'SBQQ__Subscriptions__r',           // String childObjRelationshipName
            'WHERE SBQQ__Order__c IN :idSet'    // String whereClause
        );
    }

    /** Contract an Opportunity **/
    public static List<Contract> contractOpportunity(Opportunity opp, Boolean startTests, Boolean stopTests) {
        opp.SBQQ__Contracted__c = true;

        if(startTests) { Test.startTest(); }
        // Update Opportunity:
        update opp;
        if(stopTests) { Test.stopTest(); }

        /** Query contract with lines (subscriptions) by Opportunity **/
        return queryRecordsAndChildrenFromIdsAndObjectNames(
            new Set<Id>{opp.Id},                    // Set<Id> idSet (to bind to in where clause)
            'Contract',                             // String parentObjName
            'SBQQ__Subscription__c',                // String childObjName
            'SBQQ__Subscriptions__r',               // String childObjRelationshipName
            'WHERE SBQQ__Opportunity__c IN :idSet'  // String whereClause
        );
 
    }

    public static Integer queryCount = 0;
    public static void printQueries(String message) {
        System.debug(Logginglevel.ERROR, message + ' used ' + (Limits.getQueries() - queryCount) + ' queries. The total queries used is ' + Limits.getQueries() + ' CPU TIME: ' + Limits.getCpuTime() + ' ' + Limits.getLimitCpuTime());
        queryCount = Limits.getQueries();
    }

    /**
     * ********************** Query Helpers ********************
     */

    /** Query sobject without subquery */
    public static List<sObject> queryRecordsFromIdsAndObjectName(Set<Id> idSet, String objectName, String whereClause) {
       return (queryRecordsFromIdsAndObjectName(idSet, objectName, null, whereClause));
    }
    public static List<sObject> queryRecordsFromIdsAndObjectName(Set<Id> idSet, String objectName, String additionalReferences, String whereClause) {
        String additionalRef = additionalReferences == null ? '' : additionalReferences;
        String soql = 'SELECT ' + getAllFieldsForSObjAsStr(objectName) + ' ' + additionalRef + ' FROM ' + objectName + ' ' + whereClause;
        return Database.query(soql);
    }
    
    /** Query sobject with subquery */
    public static List<sObject> queryRecordsAndChildrenFromIdsAndObjectNames(Set<Id> idSet, String parentObjName, String childObjName, String childObjRelationshipName, String whereClause) {
        String soql = 'SELECT ' + getAllFieldsForSObjAsStr(parentObjName) + ', (SELECT ' + getAllFieldsForSObjAsStr(childObjName) + ' FROM ' + childObjRelationshipName + ') FROM ' + parentObjName + ' ' + whereClause;
        return Database.query(soql);
    }

    /** Get all fields for an sobject as a list - helpful for dynamic SOQL */
    public static List<String> getAllFieldsForSobj(String sobjectName) {
       List<String> allFields = new List<String>(Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().keySet());
       return allFields;
    }

    /** Get comma delimited string list of all sobject fields */
    public static String getAllFieldsForSObjAsStr(String sobjectName) {
       return String.join(getAllFieldsForSobj(sobjectName), ', ');
    }

    /** Create subscription product */
    public static Product2 createProduct(Id billingRuleId, Id taxRuleId, Id revRecRuleId, Boolean doInsert) {
        Product2 obj = new Product2();
        obj.Name = 'Test Product' + Math.roundToLong(Math.random()*10000000);
        obj.IsActive = true;
        obj.ProductCode = 'CL01';
        obj.Description = 'Product of Clip Licensing';
        obj.Family = 'Analytics';
        obj.ProductCode = 'TestProduct';
        obj.SBQQ__OptionSelectionMethod__c = 'Click';
        obj.SBQQ__ConfigurationType__c = null;
        obj.SBQQ__QuantityEditable__c = true;
        obj.SBQQ__SubscriptionBase__c = 'List';
        obj.SBQQ__Taxable__c = false;
        obj.SBQQ__BlockPricingField__c = 'Quantity';
        obj.SBQQ__Component__c = false;
        obj.SBQQ__DefaultQuantity__c = 1;
        obj.SBQQ__ExcludeFromOpportunity__c = false;
        obj.SBQQ__PriceEditable__c = true;
        obj.SBQQ__PricingMethod__c = 'List';
        obj.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        obj.SBQQ__SubscriptionType__c = 'Renewable';
        obj.SBQQ__SubscriptionTerm__c = 12;
        obj.SBQQ__ChargeType__c = 'Recurring';
        obj.SBQQ__BillingType__c = 'Advance';
        obj.SBQQ__BillingFrequency__c = 'Monthly';
        //obj.blng__BillingRule__c = billingRuleId == null ? null : billingRuleId; //#SFBILLING
        //obj.blng__TaxRule__c = taxRuleId == null ? null : taxRuleId; //#SFBILLING
        //obj.blng__RevenueRecognitionRule__c = revRecRuleId == null ? null : revRecRuleId; //#SFBILLING
        system.debug(obj);
        if (doInsert) { insert obj; }
        system.debug(obj);
        return obj;
    }

    //public static Product2 createSubscriptionProduct(String productName, String productCode, Boolean doInsert) {
    //    Product2 obj = new Product2();
    //    // decomment for multi currency orgs:
    //    //obj.CurrencyIsoCode = 'USD';
    //    obj.Family = 'Family 123';
    //    obj.IsActive = true;
    //    obj.Name = productName;
    //    obj.ProductCode = productCode; 
    //    obj.SBQQ__AssetConversion__c='One per quote line';
    //    obj.SBQQ__PricingMethod__c='List';
    //    obj.SBQQ__SubscriptionBase__c='List';
    //    obj.SBQQ__SubscriptionPricing__c='Fixed Price';
    //    obj.SBQQ__SubscriptionType__c='Renewable';

    //    if (doInsert) {
    //        insert obj;
    //    }
    //    return obj;
    //}

    /** Create Contract */
    public static Contract createContract(Account a, Boolean doInsert) {
        return createContract(a, null, doInsert);
    }
    public static Contract createContract(Account a, Opportunity o, Boolean doInsert) {
        Contract obj = new Contract();
        obj.AccountId = a.Id;
        obj.SBQQ__Opportunity__c = o == null ? null : o.Id;
        obj.Status = 'Draft';
        obj.StartDate = Date.Today();
        obj.ContractTerm = 12;

        if (doInsert) {
            insert obj;
        }

        return obj;
    }

    /** Create Subscription */
    public static SBQQ__Subscription__c createSubscription(Account a, Product2 p, Contract contract, Boolean doInsert) {
        SBQQ__Subscription__c obj = new SBQQ__Subscription__c();
        obj.SBQQ__Account__c = a.Id;
        obj.SBQQ__Product__c = p.Id;
        obj.SBQQ__Contract__c = contract.Id;
        obj.SBQQ__Quantity__c = 10.00;
        obj.SBQQ__RevisedSubscription__c = obj.Id;

        if (doInsert) {
            insert obj;
        }

        return obj;
    }

    /**
     * @description this method sets up a contract or series of contracts for renewal, equivalent of getting a contract in a 
     *   state where Renewal Quoted can be checked.
     * 
     * @param Integer numOfSubscriptionProducts -> number of asset products to create
     * @param Integer numOfAssetProducts -> number of products to create
     * @param Integer numOfContracts -> number of contracts to create
     * @param Integer numOfSubsPerContract -> number of subscriptions to create on each contract
     */
    public static Account account_contractRenewalRelated;
    public static List<Contract> contractsToInsertRenewalRelated;
    public static void setupTestData_contractRenewalRelated(Integer numOfSubscriptionProducts, Integer numOfAssetProducts, Integer numOfContracts) {
        account_contractRenewalRelated = new Account(Name = 'Test Account');
        insert account_contractRenewalRelated;

        List<Product2> subProductsToInsert = new List<Product2>();
        for(Integer i = 0; i < numOfSubscriptionProducts; i++) {
            Product2 p = createProduct(
                'Subscription Product XYZ' + i, // String name
                'Subscription',                 // String productType
                'SBP-XYZ-111' + i,              // String productCode
                null,                           // Id billingRuleId
                null,                           // Id taxRuleId
                null,                           // Id revRecRuleId
                true,                           // Boolean populateDefaultValues
                false                           // Boolean doInsert
            );
            subProductsToInsert.add(p);
        }
        List<Product2> assetProductsToInsert = new List<Product2>();
        for(Integer i = 0; i < numOfAssetProducts; i++) {
            Product2 p = createProduct(
                'Asset Product XYZ' + i,        // String name
                'Asset',                        // String productType
                'ABP-XYZ-111' + i,              // String productCode
                null,                           // Id billingRuleId
                null,                           // Id taxRuleId
                null,                           // Id revRecRuleId
                true,                           // Boolean populateDefaultValues
                false                           // Boolean doInsert
            );
            assetProductsToInsert.add(p);
        }
        List<Product2> productsToInsert = new List<Product2>();
        productsToInsert.addAll(subProductsToInsert);
        productsToInsert.addAll(assetProductsToInsert);
        insert productsToInsert;

        contractsToInsertRenewalRelated = new List<Contract>();
        for(Integer i = 0; i < numOfContracts; i++) {
            Contract c = createContract(account_contractRenewalRelated, false);
            c.AccountId = account_contractRenewalRelated.Id;
            c.Status = 'Draft';
            // c.EndDate = System.today() + 30;
            contractsToInsertRenewalRelated.add(c);
        }
        insert contractsToInsertRenewalRelated;

        List<Asset> assetsToInsert = new List<Asset>();      
        for(Integer i = 0; i < numOfContracts; i++) {
            for(Integer j = 0; j < assetProductsToInsert.size(); j++) {
                Asset a = createAsset(account_contractRenewalRelated, assetProductsToInsert[i], null, true, false);
                a.Quantity = 1;
                assetsToInsert.add(a);
            }
        }
        insert assetsToInsert;

        List<SBQQ__Subscription__c> subsToInsert = new List<SBQQ__Subscription__c>();
        for(Integer i = 0; i < numOfContracts; i++) {
            for(Integer j = 0; j < subProductsToInsert.size(); j++) {
                SBQQ__Subscription__c s = createSubscription(account_contractRenewalRelated, subProductsToInsert[j], contractsToInsertRenewalRelated[i], false);
                s.SBQQ__Quantity__c = 1;
                s.SBQQ__RenewalQuantity__c = 1;
                s.SBQQ__SubscriptionStartDate__c = System.today();

                if(j == 0 && assetsToInsert.size() > 0) {
                    s.SBQQ__RequiredById__c = assetsToInsert[j].Id;
                }
                subsToInsert.add(s);
            }
        }

        insert subsToInsert;

        // populate the current subscription on the first asset:
        assetsToInsert[0].SBQQ__CurrentSubscription__c = subsToInsert[0].Id;
        update assetsToInsert;
    }
}