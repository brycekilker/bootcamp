public with sharing class ScheduledQuoteCheck implements Database.Batchable<sObject>, Schedulable {

    String query;

    public ScheduledQuoteCheck() {
        query = 'SELECT Id, SBQQ__Status__c, SBQQ__Ordered__c FROM SBQQ__Quote__c WHERE SBQQ__Status__c = \'Approved\' ';
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<SBQQ__Quote__c> quoteList) {
        for(SBQQ__Quote__c quote : quoteList) {
            quote.SBQQ__Ordered__c = True;
            
        }
        System.debug('we got the quote ' + quoteList);
        update quoteList;
    }

    public void finish(Database.BatchableContext BC) {
    }

    public void execute(SchedulableContext SC) {
        CronTrigger ct = [
            SELECT TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE Id = :SC.getTriggerId()
        ];

        Database.executeBatch( new ScheduledQuoteCheck(), 150);
    }

}
