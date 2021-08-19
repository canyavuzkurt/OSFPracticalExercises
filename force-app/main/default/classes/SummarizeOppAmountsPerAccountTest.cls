/**
 * File:        SummarizeOppAmountsPerAccountTest.cls
 * Project:     OSFPracticalExercises
 * Date:        August 18, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description: Contains tests for SummarizeOppAmountsPerAccount.cls
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 18, 2021      Can Yavuzkurt                        Created
 */
@IsTest
private with sharing class SummarizeOppAmountsPerAccountTest {

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Creates the test data
     * @name initData
    */
    private static void initData(){

        Account acc = new Account(Name='BatchTestAcc');
        insert acc;

        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 20; i++) {

            opps.add(new Opportunity(Name='opp'+i, StageName='Open', Amount=1500.0, AccountId=acc.Id, CloseDate=Date.newInstance(2021, 8, 6)));
        }
        insert opps;

        insert new Contact(LastName='testprimarycontact', AccountId=acc.Id, Email='batchtestprimmail@testmail.test', Is_Primary_Contact__c=true);
    }

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Tests whether the batch job executes
     * @name testBatchExecutes
    */
    @IsTest
    static void testBatchExecutes(){

        initData();
        
        Test.startTest();
        SummarizeOppAmountsPerAccount batch = new SummarizeOppAmountsPerAccount();
        Id batchId = Database.executeBatch(batch);     
        Test.stopTest();

        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :batchId];

        System.assertEquals('Completed', job.Status);
        
    }
}
