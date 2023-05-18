//
//  ViewController.swift
//  The Weather App
//
//  Created by Tanyeli sargut on 5/16/23.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.delegate = self
        
                
                weatherManager.delegate = self
                weatherManager.fetchWeather()
                weatherManager.fetchIcons()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
       
    }
    
}

//MARK: - WeatherManagerDelegate

    extension ViewController: WeatherManagerDelegate {
        
        
        
        func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            
            let convertedToFahrenheit = ((Double(weather.temperatureString)! - 273.15) * 9 / 5) + 32
            let ceiledTemp = ceil(convertedToFahrenheit)
            
            DispatchQueue.main.async {
                self.temperatureLabel.text = "\(ceiledTemp) °F"
                
                self.cityLabel.text = weather.cityName
                
                // Create URL
                    let url = URL(string: "https://openweathermap.org/img/wn/\(weather.theIconName)@2x.png")!

                    DispatchQueue.global().async {
                        // Fetch Image Data
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                // Create Image and Update Image View
                                self.conditionImageView.image = UIImage(data: data)
                            }
                        }
                    }
            }
        }
        
        func didFailWithError(error: Error) {
            print(error)
        }
    }

//MARK: - SearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        weatherManager.fetchWeather(cityName: searchText)
    }
    
    
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButton(_ sender: Any) {
        locationManager.requestLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



