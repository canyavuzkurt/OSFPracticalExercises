/**
 * File:        OpenWeatherCheckerTest.cls
 * Project:     OSFPracticalExercises
 * Date:        August 19, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description:  Unit test for OpenWeatherChecker.cls
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 19, 2021      Can Yavuzkurt                        Created
 */
@IsTest
private class OpenWeatherCheckerTest {
    
    /**
     * @author Can Yavuzkurt
     * @date August 19, 2021
     * @description Test success for OpenWeather callout
     * @name testSuccessToRetrieveWeather
    */
    @IsTest
    static void testSuccessToRetrieveWeather() {

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        CurrentWeatherWrapper wrapper = OpenWeatherChecker.checkCurrentCondition('izmir');
        Test.stopTest();
        // Verify that the response received contains fake values
        System.assertEquals('Clear', wrapper.weather.get(0).main);
        System.assertEquals('clear sky', wrapper.weather.get(0).description);
    }

    /**
     * @author Can Yavuzkurt
     * @date August 19, 2021
     * @description Test invalid city name for open weather callout
     * @name testCityNotFound
    */
    @IsTest
    static void testCityNotFound() {

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WeatherNoCityHttpCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        HandledException thrown;
        try {
            
            CurrentWeatherWrapper wrapper = OpenWeatherChecker.checkCurrentCondition('citynotfound');
        } catch (HandledException e) {
            
            thrown = e;
        }
        Test.stopTest();

        System.assertEquals(System.Label.City_Not_Found, thrown.getMessage());
    }

    /**
     * @author Can Yavuzkurt
     * @date August 19, 2021
     * @description Test fail to retrieve weather from OpenWeather callout
     * @name testFailToRetrieveWeather
    */
    @IsTest
    static void testFailToRetrieveWeather() {

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WeatherFailHttpCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        HandledException thrown;
        try {
            
            CurrentWeatherWrapper wrapper = OpenWeatherChecker.checkCurrentCondition('fail');
        } catch (HandledException e) {
            
            thrown = e;
        }
        Test.stopTest();

        System.assertEquals(System.Label.Couldnt_Retrieve_Weather, thrown.getMessage());
    }
}
