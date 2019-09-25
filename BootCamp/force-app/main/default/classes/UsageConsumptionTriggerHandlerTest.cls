@isTest 
public with sharing class UsageConsumptionTriggerHandlerTest {
    @isTest 
    public static void UsageConsumptionTriggerHandlerTest() {
        //run test setup
        CreateTestData.CreateTestData();
        //query created usage summary
        List<Usage_Summary__c> usageSummaryList = [
			SELECT Id, Start_Date__c, End_Date__c, Grand_Total_Usage__c
			FROM Usage_Summary__c
            Limit 1
		];

    List<Usage_Consumption__c> usageConsumptionList = new List<Usage_Consumption__c>();

    // for (Usage_Summary__c usageSummary : usageSummaryList) {

    // }
    Usage_Consumption__c testUsageConsumption = new Usage_Consumption__c(
        Name = 'Test Usage Consumption', 
        Usage_Summary__c = usageSummaryList[0].Id,
        Loaded_Date__c = Date.today(),
        Usage_Amount__c = 86
        );

        insert testUsageConsumption;
    }
}