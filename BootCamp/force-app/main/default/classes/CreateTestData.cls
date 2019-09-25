@isTest
public with sharing class CreateTestData {

	@TestSetup
	public static void CreateTestData() {
        //Create Account for testing
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

        //Create Products 
		List<Product2> testProductList = new List<Product2>();
		Product2 prod1 = new Product2(
            Name = 'Prod1',
			Base_Usage_Rate__c = 10, 
            Usage_Frequency__c = 'Annual', 
            Usage_Minimum_Commit__c = 5, 
            Usage_Overage_Threshold__c = 20, 
            Usage_Overage_Rate__c = 20, 
            Usage_Type__c = 'Advance'
			);
		testProductList.add(prod1);

		Product2 prod2 = new Product2
			(Name = 'Prod2',
			Base_Usage_Rate__c = 12, 
			Usage_Frequency__c = 'Monthly', 
			Usage_Minimum_Commit__c = 0,
			Usage_Overage_Threshold__c = 100, 
			Usage_Overage_Rate__c = 30, 
			Usage_Type__c = 'Arrears'
			);
		testProductList.add(prod2);

		Product2 prod3 = new Product2(
			Name = 'Prod3',
			Base_Usage_Rate__c = 3, 
			Usage_Frequency__c = 'Annual',
			Usage_Minimum_Commit__c = 50,  
			Usage_Overage_Threshold__c = 67, 
			Usage_Overage_Rate__c = 5, 
			Usage_Type__c = 'Advance'
			);
		testProductList.add(prod3);

		Product2 prod4 = new Product2(
			Name = 'Prod4', 
			Usage_Frequency__c = 'Monthly', 
			Usage_Overage_Threshold__c = 90, 
			Usage_Overage_Rate__c = 2, 
			Usage_Type__c = 'Arrears'
			);
		testProductList.add(prod4);
		insert testProductList;

		//Create Opportunity
		List<Opportunity> testOpportunityList = new List<Opportunity>();
		Opportunity testOpportunity = new Opportunity(
			Name = 'Test Opportunity', 
			StageName = 'Prospecting', 
			CloseDate = Date.today(), 
			AccountId = testAccount.Id, 
			Pricebook2Id = Test.getStandardPricebookId(), 
			SBQQ__QuotePriceBookId__c = Test.getStandardPricebookId()
			);
		testOpportunityList.add(testOpportunity);
		insert testOpportunityList;
		

		//Create Pricebook Entries
		List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();

		PricebookEntry priceBookEntry1 = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(), 
			Product2Id = prod1.Id, 
			UnitPrice = 1,
			isActive = true);
		priceBookEntryList.add(priceBookEntry1);

		PricebookEntry priceBookEntry2 = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(), 
			Product2Id = prod2.Id, 
			UnitPrice = 1, 
			isActive = true);
		priceBookEntryList.add(priceBookEntry2);

		PricebookEntry priceBookEntry3 = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(), 
			Product2Id = prod3.Id, 
			UnitPrice = 1,
			isActive = true);
		priceBookEntryList.add(priceBookEntry3);

		PricebookEntry priceBookEntry4 = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(), 
			Product2Id = prod4.Id, 
			UnitPrice = 1,
			isActive = true);
		priceBookEntryList.add(priceBookEntry4);

		insert priceBookEntryList;
		//Create Quote
		List<SBQQ__Quote__c> newQuoteList = new List<SBQQ__Quote__c>();
		// SBQQ__Quote__c primaryQuote = CPQ_TestUtilsA.createQuote(testAccount, testOpportunity, true, true, true);
		SBQQ__Quote__c primaryQuote = new SBQQ__Quote__c(
			SBQQ__Account__c = testAccount.Id, 
			SBQQ__Opportunity2__c = testOpportunity.Id, 
			SBQQ__StartDate__c = Date.today().addYears(-2), 
			SBQQ__EndDate__c = Date.today(),
			SBQQ__Primary__c = true
			);
		newQuoteList.add(primaryQuote);
		insert newQuoteList;

		//Create Quote Lines
		List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();

		SBQQ__QuoteLine__c testQuoteLine1 = new SBQQ__QuoteLine__c(
			SBQQ__Quote__c = primaryQuote.Id, 
			SBQQ__Product__c = prod1.Id, 
			SBQQ__PricebookEntryId__c = priceBookEntry1.Id, 
			Usage_Frequency__c = 'Annual', 
			SBQQ__Quantity__c = 1
			);
		quoteLineList.add(testQuoteLine1);

		SBQQ__QuoteLine__c testQuoteLine2 = new SBQQ__QuoteLine__c(
			SBQQ__Quote__c = primaryQuote.Id, 
			SBQQ__Product__c = prod2.Id, 
			Usage_Frequency__c = 'Monthly', 
			SBQQ__PricebookEntryId__c = priceBookEntry2.Id, 
			SBQQ__Quantity__c = 1
			);
		quoteLineList.add(testQuoteLine2);

		SBQQ__QuoteLine__c testQuoteLine3 = new SBQQ__QuoteLine__c(
			SBQQ__Quote__c = primaryQuote.Id, 
			SBQQ__Product__c = prod3.Id, 
			SBQQ__PricebookEntryId__c = priceBookEntry3.Id, 
			Usage_Frequency__c = 'Annual', 
			SBQQ__Quantity__c = 1
			);
		quoteLineList.add(testQuoteLine3);

		SBQQ__QuoteLine__c testQuoteLine4 = new SBQQ__QuoteLine__c(
			SBQQ__Quote__c = primaryQuote.Id, 
			Usage_Frequency__c = 'Monthly', 
			SBQQ__Product__c = prod4.Id, 
			SBQQ__PricebookEntryId__c = priceBookEntry4.Id, 
			SBQQ__Quantity__c = 1
			);
		quoteLineList.add(testQuoteLine4);

		insert quoteLineList;

		//order opportunity

		testOpportunity.SBQQ__Ordered__c = true;

		update testOpportunity;
	}
}