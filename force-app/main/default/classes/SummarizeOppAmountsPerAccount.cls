/**
 * File:        SummarizeOppAmountsPerAccount.cls
 * Project:     OSFPracticalExercises
 * Date:        August 17, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description: Batch class that summarizes CLosed Won, Open, Closed Lost
 *              Opportunities per Account and sends the result as email. 
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 18, 2021      Can Yavuzkurt                        Created
 */
public class SummarizeOppAmountsPerAccount implements Database.Batchable<sObject>, Database.Stateful {

    private Map<Id, Map<String,Decimal>> accountOpportunities = new Map<Id, Map<String,Decimal>>();
    private List<String> stages = new List<String>();

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Defines the scope of the batch
     * @name start
     * @param bc Database.BatchableContext batch context
    */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        stages.add('Closed Won');
        stages.add('Open');
        stages.add('Closed Lost');
        return Database.getQueryLocator(
            'SELECT Id, Account.Name, AccountId, Amount, StageName FROM Opportunity'
        );
    }

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Summarizes the opportunity amounts per Account per StageName
     * @name execute
     * @param bc Database.BatchableContext batch context
     * @param records List<Opportunity> List of records to process
    */
    public void execute(Database.BatchableContext bc, List<Opportunity> records){
        // process each batch of records
        for (Opportunity opp : records) {
            
            if (accountOpportunities.get(opp.AccountId) == null) {
                
                accountOpportunities.put(opp.AccountId, new Map<String, Decimal>());
            }

            Map<String, Decimal> stageAmountMap = accountOpportunities.get(opp.AccountId);

            
            String stage = opp.StageName;
            if (stageAmountMap.get(stage) == null) {
                
                stageAmountMap.put(stage, opp.Amount);
            }
            else {
                
                stageAmountMap.put(stage, stageAmountMap.get(stage) + opp.Amount);
            }
            
        }
    }

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Creates and sends emails to all primary contacts with
     *              the summarized opportunity amounts.
     * @name finish
     * @param bc Database.BatchableContext batch context
    */
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        List<Contact> primContacts;
        try {
            
            primContacts = [SELECT Id, Email, AccountId, Account.Name FROM Contact WHERE Is_Primary_Contact__c=true];
        } catch (QueryException e) {
            
            throw new HandledException(System.Label.Query_Error);
        }

        for (Contact primContact : primContacts) {
            
            String body = '<h4>Belows is a table of opportunities related to the acount: ' + primContact.Account.Name + '.</h4>';
            body += '<table style="border-collapse: collapse; width: 78.9705%; height: 54px;" border="1">' + 
                    '<tbody>' +
                    '<tr style="height: 18px;">' +
                    '<td style="width: 33.3333%; height: 18px; text-align: center;"><strong>Account</strong></td>' +
                    '<td style="width: 17.2011%; height: 18px; text-align: center;"><strong>Stage</strong></td>' +
                    '<td style="width: 27.6845%; height: 18px; text-align: center;"><strong>Amount</strong></td>' +
                    '</tr>';

            Map<String, Decimal> summarizedOpp = accountOpportunities.get(primContact.AccountId);
            if (summarizedOpp==null) {
                
                continue;
            }
            for (String stage : stages) {

                Decimal amount = summarizedOpp.get(stage);
                String amountStr = '';
                if (amount != null) {
                    
                    amountStr = '€' + String.valueOf(amount);
                }
                
                body += '<tr style="height: 18px;">' +
                        '<td style="width: 33.3333%; height: 18px; text-align: left;">' + primContact.Account.Name + '</td>' +
                        '<td style="width: 17.2011%; height: 18px; text-align: left;">' + stage + '</td>' +
                        '<td style="width: 27.6845%; height: 18px; text-align: left;">' + amountStr + '</td>' +
                        '</tr>';
            }

            body += '</tbody>' + 
                    '</table>';
            
            System.debug(primContact.Email);
            System.debug(body);
        }

    }
}