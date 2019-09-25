global with sharing class InvoiceCreation implements Database.Batchable<SObject>, Schedulable {

    String query;

    global InvoiceCreation() {
        if(Test.isRunningTest()){
            Usage_Invoice__c newUsageInvoice = new Usage_Invoice__c(Name = 'test usage invoice');
            insert newUsageInvoice;
        }

        //Create Usage Invoices 
        List<Usage_Invoice__c> newUsageInvoices = new List<Usage_Invoice__c>();
        List<Usage_Summary__c> listofUsageSummaries = [
            SELECT Id, Account__c, Order_Product__c, End_Date__c, Order__c, Order__r.Order_Product__r.Opportunity__c, order__r.SBQQ__Quote__c,
                   Grand_Total_Usage__c, Base_Charge__c, Overage_Charge__c, Total_Charge__c 
            FROM Usage_Summary__c
            WHERE End_Date__c <= TODAY
        ];
         

        for (Usage_Summary__c usageSummary : listofUsageSummaries ) {
            Usage_Invoice__c newUsageInvoice = new Usage_Invoice__c();
            newUsageInvoice.Account__c = usageSummary.Account__c;
            newUsageInvoice.Opportunity__c = usageSummary.Order__r.Order_Product__r.Opportunity__c;
            newUsageInvoice.Quote__c = usageSummary.order__r.SBQQ__Quote__c;
            newUsageInvoice.Order__c = usageSummary.Order__c;
            newUsageInvoice.Order_Product__c = usageSummary.Order_Product__c;
            newUsageInvoice.Usage_Summary__c = usageSummary.Id;
            newUsageInvoice.Month__c = string.valueOf(usageSummary.End_Date__c.month());
            newUsageInvoice.Total_Amount_Due__c = usageSummary.Total_Charge__c;
            System.debug(' we are creating the invoice ' + newUsageInvoice);
            newUsageInvoices.add(newUsageInvoice);
        }

        System.debug('did we make any invoices? ' + newUsageInvoices);

        if(newUsageInvoices.size() != 0) {
            insert newUsageInvoices;
        }

        query = 'SELECT Id, Account__c, Opportunity__c, Month__c, Quote__c, Order__c, Order_Product__c, Usage_Summary__c, Total_Amount_Due__c, LastModifiedDate '
                + 'FROM Usage_Invoice__c '
                + 'WHERE LastModifiedDate <= TODAY';
    }

    global Database.QueryLocator start (Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Usage_Invoice__c> invoiceList) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        if(invoiceList.size() > 0) {
            for ( Usage_Invoice__c invoice : invoiceList) {
                Messaging.singleEmailMessage message = new Messaging.SingleEmailMessage();
                String[] receiver = new String[] {'bryce.kilker@atginfo.com'};
                message.setToAddresses(receiver);
                message.setSubject('Invoice for: ' + invoice.Account__c);
                message.setPlainTextBody('Month: ' + invoice.month__c  + 'Product: ' + invoice.order_Product__c + 'Total Amount Due: ' + invoice.Total_Amount_Due__c);
                emails.add(message);
            }
        }
        if (emails.size() > 0) {
            Messaging.sendEmail(emails);
        }
    }

global void finish(Database.BatchableContext BC) {
    System.debug('we finished!');
}

global void execute(SchedulableContext SC) {
    Database.executeBatch(new InvoiceCreation(), 200);
}

}
