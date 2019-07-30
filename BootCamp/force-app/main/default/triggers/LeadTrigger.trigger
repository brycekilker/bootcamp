trigger LeadTrigger on Lead (before insert, after insert, before update, after update, before delete, after delete, after undelete) {


System.debug('******************** TRIGGER START ********************');
 System.debug('**** TRIGGER - DML OPERATION ****');
 System.debug('Trigger.isInsert: ' + Trigger.isInsert);
 System.debug('Trigger.isUpdate: ' + Trigger.isUpdate);
 System.debug('Trigger.isDelete: ' + Trigger.isDelete);
 System.debug('Trigger.isUndelete: ' + Trigger.isUndelete);
 System.debug('**** TRIGGER - DML TIMING (BEFORE vs AFTER) ****');
 System.debug('Trigger.isBefore: ' + Trigger.isBefore);
 System.debug('Trigger.isAfter: ' + Trigger.isAfter);
 System.debug('**** TRIGGER - RECORD DATA ****');
 System.debug('Trigger.new: ' + Trigger.new);
 System.debug('Trigger.newMap: ' + Trigger.newMap);
 System.debug('Trigger.old: ' + Trigger.old);
 System.debug('Trigger.oldMap: ' + Trigger.oldMap);
}