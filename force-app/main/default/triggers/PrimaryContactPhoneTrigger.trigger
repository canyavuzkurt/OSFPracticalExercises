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
 */
trigger PrimaryContactPhoneTrigger on Contact (after insert, after update) {

    Map<Id, String> accountIdPhoneMap = new Map<Id, String>();
    for ( Contact newPrimaryContact : Trigger.new) {
        
        if (newPrimaryContact.Is_Primary_Contact__c && 
            (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(newPrimaryContact.Id).Is_Primary_Contact__c != newPrimaryContact.Is_Primary_Contact__c)) ) {
            
            accountIdPhoneMap.put(newPrimaryContact.AccountId, newPrimaryContact.Phone);

        }
        
    }

    if (accountIdPhoneMap.size() != 0) {

        ContactPrimaryPhoneUpdater.updatePrimaryPhoneOfAccount(accountIdPhoneMap);
    }

}