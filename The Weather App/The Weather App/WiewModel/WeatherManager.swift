//
//  WeatherManager.swift
//  The Weather App
//
//  Created by Tanyeli sargut on 5/16/23.
//

import Foundation
import CoreLocation



protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=304b79c83c034546b5689fe042ff6c2e"
    let iconURL = "https://openweathermap.org/img/wn/10d@2x.png"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=304b79c83c034546b5689fe042ff6c2e"
        performRequest(with: urlString)
    }
    
    func fetchWeather() {
        performRequest(with: weatherURL)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    self?.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self?.parseJSON(safeData) {
                        self?.delegate?.didUpdateWeather(self!, weather: weather)
                        
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let icon = decodedData.weather[0].icon
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, theIconName: icon)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func fetchIcons() {
        
     performRequest(with: iconURL)
        
    }
    
    
    
}
