public with sharing class primaryContactExtension {

    private final Account acct;

    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public primaryContactExtension(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord(); 
    }

    public List<Contact> getRelatedContacts() {
        return [SELECT Id, Name, Title, Phone, Is_Primary_Contact__c FROM Contact WHERE AccountId=:acct.Id Limit 1000];
    }
}
