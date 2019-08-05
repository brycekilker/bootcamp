## SOQL
- checkout semi joins
## DML
- Data Manipulation Langauge
    - Insert
    - Update
- can insert or update on a single object or a list
    - usually a list to bulkify code
- Account accountTest = new Account();

****The below code is not necessarily best practice.
accountTest.Name = 'AccountTestName';

insert accountTest;

System.debug('this is the new account ' + accountTest);

for (Integer i = 0; i <=15; i++) {
    Contact newContact = new Contact(
    FirstName = 'xyzFirst' +i,
    LastName = 'XyZLast' + i,
    Account = accountTest
    );
    insert newContact;
    // System.debug('account updated ' + newContact);
}

List<Contact> contactList = [
 SELECT Id, AccountId, FirstName, LastName
 FROM Contact
 WHERE CreatedDate = Today
 ];

System.debug('this is the contactList ' + contactList);

for (Contact contact : contactList) {
    contact.LeadSource = 'Trade Show';
    System.debug('updated to tradeshow ' + contact);
}

List<Contact> leadList = [
    SELECT Id, Account.Type
    FROM Contact
    WHERE LeadSource ='Trade Show'
];

System.debug('this is leadLIst ' + leadList);

for (Contact contact : leadList) {
    contact.Account.Type = 'Customer - Direct';
    update contact;
System.debug('this is Account Type ' + contact.Account.Type);
}

//null pointer checks are super important in Apex

List<Contact> deleteList = [
 SELECT Id
 FROM Contact
 WHERE CreatedDate = Today
 ];

System.debug('these are contact Ids on deleteList ' + deleteList);

delete deleteList;



## Governer Limits
- Never put a SOQL Query into a loop