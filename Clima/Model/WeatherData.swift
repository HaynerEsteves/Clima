//
//  WeatherData.swift
//  Clima
//
//  Created by Hayner Esteves on 16/07/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

//essa estrutura foi criada no meio da parte 2, do weatherManager
struct WeatherData: Codable {//o codable é o typealias, pra poder decodificar o dado do JSON
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double//possivel declarar várias variaveis de uma só vez
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}


//do datatask abrir função pra decodificar Nome da função: parsejson essa função tem q ser dentro da classe fora do fetchdata
/*
    func parseJSON (weatherData: Data) {
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(data type: WeatherData.self, Dados: weatherData)
         } catch {
        print(error)
        }
    }
 
 */
