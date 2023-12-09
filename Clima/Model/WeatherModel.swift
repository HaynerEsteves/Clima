//
//  WeatherModel.swift
//  Clima
//
//  Created by Hayner Esteves on 19/07/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
//criação da estrutura de modelo. receber o que precisa e se tiver que computar, faz uma computedProperty
struct WeatherModel {
    var conditionID: Int
    var temperature: Double
    var cityName: String
    
    var temperatureString: String {//exemplo facil de computedProperty. O return é que vai ser o valor da propriedade.
        return String(format: "%.1f", temperature)
    }
    var conditionName: String {
        //print(conditionID)
        switch conditionID {
        case (in:200...232):
            return "cloud.bolt"
        case (in:300...321):
            return "cloud.drizzle"
        case (in:500...531):
            return "cloud.rain"
        case(in:600...622):
            return "cloud.snow"
        case(in:701...781):
            return "cloud.fog"
        case(801...804):
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
      
    
}
