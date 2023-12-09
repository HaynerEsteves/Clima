//
//  WeatherManager.swift
//  Clima
//
//  Created by Hayner Esteves on 15/07/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {//pra passar os dados pra VC precisa de um protocolo e delegate
    func didUpdateWeather(_ weatherManager: WeatherManager,with weather: WeatherModel)
    func didFailWithError(with error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0215b91e010d57edb9301c22b26397e3&units=metric" //inicio da part 2: fazer URL
    var delegate: WeatherManagerDelegate?//delegate tem que ter o nome do protocolo e o protocolo tem q ta na VC com a função.
    
    func createCoordenateURL(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func createCityURL(cityName: String) { //inicio da segunda parte. Com o tronco da URL adicionar a parte que vai muder (city name)
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString) //Com uRL feita, chama função de request na internet (Networking)
    }
    
    func performRequest(with urlString: String) {//Inicio de netWorking
        
        if let url = URL(string: urlString) { //criação de URL com a stringURL) - Como a URL pode dar em nada e ser vazio ou erro, joga num if let
            let session = URLSession(configuration: .default)//se deu certo a URL, inicia uma session
            
            let task = session.dataTask(with: url) { (data, response, error) in// inicia a task da sessão a task é buscar o dado e ele tem um closure pra quando a busca terminar. Como o session.datatask tem um retorno, posso colocar isso numa variável (task)
                if error != nil {//se a variavel erro vier com algo. deu errado. e executa a função do erro
                    delegate?.didFailWithError(with: error!)
                    return//return pra quitar o app e parar tudo
                }
                if let safeData = data {//se não deu erro, vamo tratar o dado pra usar ele
                    if let weather = self.parseJSON(safeData) {//aqui primeiro na ida, só chama a função de parseJSON. mais adiante no codigo, colocaremos um retorno na função de parse pra voltar com o dado.
                        delegate?.didUpdateWeather(self, with: weather)// fim do cogigo, quando usamos delegate pra passar o dado weatherModel pra a VC.
                    }//depois de criar o modelo voltar os dados pra a VC com o delegate
                }
            }
            task.resume()//são 5 passos pra url. URL > Session > Task > complitionHandler > StartTask(Resumetask)
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {//de posse do dado (safeData na função anterior), vamo decodificar o JSON
        let decoder = JSONDecoder()//cria um decodificador pra usar ele
        
        do{//no meio da função ele vai pedir um do/catch pra tratar erro
            let decodedWeatherData = try decoder.decode(WeatherData.self, from: weatherData)//começa com decode.decoder(agora vai ter q criar o modelo onde o dado vai se espelhar (a estrutura). Daí decoda com a estrutura "Type" e o dado (safeData>weatherData). Usar isso pede o Try. O Try pede o do/catch
            let id = decodedWeatherData.weather[0].id//se a decodificação der certo, retira os dados 
            print(id)
            let temp = decodedWeatherData.main.temp
            let name = decodedWeatherData.name
            //de posse das informações necessárias. Criar um novo modelo de dados especifico pro que se precisa. e passasr pra ele tudo que tu precisa.
            let weather = WeatherModel(conditionID: id, temperature: temp, cityName: name)
            return weather//retorna o dado criado na função de parse. Agora volta na anterior e cria os delegate. Inicio da parte 3. os delegates
            
        } catch {
            delegate?.didFailWithError(with: error)
            return nil
        }
    }
}
