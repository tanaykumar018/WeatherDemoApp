//
//  WeatherViewModel.swift
//  WeatherDemoApp
//
//  Created by Tanay Kumar Roy on 8/16/24.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cityName: String = ""
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = ""
    @Published var weatherIconURL: String = ""
    @Published var locationEnabled: Bool = false
    
    private let weatherService = WeatherService()
    private var locationManager: CLLocationManager?

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        loadLastCity()
    }

    func fetchWeather(for city: String) {
        weatherService.fetchWeather(for: city) { [weak self] result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self?.cityName = weather.name
                    self?.temperature = "\(Int(weather.main.temp))°F"
                    self?.weatherDescription = weather.weather.first?.description.capitalized ?? ""
                    self?.weatherIconURL = "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "01d")@2x.png"
                    self?.saveLastCity(city)
                }
            case .failure(let error):
                print("Error fetching weather: \(error)")
            }
        }
    }

    func requestLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }

    private func loadLastCity() {
        if let lastCity = UserDefaults.standard.string(forKey: "LastCity") {
            fetchWeather(for: lastCity)
        }
    }

    private func saveLastCity(_ city: String) {
        UserDefaults.standard.setValue(city, forKey: "LastCity")
    }

    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        print("location == \(lat) , \(lon)")
        weatherService.fetchWeatherByCoordinates(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self?.cityName = weather.name
                    self?.temperature = "\(Int(weather.main.temp))°F"
                    self?.weatherDescription = weather.weather.first?.description.capitalized ?? ""
                    self?.weatherIconURL = "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "01d")@2x.png"
                }
            case .failure(let error):
                print("Error fetching weather: \(error)")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.requestLocation()
            locationEnabled = true
        } else {
            locationEnabled = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestLocation()
        } else {
            print("Location services are not enabled.")
        }
    }
}

