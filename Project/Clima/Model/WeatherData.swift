//
//  WeatherData.swift
//  Clima
//
//  Created by Nick on 02/02/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

// When we jSON something the structure must conform to Decodable protocol
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coordinates
}

struct Coordinates: Codable {
    let lon: Float
    let lat: Float
}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}
