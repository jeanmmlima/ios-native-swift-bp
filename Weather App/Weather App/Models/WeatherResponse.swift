//
//  WeatherResponse.swift
//  Weather App
//
//  Created by Ron Erez on 10/10/2025.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: jsonData)

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let location: Location
    let current: Current
}

// MARK: - Current
struct Current: Codable {
    let tempC: Double
    let tempF: Double
    let condition: Condition
    let feelslikeC: Double
    let feelslikeF: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case tempF = "temp_f"
        case condition
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
    let icon: String
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let country: String

    enum CodingKeys: String, CodingKey {
        case name, country
    }
}
