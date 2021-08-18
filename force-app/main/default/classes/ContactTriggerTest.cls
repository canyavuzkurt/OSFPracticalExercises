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
 * August 18, 2021      Can Yavuzkurt                        Updated the format and renamed
 */
@isTest
private class ContactTriggerTest {

    private static Contact contactToUpdate;
    private static Account testAcc;
    private static List<Contact> contacts;

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Creates the test data
     * @name initData
    */
    private static void initData(String actionToDo){

        switch on actionToDo {

            when 'Test With Primary' {

                testAcc = new Account(Name='Test Account W/ Primary');
                insert testAcc;

                insert new Contact(LastName='Primary', AccountId=testAcc.Id, Is_Primary_Contact__c=true);
            }
            when 'Test No Primary' {

                testAcc = new Account(Name='Test Account');
                insert testAcc;

                contacts = new List<Contact>();
                for (Integer i = 0; i < 20; i++){

                    contacts.add(new Contact(LastName='primarytriggertest'+i, AccountId=testAcc.Id, Phone=String.valueOf(i)));
                }
                insert contacts;
                
                contactToUpdate = [SELECT Id, Phone, Is_Primary_Contact__c FROM Contact WHERE LastName='primarytriggertest0' LIMIT 1];
                contactToUpdate.Is_Primary_Contact__c = true;
            }
        }
    }
    
    /**
     * @author Can Yavuzkurt
     * @date August 16, 2021
     * @description Test for Validating Is_Primary_Contact field of Contact object
     * @name testPrimaryValidateTrigger
    */
    @IsTest
    static void testPrimaryValidateTrigger(){

        initData('Test With Primary');
        
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

        initData('Test No Primary');

        Test.startTest();
        Database.SaveResult result = Database.update(contactToUpdate);
        Test.stopTest();

        System.assert(result.isSuccess());
        Integer size = [SELECT Id FROM Contact WHERE LastName LIKE 'primarytriggertest%' AND Primary_Contact_Phone__c='0'].size();
        System.assert(20 == size, 'actual size:' + size);
        
    }
}
