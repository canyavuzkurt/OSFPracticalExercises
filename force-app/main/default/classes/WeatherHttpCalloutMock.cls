/**
 * File:        WeatherHttpCalloutMock.cls
 * Project:     OSFPracticalExercises
 * Date:        August 19, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description: Callout Mock to be used for testing OpenWeatherChecker.cls
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 19, 2021      Can Yavuzkurt                        Created
 */
@IsTest
global class WeatherHttpCalloutMock implements HttpCalloutMock {
    
    /**
     * @author Can Yavuzkurt
     * @date August 19, 2021
     * @description Implementation of respond func from HttpCalloutMock
     * @name respond
     * @param request HTTPRequest request to respond
    */
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(
        '{'+
        '    \"coord\": {'+
        '        \"lon\": 27.0923,'+
        '        \"lat\": 38.4622'+
        '    },'+
        '    \"weather\": ['+
        '        {'+
        '            \"id\": 800,'+
        '            \"main\": \"Clear\",'+
        '            \"description\": \"clear sky\",'+
        '            \"icon\": \"01d\"'+
        '        }'+
        '    ],'+
        '    \"base\": \"stations\",'+
        '    \"main\": {'+
        '        \"temp\": 305.12,'+
        '        \"feels_like\": 304.88,'+
        '        \"temp_min\": 305.12,'+
        '        \"temp_max\": 306.88,'+
        '        \"pressure\": 1008,'+
        '        \"humidity\": 37'+
        '    },'+
        '    \"visibility\": 10000,'+
        '    \"wind\": {'+
        '        \"speed\": 6.17,'+
        '        \"deg\": 30'+
        '    },'+
        '    \"clouds\": {'+
        '        \"all\": 0'+
        '    },'+
        '    \"dt\": 1629365728,'+
        '    \"sys\": {'+
        '        \"type\": 1,'+
        '        \"id\": 6979,'+
        '        \"country\": \"TR\",'+
        '        \"sunrise\": 1629343778,'+
        '        \"sunset\": 1629392473'+
        '    },'+
        '    \"timezone\": 10800,'+
        '    \"id\": 311044,'+
        '    \"name\": \"İzmir\",'+
        '    \"cod\": 200'+
        '}');
        response.setStatusCode(200);
        return response;       
    }
}