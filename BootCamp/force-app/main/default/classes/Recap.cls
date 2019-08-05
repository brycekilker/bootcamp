public with sharing class Recap {
    public static List<String> youAlwaysNeedAMethod() {

        List<String> thisList = new List<String>{'I', 'Can', 'add', 'to', 'the', 'list'};
        thisList.add('I can also add like this');

        System.debug(thisList);
        return thisList;
    }

    public static void thisIsASet() {
        //Unordered collection of elements that do not contain duplicates!!!
        //This is great for setting up Id's for maps where you can't have and duplicates

        Set<Id> someIds = new Set<Id>{'These', 'are', 'unique', 'Ids'};
        //I can use 'add all' to put a list into a set
        // Set<String> thisSet = new Set<String>();
        // thisSet.addAll(Recap.youAlwaysNeedAMethod());

        // System.debug('this set baby' + thisSet);
        //.contains() checks if something is in a set. cant use indexOf on a set

    }

    public static void theseAreMaps() {
        //Key-value pairs that map a unique key to a single value

        Account newAccount = new Account();
        newAccount.Name = 'Map Example Account';
        insert newAccount;

        Account queriedAccount = [
            SELECT Id, Name
            FROM Account 
            WHERE Name = 'Map Example Account'
            LIMIT 1
        ];

        //Put Account into Map
        Map<Id, Account> accountMap = new Map<Id, Account>();
        accountMap.put(queriedAccount.Id, queriedAccount);

        //Use the AccountId to get the Account Record
        Account findAccount = accountMap.get(queriedAccount.Id);
        System.debug('this is the account name ' + findAccount.Name);

        //Access field with dot notation 
        //this is really good to see, pulling the values off of the queried account
        String accountName = accountMap.get(queriedAccount.Id).Name;
        System.debug('this is the account name ' + accountName);

        //Important!
        //Use a Map constuctor to take in a list and create a map by record Id's. WE use this alot
        Map<Id, Account> accountMaps = new Map<Id, Account>([
            SELECT Id, Name, NumberofEmployees
            FROM Account
        ]);
        System.debug('accountMaps ' + accountMaps);
    }

    //Loops!
    //I know this but im still going to write it out
    public static void loops() {

        Boolean trueOrFalse;
        if (trueOrFalse == true){
            System.debug('this is true');
        }else {
            System.debug('that is false');
        }

        String name = 'John'; // assume this data could vary

        switch on name {
            when 'John' { // when block 1
                // Take some specific action in this case
            }
            when 'Jack', 'James' { // when block 2
                // Take some specific action in this case
            }
            when 'Ralph' { // when block 3
                // Take some specific action in this case
            }
            when else { // default block, optional
                // Take some specific action in this case
            }
        }
        //remember this cool way to loop

        List<Account> thisList = new List<Account>{
            new Account(Name = 'Foo'),
            new Account(Name = 'bar'),
            new Account(Name = 'lix')
        };

        for(Account account: thisList) {
            System.debug('this is how you print accounts: ' + account);
        }

        //Pick up on looping through maps, super important!
        //Heres how to loop through a map
        //The Map constructor takes in a LIST of SObject and creats a map by the record Id
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id FROM Account]);

        for (Id accountId : accountMap.keySet()) {
            //Perform some action using the key, or get the value
            Account account = accountMap.get(accountId);
        }

        for(Account accountRecord : accountMap.values()) {
            //Make updates to records in the map
        }

        //This loop loops through a SOQL Query since it returns a List it can be interated without storing the initial results in a variable
        for (Contact contactRecord : [Select Id, Name From Contact]) {
            //Loop thorugh every COntact record retrieved in theSOQL Query
        }
    }

    public static void soqlUnit() {
        //This is the basic setup of a Soql query
        List<Account> accountList = [SELECT Id, Name, Phone FROM Account];

        //The WHERE clause allows us to add conditional logic to queries to further filter information. 
        //The AND Clause lets us combine conditions
        //Remember to add the LIMIT 1 option when you only want one record.

        List<Opportunity> Opportunity = [
            SELECT Id, Account.Name
            FROM Opportunity
            WHERE Account.Name = 'Acme Co'
            And CloseDate > TODAY
            LIMIT 1
        ];

        //Use the : within your query to bind the variable and let SF know you want to evaluate the local variable before completeing the SOQL query
        //use the IN clause to find the local variable to filter results

        //populate Map with SOQL
        List<Opportunity> opptyList = [SELECT Id FROM Opportunity];
        Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>([SELECT Id FROM Opportunity]);
    }

    public static void dmlRecap() {
        //create new Account
        Account newAccount = new Account(Name = 'Acme Corp unlimited', Phone = '555-666-5555');

        //Perform DML
        insert newAccount;

        //Query the account now that we have the ID info
        Account myAccount = [
            SELECT Id, Name, Phone, CreatedDate
            FROM Account
            WHERE Name = 'Acme Corp Unlimited'
            LIMIT 1
        ];
        
        //Update the account Record
        myAccount.CustomerPriority__c = 'High';
        update myAccount;

        //Create a new opprotunity referencing the account now that its updated

        Opportunity newOppty = new Opportunity();
        newOppty.Name = 'Awesome Opp';
        newOppty.StageName = 'Needs Analysis';
        newOppty.CloseDate = Date.today();
        newOppty.AccountId = myAccount.Id;

        insert newOppty;
    }

    public static void queryChildren() {
        //Qyery all accounts along with their related opportunities
        List<Account> accountList = [SELECT Id, Name, (
            SELECT Id, Name
            FROM Opportunities
            WHERE StageName = 'Closed Won'
        )
        FROM Account
        ];

        //For every account, count how many opporunities are related to it
        for (Account accountRecord : accountList) {
            Integer count = accountRecord.Opportunities.size();
            System.debug('The '  + accountRecord.Name + ' has ' + count + ' Opportunities');
        }

    }

    // Remember to do a check to see if a list has anything in it before doing a dml
    // Check to see if the list has any records in it
        // if (orderProductListToUpdate.size() > 0) {
        //     update orderProductListToUpdate;
        // }
    //Same with null pointer exceptions

    public static void triggerRecap() {
        //new & old vairables contain a list of sObjects 
        //newMap & oldMap have the sObject Id as the key and the sObect as the value
    }
}

