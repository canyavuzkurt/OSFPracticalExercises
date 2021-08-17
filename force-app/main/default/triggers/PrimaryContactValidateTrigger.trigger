/**
 * File:        PrimaryContactValidateTrigger.trigger
 * Project:     PracticalExercise2
 * Date:        August 16, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description:  after insert/update trigger when a contact is set as primary, 
 *               updates related contacts Primary_Contact_Phone field.
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 16, 2021      Can Yavuzkurt                        Created
 */
trigger PrimaryContactValidateTrigger on Contact (before insert, before update) {

    // Get AccountIds of new contacts for query reasons
    List<Id> accountIds = new List<Id>();
    for (Contact contact : Trigger.new) {
        
        accountIds.add(contact.AccountId);
    }

    // Construct AccountId, PrimaryContact pair map
    Map<Id, Contact> primContactMap = new Map<Id, Contact>();
    List<Contact> primContacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds AND Is_Primary_Contact__c = true];
    for (Contact primContact : primContacts) {
        
        primContactMap.put(primContact.AccountId, primContact);
    }

    // Validate 
    for (Contact contact : Trigger.new) {
        
        Contact oldPrimaryContact = primContactMap.get(contact.AccountId);
        if ( contact.Is_Primary_Contact__c && oldPrimaryContact != null && oldPrimaryContact.Id != contact.Id) {

            contact.addError('There is a primary contact associated with the account already.');
        }
    }
    

}