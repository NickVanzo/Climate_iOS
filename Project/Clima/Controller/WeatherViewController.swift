//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation //Comes with LocationManager

class WeatherViewController: UIViewController  {

    @IBOutlet var defaultLocation: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        locationManager.delegate = self
        
        locationManager.requestLocation()
        //Ask for permission
        locationManager.requestWhenInUseAuthorization()
        
        weatherManager.delegate = self
        //the delegate manages the input of the user the textField will respond to this ViewController
        textField.delegate = self
    }
    
    @IBAction func getDefaultLocationWeather(_ sender: UIButton) {
        let coordaintes = locationManager.location?.coordinate
        weatherManager.fetchWeather(coordaintes! .latitude, coordaintes!.longitude)
    }
    
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    //Everything that is related with the TextField
    @IBAction func searchPressed(_ sender: UIButton) {
        textField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //This code is triggered by the user when he presses the "return" key of the keyboard
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Code triggered as soon as the user finished editing the textField
        if let cityName = textField.text {
            weatherManager.fetchWeather(cityName: cityName)
        }
        textField.text = ""
    }
    
    //Triggered when the user don't press the "Done" button after typing inside the search box
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != "") {
            return true
        } else {
            textField.placeholder = "Type something here"
            return false
        }
    }
    
}

//Mark: - WeatherManagerDelegate
 
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
       
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

//Mark: - LocationManager

extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude, longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
