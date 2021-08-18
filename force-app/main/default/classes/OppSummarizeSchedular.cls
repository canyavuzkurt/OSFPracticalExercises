/**
 * File:        OppSummarizeSchedular.cls
 * Project:     OSFPracticalExercises
 * Date:        August 18, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description: Schedules SummarizeOppAmountsPerAccount Batch job
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 18, 2021      Can Yavuzkurt                        Created
 */
global class OppSummarizeSchedular implements Schedulable{

    public static String dailySched = '0 0 10 1/1 * ? *';  //Every Day 10:00AM
    public static String weeklySched = '0 0 13 ? * FRI *'; //once a week (Friday at 1:00 PM)
    public static String monthlySched = '0 0 18 ? 1/1 FRI#4 *';  //once a month(Last Friday of the Month at 6:00 PM)

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Schedules the batch job Every Day at 10:00AM
     * @name scheduleDaily
    */
    global static String scheduleDaily() {
        OppSummarizeSchedular SC = new OppSummarizeSchedular(); 
        return System.schedule('Daily Opportunity Summarize', dailySched, SC);
    }

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Schedules the batch job once a week (Friday at 1:00 PM)
     * @name scheduleWeekly
    */
    global static String scheduleWeekly() {
        OppSummarizeSchedular SC = new OppSummarizeSchedular(); 
        return System.schedule('Weekly Opportunity Summarize', weeklySched, SC);
    }

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Schedules the batch job once a month(Last Friday of the Month at 6:00 PM)
     * @name scheduleMonthly
    */
    global static String scheduleMonthly() {
        OppSummarizeSchedular SC = new OppSummarizeSchedular(); 
        return System.schedule('Monthly Opportunity Summarize', weeklySched, SC);
    }

    /**
     * @author Can Yavuzkurt
     * @date August 18, 2021
     * @description Calls the batch job for execution.
     * @name execute
    */
    global void execute(SchedulableContext sc) {

        SummarizeOppAmountsPerAccount batch = new SummarizeOppAmountsPerAccount();
        Id batchId = Database.executeBatch(batch);          
    }
}