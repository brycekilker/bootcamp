@isTest 
public with sharing class UsageSummaryTriggerHandlerTest {
    @isTest 
    public static void UsageSummaryTriggerHandlerTest() {
        //run test setup
        CreateTestData.CreateTestData();
        //query created usage summary
        List<Usage_Summary__c> usageSummaryList = [
			SELECT Id, Start_Date__c, End_Date__c, Grand_Total_Usage__c
			FROM Usage_Summary__c
            Limit 1
		];

        for(Usage_Summary__c usageSummary : usageSummaryList) {
            usageSummary.Start_Date__c = Date.today();
            System.debug('did we update? ' + usageSummary.Start_Date__c);
        }
     
        update usageSummaryList;
		System.debug ('We have the usage Summary ' + usageSummaryList);
    }
}
