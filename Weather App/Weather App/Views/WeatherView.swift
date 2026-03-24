//
//  WeatherView.swift
//  Weather App
//
//  Created by Ron Erez on 11/10/2025.
//

import SwiftUI

struct WeatherView: View {
    @State private var vm = WeatherViewModel()
    
    @AppStorage("useFahrenheit") private var useFahrenheit = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter city name", text: $vm.city)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Button {
                    Task {
                        await vm.fetch()
                    }
                } label: {
                    Label(
                        "Get Weather",
                        systemImage: "cloud.sun.fill"
                    )
                }.buttonStyle(.borderedProminent)
                    .padding()
                    .disabled(vm.city.count < 3)
                
                if vm.isLoading {
                    ProgressView("Fetching Weather...")
                        .padding()
                } else if let weather = vm.weather {
                    WeatherCard(
                        weather: weather,
                        useFahrenheit: useFahrenheit
                    )
                }
                
                if vm.errorMessage != nil {
                    ErrorMessageView()
                }
                

                Spacer()
                
            }
            .navigationTitle("Weather App")
            .toolbar {
                ToolbarItem {
                    Menu {
                        Toggle(isOn: $useFahrenheit) {
                            Label(
                                useFahrenheit ? "Use Celsius" : "Use Fahernheit",
                                systemImage: "thermometer.sun"
                            )
                        }
                    } label: {
                        Image(systemName: "gear")
                    }

                }
            }
        }
    }
}

#Preview {
    WeatherView()
}
