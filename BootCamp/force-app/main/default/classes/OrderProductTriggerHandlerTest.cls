@isTest 
public with sharing class OrderProductTriggerHandlerTest {
    @isTest
	public static void OrderProductTestData() {
        //run test setup
        CreateTestData.CreateTestData();
        //query created usage summary
        List<Usage_Summary__c> usageSummary = [
			SELECT Id, Start_Date__c, End_Date__c
			FROM Usage_Summary__c
            Limit 1
		];
		System.debug ('We have the usage Summary ' + usageSummary);
	}
}
