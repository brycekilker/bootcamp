//on a nightly basis contract all activated orders. && send an email with the batch results every evening.

global with sharing class ContractActivatedOrders implements Database.Batchable<Sobject>, Schedulable {

    String query;

    global ContractActivatedOrders() {
        query = 'SELECT Id, ActivatedById, Status, Name '
              + 'FROM Order '
              + 'WHERE Status = \'Activated\'';
    }

    global Database.QueryLocator Start (Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Order> orderList) {

        for (Order order : orderList) {
            order.SBQQ__Contracted__c = True;
        }

        update orderList;

        System.debug('this is the order list ' + orderList);
    }

    global void finish(DataBase.BatchableContext BC) {
        sendmail();
    }

    //Execute for schedulable
    global void execute(SchedulableContext SC) {

        if (Test.isRunningTest()) {
            Database.executeBatch(new ContractActivatedOrders());
        } else {
            CronTrigger ct =
                [SELECT TimesTriggered, NextFireTime
                FROM CronTrigger
                WHERE Id = :SC.getTriggerId()];
            //scheduleBatch is what I want for schedulable


            Database.scheduleBatch(new ContractActivatedOrders(), 'Schedule job activated orders', 5 );
        }
    }

    private void sendmail() {

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string [] toaddress= New string[]{'bryce.kilker@atginfo.com'};
        email.setSubject('Testing Apex Scheduler-Subject');
        email.setPlainTextBody('Testing Apex Scheduler-Body');
        email.setToAddresses(toaddress);
        Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
    }
}