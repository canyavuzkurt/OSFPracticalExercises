public with sharing class primaryContactExtension {

    private final Account acct;
    public String searchVar{get; set;}

    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public primaryContactExtension(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord(); 
    }

    public void search() {

    }

    public List<Contact> getRelatedContacts() {
        if (searchVar == null || searchVar == '') {
            return [SELECT Id, Name, Title, Phone, Is_Primary_Contact__c FROM Contact WHERE AccountId=:acct.Id Limit 1000];
        }
        else {
            String escapedString = string.escapeSingleQuotes(searchVar);
            escapedString = '%' + escapedString + '%';
            return [SELECT Id, Name, Title, Phone, Is_Primary_Contact__c FROM Contact WHERE AccountId=:acct.Id AND Name like :escapedString Limit 1000];
        }
    }
}
