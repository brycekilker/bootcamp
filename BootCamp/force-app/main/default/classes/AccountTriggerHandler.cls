public with sharing class AccountTriggerHandler {

    private static void updateAccounts(List<Account> triggeredAccounts) {

        List<Account> accountList = new List<Account>();

        Set<Id> parentAccountIds = new Set<Id>();
            for (Account account : accountList) {
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
        for (Account account : accountList) {
    
        // Populate account with Parent Account's info
            if (account.ParentId != null) {
                account.SLA__c = parentAccountsMap.get(account.ParentId).SLA__c;
                account.Sic = parentAccountsMap.get(account.ParentId).Sic;
                account.Industry = parentAccountsMap.get(account.ParentId).Industry;
                account.CustomerPriority__c = parentAccountsMap.get(account.ParentId).CustomerPriority__c;
                account.SLAExpirationDate__c = parentAccountsMap.get(account.ParentId).SLAExpirationDate__c;
            }
    // Populate Number of Locations to 1 if null
            if (account.NumberofLocations__c == null) {
            account.NumberofLocations__c = 1;
            }
            // If the account's active field is set to no, update to yes
            if (account.Active__c == 'No') {
            account.Active__c = 'Yes';
            } 
        }
        }
}