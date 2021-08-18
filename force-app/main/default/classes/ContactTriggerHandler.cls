/**
 * File:        ContractTriggerHandler.trigger
 * Project:     OSFPracticalExercises
 * Date:        August 18, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description: Handles Contact Trigger
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 18, 2021      Can Yavuzkurt                        Consolidated PhoneTrigger and ValidateTrigger here
 */
public with sharing class ContactTriggerHandler {
    
    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Validates contact info before insert/update
     * @name handleBefore
     * @param contacts List<Contact> Trigger.new supplied by the Trigger
    */
    public static void handleBefore(List<Contact> contacts) {

        // Get AccountIds of new contacts for query reasons
        List<Id> accountIds = new List<Id>();
        for (Contact contact : contacts) {
            
            accountIds.add(contact.AccountId);
        }

        // Construct AccountId, PrimaryContact pair map
        Map<Id, Contact> primContactMap = new Map<Id, Contact>();
        List<Contact> primContacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds AND Is_Primary_Contact__c = true];
        for (Contact primContact : primContacts) {
            
            primContactMap.put(primContact.AccountId, primContact);
        }

        // Validate 
        for (Contact contact : contacts) {
            
            Contact oldPrimaryContact = primContactMap.get(contact.AccountId);
            if ( contact.Is_Primary_Contact__c && oldPrimaryContact != null && oldPrimaryContact.Id != contact.Id) {

                contact.addError('There is a primary contact associated with the account already.');
            }
        }
    }

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Updates primary contact phone after insert
     * @name handleAfterInsert
     * @param inserted List<Contact> Trigger.new supplied by the Trigger
    */
    public static void handleAfterInsert(List<Contact> inserted) {

        handleAfterHelper(inserted, null, true);
    }
    
    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Updates primary contact phone after update
     * @name handleAfterUpdate
     * @param updated List<Contact> Trigger.new supplied by the Trigger
     * @param oldMap Map<Id, Contact> Trigger.oldMap supplied by the trigger
    */
    public static void handleAfterUpdate(List<Contact> updated, Map<Id, Contact> oldMap) {

        handleAfterHelper(updated, oldMap, false);
    }
 
    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Updates primary contact phone after insert/update
     * @name handleAfterHelper
     * @param updated List<Contact> Trigger.new supplied by the Trigger
     * @param oldMap Map<Id, Contact> Trigger.oldMap supplied by the trigger
     * @param isInsert Boolean Corresponds to Trigger.isInsert
    */
    private static void handleAfterHelper(List<Contact> contacts, Map<Id, Contact> oldMap, Boolean isInsert) {

    Map<Id, String> accountIdPhoneMap = new Map<Id, String>();
        for ( Contact newPrimaryContact : contacts) {
            
            // If new primary contact is inserted OR either the Is_Primary_Contact__c or the Phone field is updated.
            if (newPrimaryContact.Is_Primary_Contact__c && 
                (isInsert || (oldMap.get(newPrimaryContact.Id).Is_Primary_Contact__c != newPrimaryContact.Is_Primary_Contact__c ||
                              oldMap.get(newPrimaryContact.Id).Phone != newPrimaryContact.Phone))) {
                 
                accountIdPhoneMap.put(newPrimaryContact.AccountId, newPrimaryContact.Phone);
            }
            
        }

        if (accountIdPhoneMap.size() != 0) {

            ContactPrimaryPhoneUpdater.updatePrimaryPhoneOfAccount(accountIdPhoneMap);
        }
    }
}


