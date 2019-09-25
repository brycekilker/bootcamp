public with sharing class OrderProductTriggerHandler {

    public static void afterInsertMethod(List<OrderItem> triggeredOPs) {
        System.debug('After Insert ------------> ' + triggeredOPs);
        createUsageSummaries(triggeredOPs);
    }

    public static void beforeInsertMethod(List<OrderItem> triggeredOPs) {
        System.debug('before Insert ------------> ' + triggeredOPs);
        setOrderDates(triggeredOps);
    }

    //Needed to move this into a before trigger becasue otherwise the record is read only.
    public static void setOrderDates(List<OrderItem> triggeredOPs) {
        //Get order Ids from order products
        Set<Id> OPOrderIds = new Set<Id>();

        //loop through order products and add Id's to set
        if (triggeredOPs.size() > 0 ) {
            for (OrderItem orderProduct : triggeredOPs) {
                OPOrderIds.add(orderProduct.OrderId);
            }
        }
     
        Map<Id, Order> orderMap = new Map<Id, Order>([
            SELECT Id, EndDate
            FROM Order
            WHERE Id IN :OPOrderIds
        ]);

        System.debug('order map ' + orderMap);
        //getting the order end date onto the order item, probably some way to do this in a lookup field or something.
        for (OrderItem orderProduct : triggeredOPs) {
            Order actualOrder = orderMap.get(orderProduct.OrderId);
            System.debug('got it? ' + actualOrder.EndDate);
            //this won't really work because not all months have 30 days unless we just declare its a 30 day cycle
            orderProduct.EndDate = actualOrder.EndDate;
            // orderProduct.Number_Of_Terms__c = ((actualOrder.EndDate - orderProduct.ServiceDate) / 365 * 12 < 1) ? 1 : (actualOrder.EndDate - orderProduct.ServiceDate) / 365 * 12;
            Integer monthsBetween = orderProduct.ServiceDate.monthsBetween(actualOrder.EndDate);

            //avoid decimal on/12
            //I should set a rule that contract lengths must be 12 months.

            orderProduct.Number_Of_Terms__c = orderProduct.Usage_Frequency__c == 'Monthly' ? monthsBetween : monthsBetween/12;
        }
    }

    //TODO: Not Getting account on the usage Summaries ergo neither the invoices
    public static void createUsageSummaries(List<OrderItem> triggeredOPs) {        
        List<Usage_Summary__C> newUsageSummaries = new List<Usage_Summary__c>();
        
        for (OrderItem orderProduct :triggeredOPs) {
            Integer periodCounter = 0;
            if (orderProduct.Usage_Frequency__c == 'Monthly') {
                for (Integer i = 0; i < orderProduct.Number_Of_Terms__c ; i++) {
                    Usage_Summary__c newUsageSummary = new Usage_Summary__c();
                    newUsageSummary.Account__c = orderProduct.Account_Name__c;
                    newUsageSummary.Order_Product__c = orderProduct.Id;
                    newUsageSummary.Start_Date__c = orderProduct.ServiceDate.addMonths(periodCounter);
                    newUsageSummary.End_Date__c = orderProduct.ServiceDate.addMonths(periodCounter+1);
                    newUsageSummary.Order__c = orderProduct.OrderId;
                    newUsageSummary.Minimum_Paid__c = orderProduct.Usage_Type__c == 'Advance' ? true : false;
                    newUsageSummary.Usage_Period__c = periodCounter;
                    newUsageSummaries.add(newUsageSummary);
                    periodCounter++;
                }
            } else if (orderProduct.Usage_Frequency__c == 'Annual') {
                for (Integer i = 0; i < orderProduct.Number_Of_Terms__c ; i++) {
                    Usage_Summary__c newUsageSummary = new Usage_Summary__c();
                    newUsageSummary.Account__c = orderProduct.Account_Name__c;
                    newUsageSummary.Order_Product__c = orderProduct.Id;
                    newUsageSummary.Start_Date__c = orderProduct.ServiceDate.addYears(periodCounter);
                    newUsageSummary.End_Date__c = orderProduct.ServiceDate.addYears(periodCounter+1);
                    newUsageSummary.Order__c = orderProduct.OrderId;
                    newUsageSummary.Minimum_Paid__c = orderProduct.Usage_Type__c == 'Advance' ? true : false;
                    newUsageSummary.Usage_Period__c = periodCounter;
                    newUsageSummaries.add(newUsageSummary);
                    periodCounter++;
                }
            }
            System.debug('this is orderProduct ' + orderProduct);
            periodCounter = 0;
        }
        if(newUsageSummaries.size() > 0) {
            System.debug('this is what I am about to insert' + newUsageSummaries);
            insert newUsageSummaries;
        }
    }
}
