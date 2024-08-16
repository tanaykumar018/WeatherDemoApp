//
//  WeatherSearchView.swift
//  WeatherDemoApp
//
//  Created by Tanay Kumar Roy on 8/16/24.
//

import SwiftUI

struct WeatherSearchView: View {
    @ObservedObject var viewModel = WeatherViewModel()

    var body: some View {
        VStack {
            HStack {
                TextField("Enter City", text: $viewModel.cityName, onCommit: {
                    viewModel.fetchWeather(for: viewModel.cityName)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                Button(action: {
                    viewModel.requestLocation()
                }) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }

            if viewModel.temperature != "--" {
                Text(viewModel.cityName)
                    .font(.largeTitle)
                    .padding(.top)

                Text(viewModel.temperature)
                    .font(.system(size: 72))
                    .bold()
                    .padding(.top)

                Text(viewModel.weatherDescription)
                    .font(.title)
                    .padding(.top)

                if let url = URL(string: viewModel.weatherIconURL) {
                    AsyncImage(url: url)
                        .frame(width: 100, height: 100)
                        .padding(.top)
                }
            } else {
                Text("No Data Available")
                    .font(.title)
                    .padding(.top)
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchWeather(for: viewModel.cityName)
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
        .modifier(AdaptiveViewModifier())
    }
}

