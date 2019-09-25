global with sharing class InvoiceCreation implements Database.Batchable<SObject>, Schedulable {

    String query;

    global InvoiceCreation() {
        

        //Create Usage Invoices 
        List<Usage_Invoice__c> newUsageInvoices = new List<Usage_Invoice__c>();
        
        for (Usage_Summary__c usageSummary : [
            SELECT Id, Account__c, Order_Product__c, End_Date__c, Order__c, order__r.SBQQ__Quote__r.SBQQ__Opportunity2__c,
                   Grand_Total_Usage__c, Base_Charge__c, Overage_Charge__c, Total_Charge__c 
            FROM Usage_Summary__c
            WHERE End_Date__c <= TODAY
        ]) {
            Usage_Invoice__c newUsageInvoice = new Usage_Invoice__c();

            newUsageInvoice.Account__c = usageSummary.Account__c;
            newUsageInvoice.Opportunity__c = usageSummary.order__r.SBQQ__Quote__r.SBQQ__Opportunity2__c;
            newUsageInvoice.Quote__c = usageSummary.order__r.SBQQ__Quote__c;
            newUsageInvoice.Order__c = usageSummary.Order__c;
            newUsageInvoice.Order_Product__c = usageSummary.Order_Product__c;
            newUsageInvoice.Usage_Summary__c = usageSummary.Id;
            newUsageInvoice.Month__c = string.valueOf(usageSummary.End_Date__c.month());
            newUsageInvoice.Total_Amount_Due__c = usageSummary.Total_Charge__c;
            System.debug(' we are creating the invoice ' + newUsageInvoice);
            newUsageInvoices.add(newUsageInvoice);
        }

        if(newUsageInvoices.size() != 0) {
            insert newUsageInvoices;
        }

        query = 'SELECT Id, Account__c, Opportunity__c,  usageSummary.order__r.SBQQ__Quote__c, Order__c, Order_Product__c, Usage_Summary__c, Total_Amount_Due__c '
                + 'FROM Usage_Summary__c '
                + 'WHERE UsageSummaryId__r.End_Date__c <= TODAY';
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
