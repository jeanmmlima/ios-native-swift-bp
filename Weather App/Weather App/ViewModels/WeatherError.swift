//
//  WeatherError.swift
//  Weather App
//
//  Created by Ron Erez on 11/10/2025.
//

import Foundation

enum WeatherError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The provided city name is invalid."
        case .requestFailed(let statusCode):
            "Request failed with status code \(statusCode). Please try again."
        case .decodingFailed:
            "Unable to decode weather data. The server may have changed its response format."
        case .unknown:
            "An unknown error occurred."
        }
    }
}
