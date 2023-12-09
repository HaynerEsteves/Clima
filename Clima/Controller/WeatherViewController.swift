//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView! //inicio do código - outlets e labels
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()//criação de um objeto CLLocationManager pra usar as coisas deo CL. O padrão apple é o objeto como está (sempre ver com o ALT)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self//CL delegate to use methods like: request authorization, RequestLocation
        locationManager.requestWhenInUseAuthorization()//authorization request
        locationManager.requestLocation()//loc request
        
        searchTextField.delegate = self
        
        weatherManager.delegate = self
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()//loc request buttom pressed
    }
    
}

//MARK: - UITextFieldDelegate Session

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) //use the comand end editing (when user uses return button from keyboard). The command end editing triggers a function called didendediting
        return true
    }
    
    //this function is called before the did end edit before the (process Start). Here is checking if the user has actually written something on the searchbar or it is empty
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == searchTextField { //This line checks whitch searchfield if you have more than one.
            if searchTextField.text != "" {
                return true
            } else {
                searchTextField.placeholder = "City name here!" // if its empty changes the placeholder
                return false //return to keep the user on textfield until something is written there. Dont continue with code
            }
        } else {
            return false
        }
    }
    
    //this function is called after using endediting on code (process Start). BUT to check if this code is ready to be run, exists another function, that when called gets run before the did end editing. view lines up /\
    func textFieldDidEndEditing(_ textField: UITextField) {
        let city = searchTextField.text ?? "search=nil"
        weatherManager.createCityURL(cityName: city)
        searchTextField.text = ""
    }
} //the end of the first part. that is get hold of city name to start data process
//go to WeatherManager to part two. witch is > networking (URLSession) E JSONParse (JSONDecoder)

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {//delegate do weatherManager que passa as informações da tela. protocolconform e função
    func didUpdateWeather(_ weatherManager: WeatherManager, with weather: WeatherModel) {//funções criadas pra dar update na tela com a weather recebida do manager
        DispatchQueue.main.async {//fazer o update de uma thread separada
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(with error: Error) {//função de erro usada varias vezes no manager com o delegate.
        print(error.localizedDescription)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {//delegate do CoreLocation que passa as informações e cidade. protocolconform e função
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {//forma de pegar o último local do array
            locationManager.stopUpdatingLocation()//sempre parar o uso de loc
            let long = location.coordinate.latitude//pegando dado com propriedades da localização CLLocation
            let lati = location.coordinate.longitude
            print(long)
            print(lati)
            let lat = -3.71839//como minha loc ta cagada, uso esses pra ver se ta funfando.
            let lon = -38.5434
            weatherManager.createCoordenateURL(lat: lat, lon: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {//função de tratativa de erro do CLLocationManager. se der certo chama a função acima. se der erro, chama essa função. então ela tb tem q estar implementada.
        print(error)
    }

}
