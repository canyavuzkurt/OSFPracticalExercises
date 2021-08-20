
/**
 * File:        accountWeatherExtensionTest.cls
 * Project:     OSFPracticalExercises
 * Date:        August 20, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description: Contains tests for accountWeatherExtension.cls
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 20, 2021      Can Yavuzkurt                        Created
 */
@IsTest
public with sharing class accountWeatherExtensionTest {

    private static ApexPages.StandardController sc;
    
     /**
     * @author Can Yavuzkurt
     * @date August 20, 2021
     * @description Creates the test data
     * @name initData
    */
    private static void initData() {
        
        Account act = new Account(Name='ExtensionTestAcc', BillingCity='izmir');
        insert act;

        sc = new  ApexPages.StandardController(act);
    }

    /**
     * @author Can Yavuzkurt
     * @date August 20, 2021
     * @description Test weather variables of the extension class
     * @name testExtensionVariables
    */
    @IsTest
    static void testExtensionVariables() {

        initData();

        Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock()); 

        Test.startTest();
        accountWeatherExtension ext = new accountWeatherExtension(sc);
        Test.stopTest();

        System.assertEquals('clear sky', ext.getWeatherDescription());
        System.assertEquals('305.12', ext.getTemperature());
        System.assertEquals('http://openweathermap.org/img/wn/01d.png', ext.getWeatherIconUrl());
        
    }
}
