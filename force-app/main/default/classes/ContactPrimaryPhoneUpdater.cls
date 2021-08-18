/**
 * File:        ContactPrimaryPhoneUpdater.cls
 * Project:     PracticalExercise2
 * Date:        August 17, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description:  Contains async method for PrimaryContactPhoneTrigger.cls
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 17, 2021      Can Yavuzkurt                        Created
 * August 18, 2021      Can Yavuzkurt                        Added missing try/catch block
 */
global with sharing class ContactPrimaryPhoneUpdater {
    
    /**
     * @author Can Yavuzkurt
     * @date August 17, 2021
     * @description Async method that updates all the contacts belonging to given account's Primary_Contact_Phone field 
     * @name updatePrimaryPhoneOfAccount
    */
    @future
    public static void updatePrimaryPhoneOfAccount(Map<Id, String> accPrimPhoneMap) {

        List<Contact> contacts;
        try {
            
            contacts = [Select Id, AccountId, Primary_Contact_Phone__c from Contact Where AccountId IN :accPrimPhoneMap.keySet()];
        } catch (QueryException e) {
            
            throw new HandledException(System.Label.Query_Error);
        } 
        
        for (Contact cnt : contacts) {
            
            cnt.Primary_Contact_Phone__c = accPrimPhoneMap.get(cnt.AccountId);
        }

        try {

            Database.update(contacts, false); 
        } catch (DmlException e) {
            
            throw new HandledException(System.Label.Update_Error);
        }
  }
}
