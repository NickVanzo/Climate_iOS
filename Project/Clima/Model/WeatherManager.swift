//
//  WeatherManager.swift
//  Clima
//
//  Created by Nick on 01/02/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol  WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6569ab2920c5ec56780dae829b0970c0&units=metric"
    
    func fetchWeather(cityName: String)
    {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1 - Create a URL
        if let url = URL(string: urlString) {
            // 2 - Create a URL session (thing that can perform networking)
            let session = URLSession(configuration: .default)
            // 3 - give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    
                    // Let's parse the safeData
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self ,weather: weather)
                    }
                }
            }
            // 4 - Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        //We use self in WeatherData.self because it's a type
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherId = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let name = decodedData.name
            let weatherObj = WeatherModel(conditionId: weatherId, cityName: name, temperature: temperature)
            return weatherObj
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
