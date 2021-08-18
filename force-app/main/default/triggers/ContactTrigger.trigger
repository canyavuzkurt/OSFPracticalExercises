/**
 * File:        ContactTrigger.trigger
 * Project:     OSFPracticalExercises
 * Date:        August 18, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description:  Before Trigger validates the primary contact
 *               After Trigger updates Primary_Contact_Phone accordingly
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 18, 2021      Can Yavuzkurt                        Consolidated PhoneTrigger and ValidateTrigger here
 */
trigger ContactTrigger on Contact (before insert, before update, after insert, after update) {

    if (Trigger.isBefore) {
        
        if (Trigger.isInsert || Trigger.isUpdate) {
         
            ContactTriggerHandler.handleBefore(Trigger.new);
        }
    }
    else if (Trigger.isAfter) {

        if (Trigger.isInsert) {
            
            ContactTriggerHandler.handleAfterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {

            ContactTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}