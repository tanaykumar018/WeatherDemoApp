//
//  WeatherService.swift
//  WeatherDemoApp
//
//  Created by Tanay Kumar Roy on 8/16/24.
//

import Foundation

class WeatherService {
    private let apiKey = "484729e0327908580fd90f4c692600e0"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        let parameters: [String: String] = ["q": city, "appid": apiKey, "units": "imperial"]
        guard var urlComponents = URLComponents(string: baseURL) else { return }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping (Result<Weather, Error>) -> Void) {
        let parameters: [String: String] = ["lat": "\(lat)", "lon": "\(lon)", "appid": apiKey, "units": "imperial"]
        guard var urlComponents = URLComponents(string: baseURL) else { return }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

