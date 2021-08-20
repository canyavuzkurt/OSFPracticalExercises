/**
 * File:        OpenWeatherChecker.trigger
 * Project:     OSFPracticalExercises
 * Date:        August 19, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description: Invokes OpenWeather to receive weather condition
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 19, 2021      Can Yavuzkurt                        Created
 * August 20, 2021      Can Yavuzkurt                        Updated endpoint url
 */
public with sharing class OpenWeatherChecker {
    
    private static String apiKey = 'cd5155cd5e4a5d3751e0e98a4374bcb4';

    /**
     * @author Can Yavuzkurt
     * @date August 19, 2021
     * @description Retrieves the current weather condition of the given city
     *              from openweathermap.org
     * @name checkCurrentCondition
     * @param cityName String city to retrieve the current condition of
    */
    public static CurrentWeatherWrapper checkCurrentCondition(String cityName) {
        if (cityName == null) {
            
            throw new HandledException('cityName param cannot be null');
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.openweathermap.org/data/2.5/weather?q=' + cityName + '&APPID=' + apiKey);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            return CurrentWeatherWrapper.parse(response.getBody());
        }
        else if (response.getStatusCode() == 404) {
            
            throw new HandledException(System.Label.City_Not_Found);
        }
        else {
            
            throw new HandledException(System.Label.Couldnt_Retrieve_Weather);
        }
    }
}
