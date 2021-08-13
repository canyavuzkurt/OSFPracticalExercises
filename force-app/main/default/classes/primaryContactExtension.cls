public with sharing class primaryContactExtension {

    private final Account acct;
    public String searchVar{get; set;}
    public boolean displayPopup{get; set;}
    public String primContactId{get; set;}

    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public primaryContactExtension(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord(); 
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

    public void setPrimaryContact() {
        closePopup();
        Contact primContact = getPrimContact();

        // Retrieve and update the related contacts accordingly.
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact contact : [SELECT Id, Is_Primary_Contact__c FROM Contact WHERE AccountId=:acct.Id AND Is_Primary_Contact__c=true]) {
                contact.Is_Primary_Contact__c = false;
                contactsToUpdate.add(contact);
            
        }
        primContact.Is_Primary_Contact__c = true;
        contactsToUpdate.add(primContact);

        update contactsToUpdate;

    }

    // Check possible exceptions while retrieving new primary contact.
    private Contact getPrimContact() {
        Contact primContact = null;
        try {
            primContact = [SELECT Id, AccountId, Is_Primary_Contact__c FROM Contact WHERE Id=:primContactId LIMIT 1];

        } catch (QueryException e) {

            throw new NoSuchElementException('No contact exist with the given id.');
        }
        
        if (primContact.AccountId != acct.Id) {
            throw new IllegalArgumentException('Given contact does not belong to this account.');

        }

        return primContact;
    }

    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
}
