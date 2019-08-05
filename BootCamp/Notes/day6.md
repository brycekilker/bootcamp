## More Triggers and classes
- There is a triggers explained document in week 2
- Trigger.new in an after context is read only!!!

-// This will run BEFORE a record is INSERTED into the database
 if (Trigger.isBefore && Trigger.isInsert) {
 // Loop through all the records that caused this trigger to run (i.e. Contract records that are created)
 for (Contact contact : Trigger.new) {
 // Update the Description field
 contact.Description = 'Updated in the before context';
 }
 
 }
 List<Contact> contactsToUpdate = new List<Contact>();
 // This will run AFTER a record is INSERTED into the database
 if (Trigger.isAfter && Trigger.isInsert) {
 // Loop through all the records that caused this trigger to run, just like we did in the BEFORE context
 for (Contact contact : Trigger.new) {
 // This will FAIL because Trigger.new is READ-ONLY
 contact.Description = 'This will fail!';
 
 // This WORKS, because we are creating a new instance of a Contact using the Id in Trigger.new
 Contact newContact = new Contact();
 newContact.Id = contact.Id;
 newContact.Description = 'This will work!';
 contactsToUpdate.add(newContact);
 System.debug('In the after insert context, we now have a record id: ' + contact.Id);
 
 }
 
 update contactsToUpdate;
 }

 ## Constructors
  - bsically methods without return types that automatically run