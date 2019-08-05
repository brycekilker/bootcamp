public with sharing class AccountTriggerHandler {

    //------------Handlers------------//

    public static void beforeInsertMethod(List<Account> triggeredAccounts) {
        System.debug('Before Insert ------------> ');
        updateAccounts(triggeredAccounts);
    }

    // public static void afterInsertMethod(List<Account> triggeredAccounts, Map<Id, Account> accountsOldMap) {
        
    // }

    public static void beforeUpdateMethod(List<Account> triggeredAccounts) {
        System.debug('Before Update ------------> ');
        updateAccounts(triggeredAccounts);
    }
    
    //---------------Helper Methods-----------//

    private static void updateAccounts(List<Account> triggeredAccounts) {

        //Grab parentAccountIds in a set to map through later
        Set<Id> parentAccountIds = new Set<Id>();

        //Check if the Accounts in the list have a parentAccount and add it to the List
        for (Account account : triggeredAccounts) {
            if (account.ParentId != null) {
        parentAccountIds.add(account.ParentId);
            }
        }

    // Create a map of the Parent Accounts with fields we need
        Map<Id, Account> parentAccountsMap = new Map<Id, Account>([
            SELECT SLA__C, Sic, Industry, CustomerPriority__c, SLAExpirationDate__c
            FROM Account
            WHERE Id 
            IN :parentAccountIds
        ]);

    // Loop through all the accounts in Trigger.new
        for (Account account : triggeredAccounts) {
        // Populate account with Parent Account's info
            if (account.ParentId != null) {
                account.SLA__c = parentAccountsMap.get(account.ParentId).SLA__c;
                account.Sic = parentAccountsMap.get(account.ParentId).Sic;
                account.Industry = parentAccountsMap.get(account.ParentId).Industry;
                account.CustomerPriority__c = parentAccountsMap.get(account.ParentId).CustomerPriority__c;
                account.SLAExpirationDate__c = parentAccountsMap.get(account.ParentId).SLAExpirationDate__c;
            }
            System.debug('we hit the ifBlock to update from parentAccounts ' + account);
    // Populate Number of Locations to 1 if null
            if (account.NumberofLocations__c == null) {
            account.NumberofLocations__c = 1;
            }
            System.debug('number of locations ' + account.NumberofLocations__c);
            // If the account's active field is set to no, update to yes
            if (account.Active__c == 'No') {
            account.Active__c = 'Yes';
            } 
        }
    }
}