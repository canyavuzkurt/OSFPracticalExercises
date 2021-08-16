@IsTest
public with sharing class primaryContactExtensionTest {

    // Since testing controller extension requires boilerplate code,
    // this helper function reduces code repetition
    static private primaryContactExtension getObjToTest(String accountName) {

        Account acc = [SELECT Id, (SELECT Id, AccountId FROM Account.Contacts) FROM Account WHERE Name=:accountName LIMIT 1];
        PageReference testPage = Page.AccountPrimaryContactsPage; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', String.valueOf(acc.Id));

        ApexPages.StandardController sc = new  ApexPages.StandardController(acc);
        return new primaryContactExtension(sc);
    }

    @TestSetup
    static void makeData(){

        List<Account> testAccounts = new List<Account>();
        Account act = new Account(Name='Test w/ Contact');
        testAccounts.add(act);
        testAccounts.add(new Account(Name='Test No Contact'));

        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 500; i++) {
            
            testContacts.add(new Contact(LastName='primcontacttest'+i, Salutation='Ms.', AccountId=act.Id));
        }
        testContacts[0].Is_Primary_Contact__c = true;
        
        insert testContacts;
    }

    @IsTest
    static void testContactDoesntBelong(){

        // Setup
        primaryContactExtension ext = getObjToTest('Test No Contact');

        Contact contact = [SELECT Id, AccountId FROM Contact WHERE LastName='primcontacttest100' LIMIT 1];
        ext.primContactId = contact.Id;
        
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

    @IsTest
    static void testContactDoesntExist(){

        primaryContactExtension ext = getObjToTest('Test w/ Contact');

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

    @IsTest
    static void testPrimContactSet(){
        
        primaryContactExtension ext = getObjToTest('Test w/ Contact');

        Contact primContact = [SELECT Id, AccountId, Is_Primary_Contact__c FROM Contact WHERE LastName='primcontacttest100' LIMIT 1];

        ext.primContactId = primContact.Id;
        
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

    @IsTest
    static void testGetRelatedContacts(){

        primaryContactExtension ext = getObjToTest('Test w/ Contact');

        ext.searchVar = 'primcontacttest';
        
        Test.startTest();
        List<Contact> results = ext.getRelatedContacts();
        Test.stopTest();

        System.assertEquals(500, results.size());
        
    }
}
