@isTest 
public with sharing class AccountTriggerHandlerTest {


    @isTest static void updateAccountTest(){

        Account parentAccount = new Account();
        parentAccount.Name = 'Parent';
        parentAccount.SLA__c =  'Gold';   
        parentAccount.Sic = 'Test';
        parentAccount.Industry = 'Agriculture';
        parentAccount.CustomerPriority__c = 'High';
        parentAccount.SLAExpirationDate__c = Date.today();
        
        insert parentAccount;

        Account updatedParentAccount = [
            SELECT Id
            FROM Account
            Limit 1
        ];

        Account newAccount = new Account();
        newAccount.name = 'testAcccount';
        newAccount.Active__c = 'No';
        newAccount.ParentId = updatedParentAccount.Id;

        insert newAccount;


        Account updatedAccount = [
            SELECT Id, NumberofLocations__c, Active__c
            FROM Account
            WHERE Name = 'Test Account'
            LIMIT 1
        ];

        update updatedAccount;

        System.assertEquals(1, updatedAccount.NumberofLocations__c,  'Error: Locations are not equal');
        System.assert(updatedAccount.SLA__c == 'Gold' + 'this is an error');
    }
}
