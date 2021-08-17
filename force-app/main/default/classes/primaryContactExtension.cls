/**
 * File:        primaryContactExtension.cls
 * Project:     PracticalExercise1
 * Date:        August 13, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description:  Extension for Standard Account Controller that provides popup, search and pagination mechanism.
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 13, 2021      Can Yavuzkurt                        Created
 */
public with sharing class primaryContactExtension {

    private final Account acct;
    public String searchVar{get; set;}
    public boolean displayPopup{get; set;}
    public String primContactId{get; set;}

    /**
     * @author Can Yavuzkurt
     * @date August 13, 2021
     * @description Constructor of class to initialze StandardController and acct
     * @name primaryContactExtension
     * @param ApexPages.StandardController stdController
    */
    public primaryContactExtension(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord(); 
    }

    /**
     * @author Can Yavuzkurt
     * @date August 13, 2021
     * @description Search mechanism that can be used by Visualforce Pages.
     * @name getRelatedContacts
    */
    public List<Contact> getRelatedContacts() {
        try {
            
            if (searchVar == null || searchVar == '') {
            return [SELECT Id, Name, Title, Phone, Is_Primary_Contact__c FROM Contact WHERE AccountId=:acct.Id Limit 1000];
        }
        else {

            String escapedString = string.escapeSingleQuotes(searchVar);
            escapedString = '%' + escapedString + '%';
            return [SELECT Id, Name, Title, Phone, Is_Primary_Contact__c FROM Contact WHERE AccountId=:acct.Id AND Name like :escapedString Limit 1000];
        }
        } catch (QueryException e) {
            
            throw new HandledException(System.Label.Query_Error);
        }
        
    }

    /**
     * @author Can Yavuzkurt
     * @date August 13, 2021
     * @description Sets the current accounts PrimaryContact to given Contact
     * @name setPrimaryContact
    */
    public void setPrimaryContact() {
        closePopup();
        Contact primContact = getPrimContact();

        // Retrieve and update the related contacts accordingly.
        List<Contact> contactsToUpdate = new List<Contact>();
        try {
            
            for (Contact contact : [SELECT Id, Is_Primary_Contact__c FROM Contact WHERE AccountId=:acct.Id AND Is_Primary_Contact__c=true]) {
                    contact.Is_Primary_Contact__c = false;
                    contactsToUpdate.add(contact);
                
            }
        } catch (QueryException e) {
            
            throw new HandledException(System.Label.Query_Error);
        }
        primContact.Is_Primary_Contact__c = true;
        contactsToUpdate.add(primContact);

        try {
            
            update contactsToUpdate;
        } catch (DmlException e) {
            
            throw new HandledException(System.Label.Update_Error);
        }

    }

    // Check possible exceptions while retrieving new primary contact.
    /**
     * @author Can Yavuzkurt
     * @date August 13, 2021
     * @description Helper function that validates the given primary contact.
     * @name getPrimContact
    */
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
