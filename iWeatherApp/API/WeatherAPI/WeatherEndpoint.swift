//
//  Endpoint.swift
//  iWeatherApp
//
//  Created by Michael on 15.02.2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import Foundation

enum WeatherEndpoint: APIEndpoint {
    case currentWeather(city: String)
    case threeDaysForecast(city: String)
    
    var baseURL: String {
        return "https://api.apixu.com"
    }
    
    // API key from APIXU
    var key: String {
        return "5dee1bd97882462aa50135821181902"
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/v1/current.json"
        case .threeDaysForecast:
            return "/v1/forecast.json"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .currentWeather(let city):
            return [URLQueryItem(name: "key", value: key), URLQueryItem(name: "q", value: city)]
        case .threeDaysForecast(let city):
            return [URLQueryItem(name: "key", value: key), URLQueryItem(name: "q", value: city), URLQueryItem(name: "days", value: "3")]
        }
    }
}
