//
//  Weather.swift
//  iWeatherApp
//
//  Created by Michael on 15.02.2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import Foundation
import CoreData

class Weather: Codable {
    let current: CurrentWeather
    let forecast: WeatherForecast?
}

class CurrentWeather: Codable {
    let temperature: Float
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp_c"
    }
}

class WeatherForecast: Codable {
    let forecast: [ForecastDay]
    
    private enum CodingKeys: String, CodingKey {
        case forecast = "forecastday"
    }
}

class ForecastDay: Codable {
    let date: Date
    let day: Day
    
    private enum CodingKeys: String, CodingKey {
        case date = "date_epoch"
        case day
    }
}

class Day: Codable {
    let maxTemp: Float
    let minTemp: Float
    let condition: Condition
    
    private enum CodingKeys: String, CodingKey {
        case maxTemp = "maxtemp_c"
        case minTemp = "mintemp_c"
        case condition
    }
}

class Condition: Codable {
    let text: String
}

extension Weather {
    func weatherToCity(withCity city: City) {
        city.date = Date()
        city.currentTemp = current.temperature
        
        guard let weatherForecasts = forecast?.forecast else {
            return
        }
        
        guard let context = city.managedObjectContext else {
            return
        }
        
        var forecasts = [Forecast]()
        for forecast in weatherForecasts {
            let tempForecast = Forecast.init(entity: NSEntityDescription.entity(forEntityName: "Forecast", in: context)!, insertInto: context)
            tempForecast.city = city
            tempForecast.date = forecast.date
            tempForecast.maxTemp = forecast.day.maxTemp
            tempForecast.minTemp = forecast.day.minTemp
            tempForecast.text = forecast.day.condition.text
            
            forecasts.append(tempForecast)
        }
        
        city.forecasts = NSSet(array: forecasts)
    }
}
