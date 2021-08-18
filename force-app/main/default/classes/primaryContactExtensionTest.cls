/**
 * File:        primaryContactExtensionTest.cls
 * Project:     PracticalExercise1
 * Date:        August 13, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description: Contains tests for primaryContactExtension.cls
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 13, 2021      Can Yavuzkurt                        Created
 * August 18, 2021      Can Yavuzkurt                        Updated the format
 */
@IsTest
private with sharing class primaryContactExtensionTest {

    private static primaryContactExtension ext;

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Creates the test data
     * @name initData
    */
    private static void initData(String actionToDo){

        switch on actionToDo {

            when 'Test With Contact' {

                Account accWithContact = new Account(Name='Test w/ Contact');
                insert accWithContact;

                List<Contact> testContacts = new List<Contact>();
                for (Integer i = 0; i < 500; i++) {
                    
                    testContacts.add(new Contact(LastName='primcontacttest'+i, Salutation='Ms.', AccountId=accWithContact.Id));
                }
                testContacts[0].Is_Primary_Contact__c = true;
                
                insert testContacts;

                PageReference testPage = Page.AccountPrimaryContactsPage; 
                Test.setCurrentPage(testPage);
                testPage.getParameters().put('Id', String.valueOf(accWithContact.Id));

                ApexPages.StandardController sc = new  ApexPages.StandardController(accWithContact);
                ext = new primaryContactExtension(sc);
                ext.primContactId = testContacts[100].Id;

            }
            when 'Test No Contact' {

                Account accWithoutContact = new Account(Name='Test No Contact');
                insert accWithoutContact;

                Contact someContact = new Contact(LastName='throwaway');
                insert someContact;

                PageReference testPage = Page.AccountPrimaryContactsPage; 
                Test.setCurrentPage(testPage);
                testPage.getParameters().put('Id', String.valueOf(accWithoutContact.Id));

                ApexPages.StandardController sc = new  ApexPages.StandardController(accWithoutContact);
                ext = new primaryContactExtension(sc);
                ext.primContactId = someContact.Id;

            }
        }
    }

    /**
     * @author Can Yavuzkurt
     * @date August 13, 2021
     * @description Tests whether the given contact belongs to the account exception
     * @name testContactDoesntBelong
    */
    @IsTest
    static void testContactDoesntBelong(){

        initData('Test No Contact');
        
        Test.startTest();
        IllegalArgumentException thrown;
        try {
            
            ext.setPrimaryContact();
        } catch (IllegalArgumentException e) {
           
            thrown = e;
        }
        Test.stopTest();

        System.assertEquals('Given contact does not belong to this account.', thrown.getMessage());
    }

    /**
     * @author Can Yavuzkurt
     * @date August 13, 2021
     * @description Tests whether the given contact exist exception
     * @name testContactDoesntExist
    */
    @IsTest
    static void testContactDoesntExist(){

        initData('Test With Contact');

        ext.primContactId = 'SOMERANDOMTXT';
        
        NoSuchElementException thrown;
        Test.startTest();
        try {
            
            ext.setPrimaryContact();
        } catch (NoSuchElementException e) {
            
            thrown = e;
        }
        Test.stopTest();
        
        System.assertEquals('No contact exist with the given id.', thrown.getMessage());
    }

    /**
     * @author Can Yavuzkurt
     * @date August 13, 2021
     * @description Tests whether the primary contact is set accordingly.
     * @name testPrimContactSet
    */
    @IsTest
    static void testPrimContactSet(){
        
        initData('Test With Contact');
        
        Test.startTest();
        ext.setPrimaryContact();
        Test.stopTest();
        
        for (Contact contact : [SELECT Id, Is_Primary_Contact__c FROM Contact WHERE LastName LIKE 'primcontacttest%']) {
            
            if (contact.Id != ext.primContactId) {
                
                System.assertEquals(false, contact.Is_Primary_Contact__c);
            }
            else {
                
                System.assertEquals(true, contact.Is_Primary_Contact__c);
            }
        }
        
    }

    /**
     * @author Can Yavuzkurt
     * @date August 13, 2021
     * @description Tests the search functionality
     * @name testGetRelatedContacts
    */
    @IsTest
    static void testGetRelatedContacts(){

        initData('Test With Contact');

        ext.searchVar = 'primcontacttest10';
        
        Test.startTest();
        List<Contact> results = ext.getRelatedContacts();
        Test.stopTest();

        System.assertEquals(11, results.size());
        
    }
}
