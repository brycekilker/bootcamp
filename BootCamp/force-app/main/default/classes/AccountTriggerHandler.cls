public with sharing class AccountTriggerHandler {
    public static void beforeInsertMethod(List<Account> triggeredAccounts) {
        updateAccounts(triggeredAccounts);
    }

    public static void beforeUpdateMethod(List<Account> triggeredAccounts, Map<Id, Account> accountsOldMap) {
        anotherMethod(triggeredAccounts, accountsOldMap);
    }

    /////////////----Helper Method------//////////////
    private static void updateAccounts(List<Account> triggeredAccounts) {
        for (Account account : triggeredAccounts) {
            
        }
    }

    private static void anotherMethod(List<Account> accountList , Map<Id,Account> oldMap) {

    }

}
