public with sharing class AccountTriggerExerciseHandler {
    
    
    public static void beforeInsertMethod(List<Account> triggeredAccounts) {
        updateAccounts(triggeredAccounts);
    }

    /////////////----Helper Methods------//////////////
    private static void updateAccounts(List<Account> triggeredAccounts) {
        for (Account account : triggeredAccounts) {
            
            //this won't work because the ID is not yet available. Need to setmap through it like below
        //          Map<Id, Account> parentAccounts = new Map<Id,Account>(
        //     [
        //         SELECT Id, Name, SLA__c, SLAExpirationDate__c, Sic, Industry, CustomerPriority__c
        //         FROM Account
        //         WHERE Id = :account.ParentId
        //     ]
        // );
            Account parentAccount = [
                SELECT Id, Name, SLA__c, SLAExpirationDate__c, Sic, Industry, CustomerPriority__c
                FROM Account
                WHERE Id = :account.ParentId
            ];

            if (parentAccount != null) {
                account.SLA__c = parentAccount.SLA__c;
                account.SLAExpirationDate__c = parentAccount.SLAExpirationDate__c;
                account.Sic= parentAccount.Sic;
                account.Industry = parentAccount.Industry;
                account.CustomerPriority__c = parentAccount.CustomerPriority__c;
            System.debug('this is the new account ' + account);
            }

            if(account.NumberofLocations__c == null) {
                account.NumberOfLocations__c = 1;
            }

            if(account.Active__c == null) {
                account.Active__c = 'Yes';
            }
        }
    }
}
