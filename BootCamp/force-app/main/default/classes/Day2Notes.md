# Day 2

## Collections
- Collections hold similar dataTypes together
- each collection has to be same dateType!
    - Lists - Most Common 
    - Sets
    - Maps 

## List
- ordered collection of elements

## Sets
- Unordered collections
- Can contain any datatype
- cannot contain duplicates

## Maps
- Pair of key values
- Account newAccount = new Account();
newAccount.name = 'New Map Account';

insert newAccount;

Account queriedAccount = [
    SELECT Id, Name
    FROM Account
    WHERE Name = 'New Map Account'
    LIMIT 1                                   
];

Map<Id, Account> newAccountMap = new Map<Id, Account>();
newAccountMap.put(queriedAccount.Id, queriedAccount);

Account foundAccount = newAccountMap.get(queriedAccount.Id);

System.debug('found account '+ foundAccount.Name)


## Conditionals & for Loops
- Boolean trueOrFalse = true;
String dog = 'Bark';

if (trueOrFalse) {
    //perform code if true
} else if (dog == 'bark') {
    //perform code
} else {
    // do this
}

x ? 'do this' : 'do that'

switch on name {
    when 'John' {
        //do this
    }
    when 'Jack', 'James' {
        //Do this
    }
    when else {
        'do this'
    }
}