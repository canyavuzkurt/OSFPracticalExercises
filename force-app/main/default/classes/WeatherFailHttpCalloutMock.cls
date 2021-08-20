/**
 * File:        WeatherHttpCalloutMock.cls
 * Project:     OSFPracticalExercises
 * Date:        August 20, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description: Callout Mock to be used for testing OpenWeatherChecker.cls
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 20, 2021      Can Yavuzkurt                        Created
 */
@IsTest
global class WeatherFailHttpCalloutMock implements HttpCalloutMock {
    
    /**
     * @author Can Yavuzkurt
     * @date August 20, 2021
     * @description Implementation of respond func from HttpCalloutMock
     * @name respond
     * @param request HTTPRequest request to respond
    */
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        
        HttpResponse response = new HttpResponse();

        response.setStatusCode(500);
        return response;
        
    }
}