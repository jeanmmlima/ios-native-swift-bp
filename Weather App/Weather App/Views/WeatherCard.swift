//
//  WeatherCard.swift
//  Weather App
//
//  Created by Ron Erez on 11/10/2025.
//

import SwiftUI

struct WeatherCard: View {
    let weather: WeatherResponse
    let useFahrenheit: Bool
    
    var urlString: String {
        "https:\(weather.current.condition.icon)"
    }
    
    var displayTemp: String {
        useFahrenheit ? String(format: "%.1f°F", weather.current.tempF) : String(format: "%.1f°C", weather.current.tempC)
    }
    
    var displayFeelsLike: String {
        useFahrenheit ? String(format: "Feels like %.1f°F", weather.current.feelslikeF) : String(format: "Feels like %.1f°C", weather.current.feelslikeC)
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } placeholder: {
                ProgressView()
            }
            
            Text("\(weather.location.name), \(weather.location.country)")
                .font(.title2)
                .bold()
            
            Text(displayTemp)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
            
            Text(weather.current.condition.text)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.9))
            
            Text(displayFeelsLike)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.9))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [.blue, .teal],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 10)
        .padding()
    }
}

//#Preview {
//    WeatherCard()
//}
