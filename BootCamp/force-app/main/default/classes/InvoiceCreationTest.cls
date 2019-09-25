@isTest 
public with sharing class InvoiceCreationTest {
    @isTest 
    public static void InvoiceCreationTest() {
        //run test setup
        CreateTestData.CreateTestData();

        List<Usage_Summary__c> usageSummaryList = [
			SELECT Id, Start_Date__c, End_Date__c, Grand_Total_Usage__c
			FROM Usage_Summary__c
            Limit 10
		];
        

        for(Usage_Summary__c usageSummary : usageSummaryList) {
            usageSummary.End_Date__c = Date.today();
        }
System.debug('is there one that ends today? ' + usageSummaryList);
        update usageSummaryList;
    }

    @isTest public static void createInvoices() {
        Test.startTest();
            InvoiceCreation testBatch = new InvoiceCreation();
            Id batchId = Database.executeBatch(testBatch, 150);
        Test.stopTest();
    }

    static testMethod void InvoiceCreationScheduleTest() {
        Test.StartTest();
            InvoiceCreation sh1 = new InvoiceCreation();      
            String sch = '0 0 23 * * ?';
            String cronID = system.schedule('Test check', sch, sh1);
            Id newApexBatchId = Database.executeBatch(sh1, 4);
        Test.stopTest();
        CronTrigger cronTrigger_after = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :cronID];
        System.assertEquals('0 0 23 * * ?', cronTrigger_after.CronExpression, 'Problem with CronExpression! ');
    }
}


