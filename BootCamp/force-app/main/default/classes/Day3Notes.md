## Day 3 - Loops
- for (Integer i = 0; i < 10; i++) {
    //Perform code each time

System.debug('I am a loop');
}

List<Integer> myValues = new List<Integer>{1, 2, 3, 4, 5, 6};

for (Integer i = 0; i < myValues.size(); i++) {
    //more code!
}

List<Account> myAccountList = new List<Account>{
    new Account(Name ='Foo'),
    new Account(Name = 'Bar'),
    new Account(Name = 'fun')
};

List<Account> accountList = new List<Account>();

for (Account myAccount : myAccountList) {
    // run code as long as there are values in myAccountList
    myAccount.NumberOfEmployees = 10;
    accountList.add(myAccount);
}

System.debug('Myaccount List ' + accountList);

//This is more efficeint for inefficient cases
for (Contact contactRecord : [SELECT Id, Name FROM Contact]){
    //Loop through every contact retrieved from SOQL Query.
}





Map<String, Integer> gymMembers = new Map<String, Integer>{
   'Jim	Bean' => 2018,
    'Jane	Smith'	=> 2014,
    'Robbie	Rotten'	=> 2018,
    'Javier	Hughes'	=> 2017,
    'Jim	Ferguson' => 2016,
    'Brandy	Zocco'=> 2013,
    'Carroll Maldonado'	=> 2019
};


for (Integer year : gymMembers.values()) {
    //loop through years
    if (year <= 2015) {
        System.debug('This is a gold member');
    } else if (year >= 2016 && year <= 2018) {
        System.debug('THis is a silver member');
    } else {
        System.debug('this is a bronze member');
    }
}

//Write a program that given a secretNumber, prints out the Account's Name and secretNumber.
//Challenge: Loop through the Map and if the Account Name ends in an odd number, remove it from the Map.

Map<Integer, String> secretLog = new Map<Integer, String>{
    1 => 'I',
    2 => 'Am',
    3 => 'Creating',
    3 => 'A',
    4 => 'Secret',
    5 => 'List',
    6 => 'Of',
    7 => 'All',
    8 => 'These',
    9 => 'Accounts',
    10 => 'Period'
};


Integer secret = 5;

for (Integer num : secretLog.keySet()) {
    if(num == secret) {
        System.debug('heres the account: ' + num + ' ' + secretLog.get(num));
    }
}