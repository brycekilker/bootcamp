global with sharing class ScheduledOrderItem implements Database.Batchable<sObject>, Schedulable {

    String query;

    global ScheduledOrderItem() {
        query = 'SELECT Id '
              + 'FROM Opportunity '
              + 'WHERE CloseDate < TODAY '
              + 'AND StageName != \'Closed Won\'' 
              + 'AND StageName != \'Closed Lost\'' ;
    }

    global Database.QueryLocator Start (Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> opptyList) {

        for (Opportunity opp : opptyList) {
            opp.StageName = 'Closed Lost';
        }

        update opptyList;

        System.debug('this is the scheduled process ' + opptyList);
    }

    global void finish(DataBase.BatchableContext BC) {
    }

    // Execute Method for the Schedulable interface
    global void execute(SchedulableContext SC) {

        CronTrigger ct =
                [SELECT TimesTriggered, NextFireTime
                FROM CronTrigger
                WHERE Id = :SC.getTriggerId()];

        Database.executeBatch(new ScheduledOrderItem(), 150);
    }
}
