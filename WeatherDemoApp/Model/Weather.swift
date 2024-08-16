//
//  Weather.swift
//  WeatherDemoApp
//
//  Created by Tanay Kumar Roy on 8/16/24.
//

import Foundation

struct Weather: Codable {
    let main: Main
    let weather: [WeatherCondition]
    let name: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
}

