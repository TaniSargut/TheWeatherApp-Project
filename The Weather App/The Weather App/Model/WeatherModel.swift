//
//  WeatherModel.swift
//  The Weather App
//
//  Created by Tanyeli sargut on 5/16/23.
//

import Foundation

    
struct WeatherModel {
        let conditionId: Int
        let cityName: String
        let temperature: Double
        let theIconName: String
        
        var temperatureString: String {
            return String(format: "%.1f", temperature)
        }
        
    }

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
    let icon: String
}
    

