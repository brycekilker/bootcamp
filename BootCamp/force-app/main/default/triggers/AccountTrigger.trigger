//Make sure to add context event in parameters.
trigger AccountTrigger on Account (before insert, before update) {

if (Trigger.isBefore && Trigger.isUpdate) {
    AccountTriggerHandler.beforeInsertMethod(Trigger.new);
}

if (Trigger.isBefore && Trigger.isUpdate) {
    AccountTriggerHandler.beforeInsertMethod(Trigger.new, Trigger.oldMap);
}





// for (Account accountRecord : Trigger.new) {
//     String oldAccountType = Trigger.oldMap.get(AccountRecord.Id).Type;

//     if (accountRecord.Type != oldAccountType) {
//         //do the thing
//     }
    
// }


    // List<Account> accountsToUpdate = new List<Account>();


    // for(Account accountRecord : Trigger.new) {

    //     Account newAccount = new Account(
    //         Id= accountRecord.Id,
    //         AccountNumber = accountRecord.Id
    //     );

    //     accountsToUpdate.add(newAccount);
    // }

    // //null check
    // if (accountsToUpdate.size() > 0) {
    //     update accountsToUpdate;
    // }



    // //this runs the trigger without a SOQL statement
    // for (Account accountRecord : Trigger.new) {
    //     AccountRecord.Type = 'Customer - Direct';
    // }


    // if (Trigger.isBefore && Trigger.isInsert) {
    //     System.debug('Run if before insert');
    // }

    // if (Trigger.isAfter && Trigger.isInsert) {
    //     System.debug('Run if after insert');
    // }

}