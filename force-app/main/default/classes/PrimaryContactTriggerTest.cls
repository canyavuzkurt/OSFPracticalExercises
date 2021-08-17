/**
 * File:        PrimaryContactTriggerTest.cls
 * Project:     PracticalExercise2
 * Date:        August 16, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description:  Unit test for triggers assocaited with primary contacts
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 16, 2021      Can Yavuzkurt                        Created
 */
@isTest
private class PrimaryContactTriggerTest {
    
    /**
     * @author Can Yavuzkurt
     * @date August 16, 2021
     * @description Test for Validating Is_Primary_Contact field of Contact object
     * @name testPrimaryValidateTrigger
    */
    @IsTest
    static void testPrimaryValidateTrigger(){

        Account testAcc = new Account(Name='Test Account W/ Primary');

        insert testAcc;

        insert new Contact(LastName='Primary', AccountId=testAcc.Id, Is_Primary_Contact__c=true);
        
        Test.startTest();
        Database.SaveResult result = Database.insert(new Contact(LastName='Duplicate Primary', AccountId=testAcc.Id, Is_Primary_Contact__c=true), false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assertEquals('There is a primary contact associated with the account already.',
                            result.getErrors()[0].getMessage());
        
    }

    /**
     * @author Can Yavuzkurt
     * @date August 16, 2021
     * @description Test for setting Primary_Contact_Phone of Contact object
     * @name testPrimaryPhoneSetTrigger
    */
    @IsTest
    static void testPrimaryPhoneSetTrigger(){

        Account testAcc = new Account(Name='Test Account');

        insert testAcc;

        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 20; i++){

            contacts.add(new Contact(LastName='primarytriggertest'+i, AccountId=testAcc.Id, Phone=String.valueOf(i)));
        }

        insert contacts;
        
        Contact contact = [SELECT Id, Phone, Is_Primary_Contact__c FROM Contact WHERE LastName='primarytriggertest0' LIMIT 1];
        contact.Is_Primary_Contact__c = true;

        Test.startTest();
        Database.SaveResult result = Database.update(contact);
        Test.stopTest();

        System.assert(result.isSuccess());

        contacts = [SELECT Id, LastName, Primary_Contact_Phone__c, Phone FROM Contact WHERE LastName LIKE 'primarytriggertest%'];
        for (Contact ctc : contacts) {
            
            System.assert(ctc.Primary_Contact_Phone__c == '0', ctc.LastName + ': ' + ctc.Phone + '; ' + ctc.Primary_Contact_Phone__c);
        }
        Integer size = [SELECT Id FROM Contact WHERE LastName LIKE 'primarytriggertest%' AND Primary_Contact_Phone__c='0'].size();
        System.assert(20 == size, 'actual size:' + size);
        
    }
}
