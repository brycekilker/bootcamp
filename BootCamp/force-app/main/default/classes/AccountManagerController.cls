public with sharing class AccountManagerController {

    public class AccountWrapper {
        
        public Boolean isSelected {get; set;}
        public Account account {get; set;}

        public AccountWrapper(Account account) {

            this.account = account;
            isSelected = false;

        }
    }
    
    public List<AccountWrapper> accountWrappers {get; set;}
    public Account selectedAccount {get; set;}
    public Id recordId {get; set;}
    
    public AccountManagerController() {

        recordId = ApexPages.currentPage().getParameters().get('id');
        selectedAccount = new Account();

        if (recordId != null) {
            selectedAccount = [
                SELECT Id, Name, Type, NumberOfEmployees, Industry
                FROM Account
                WHERE Id = :recordId
            ];
        }
        //every time the page loads it creates a new instance
        fetchAccounts();
        
    }

    public void fetchAccounts() {

        accountWrappers = new List<AccountWrapper>();

       List<Account> accountList = [
            SELECT Id, Name, Type, NumberOfEmployees, CreatedDate
            FROM Account
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];

        for (Account account : accountList) {
            accountWrappers.add(new AccountWrapper(account));
        }
    }
    
        public void createAccountOrUpdateAccount() {
        if(selectedAccount.Id == null) {
            insert selectedAccount;
        } else {
            update selectedAccount;
        }
        
        fetchAccounts();
        selectedAccount = new Account();
    }

    public void populateAccountForm() {
        selectedAccount = [
            SELECT Id, Name, Type, Industry, NumberOfEmployees
            FROM Account
            WHERE Id = :selectedAccount.Id
        ];
    }

    public void clearForm(){
        selectedAccount = new Account();
    }

    public void deleteAccounts() {
        List<Account> accountsToDelete = new List<Account>();

        for (AccountWrapper currentWrapper : accountWrappers) {
            if(currentWrapper.isSelected == true) {
                accountsToDelete.add(currentWrapper.account);
            }
        }

        if(accountsToDelete.size() > 0) {
            delete accountsToDelete;
            fetchAccounts();
            clearForm();
        }
    }
}
