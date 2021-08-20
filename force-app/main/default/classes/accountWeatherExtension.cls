/**
 * File:        accountWeatherExtension.cls
 * Project:     OSFPracticalExercises
 * Date:        August 20, 2021
 * Created By:  Can Yavuzkurt
 * *************************************************************************
 * Description:  Extension for Standard Account Controller that provides
 *               Weather information
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * August 20, 2021      Can Yavuzkurt                        Created
 */
public with sharing class accountWeatherExtension {

    private final Account acc;
    private CurrentWeatherWrapper wrapper;

    /**
     * @author Can Yavuzkurt
     * @date August 20, 2021
     * @description Constructor of class to initialze StandardController and acc
     * @name accountWeatherExtension
     * @param ApexPages.StandardController stdController
    */
    public accountWeatherExtension(ApexPages.StandardController stdController) {

        this.acc = (Account)stdController.getRecord();
        updateWeather();
    }

    /**
     * @author Can Yavuzkurt
     * @date August 20, 2021
     * @description Updates the weather info    
     * @name updateWeather
    */
    public void updateWeather() {

        this.wrapper = OpenWeatherChecker.checkCurrentCondition(acc.BillingCity);
    }

    /**
     * @author Can Yavuzkurt
     * @date August 20, 2021
     * @description Gets the weather description of account's billing city   
     * @name getWeatherDescription
    */
    public String getWeatherDescription () {

        return this.wrapper.weather.get(0).description;
    }

    /**
     * @author Can Yavuzkurt
     * @date August 20, 2021
     * @description Gets the temperature of account's billing city 
     * @name getTemperature
    */
    public String getTemperature() {

        return String.valueOf(this.wrapper.main.temp);
    }

    /**
     * @author Can Yavuzkurt
     * @date August 20, 2021
     * @description Gets the current weathers icon url of account's billing city
     * @name getWeatherIconUrl
    */
    public String getWeatherIconUrl() {

        return 'http://openweathermap.org/img/wn/' + this.wrapper.weather.get(0).icon + '.png';
    }
}
