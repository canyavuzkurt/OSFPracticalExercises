/**
 * File:        PrimaryContactPhoneTrigger.trigger
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
 * August 17, 2021      Can Yavuzkurt                        Started using async method
 * August 18, 2021      Can Yavuzkurt                        Now fires when primary contacts phone is updated
 */
trigger PrimaryContactPhoneTrigger on Contact (after insert, after update) {

    Map<Id, String> accountIdPhoneMap = new Map<Id, String>();
    for ( Contact newPrimaryContact : Trigger.new) {
        
        // If new primary contact is inserted OR either the Is_Primary_Contact__c or the Phone field is updated.
        if (newPrimaryContact.Is_Primary_Contact__c && 
            (Trigger.isInsert || 
            (Trigger.isUpdate && (Trigger.oldMap.get(newPrimaryContact.Id).Is_Primary_Contact__c != newPrimaryContact.Is_Primary_Contact__c ||
                                  Trigger.oldMap.get(newPrimaryContact.Id).Phone != newPrimaryContact.Phone)))) {
            
            accountIdPhoneMap.put(newPrimaryContact.AccountId, newPrimaryContact.Phone);

        }
        
    }

    if (accountIdPhoneMap.size() != 0) {

        ContactPrimaryPhoneUpdater.updatePrimaryPhoneOfAccount(accountIdPhoneMap);
    }

}