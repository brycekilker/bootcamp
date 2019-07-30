//Before a Contact is created, print out 'Before creating a Contact: '
// After a Contact is created, print out 'After creating a Contact: '
// Before a Contact is updated, print out 'Before editing a Contact: '
// After a Contact is update, print out 'After editing a Contact: '

// Check the Developer Console log to ensure that all statements are being printed out as and when expected.
// Update the printed statements (after the ":") to include the record Id of the Contacts
// in the trigger. Create a new Contact. Make an update to the Contact. Are the results as you expected?

// - Update your code so that each time a Contact record is updated, the Birthdate field is increased by 1 day.
// - Update the printed statements so that upon editing the Email field on the Contact, both the previous and the new value are printed. Test.
// - Create a custom field on the Account object called Number Of Contacts. 
// - Update your code so that whenever a Contact is created, the Number of Contacts field on the Account is increased by one
// Create a custom field on the Account object called Number Of Contacts. Update your code
// so that whenever a Contact is created, the Number of Contacts field on the Account is increased by 1.

trigger ContactTrigger on Contact (before insert, after insert, before update, after update) {
   
   //before insert
    if (Trigger.isBefore && Trigger.isInsert) {
        for (Contact contactRecord : Trigger.new) {
             System.debug('this is the contact being created ');
         }
        System.debug('Before Editing a contact');

    } 

    //after insert
    if (Trigger.isAfter && Trigger.isInsert) {
            //im stuck on this. might have to use SOQL
        for(Contact contactRecord: Trigger.new) {
            if(contactRecord.Number_Of_Contacts != null) {
                contactRecord.Number_Of_Contacts = contactRecord.Number_Of_Contacts++;
                System.debug('number of contacts ' + contactRecord.Number_Of_Contacts);
            }
        }
       
    } 

    //before update
     if (Trigger.isBefore && Trigger.isUpdate) {
         for (Contact contactRecord : Trigger.new) {
             System.debug('this is the new contact Id ' + contactRecord.Id);

             if (contactRecord.Birthdate != null) {
                    contactRecord.Birthdate = contactRecord.BirthDate.addDays(1);
             }
              
         }
        System.debug('Before Editing a contact');
    } 
    
    //after update
    if (Trigger.isAfter && Trigger.isUpdate) {
        for (Contact contactRecord : Trigger.new) {
             System.debug('this is the old contact Id ' + contactRecord.Id);
             String oldContactEmail = Trigger.oldMap.get(contactRecord.Id).Email;

             if(contactRecord.Email != oldContactEmail) {
                 System.debug('the email was updated ' + contactRecord.Email + 'and ' + oldContactEmail);
             }
         }
    }
}