@isTest 
public with sharing class OpportunityQueueable1Test {

    @isTest public static void OpportunityQueueable1Test() {
        Opportunity testOppty = new Opportunity();
        testOppty.StageName = 'Prospecting';
        testOppty.CloseDate = Date.today();
        testOppty.name = 'testOppty';

        insert testOppty;

        Test.startTest();
   
        Test.stopTest();
    }   
}
