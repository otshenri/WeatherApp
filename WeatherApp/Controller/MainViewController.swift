//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Henri Ots on 10/01/2019.
//  Copyright © 2019 Henri Ots. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var lngTextField: UITextField!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels(location: " ", description: " ", temperature: " ")
        
        //Registering delegates
        lngTextField.delegate = self
        latTextField.delegate = self
        
        //Registering observer to push content up when keyboard is visible
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    //Removing observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Pushing content up when keyboard becomes visible and vice versa
    //Solution from https://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    //Textfield delegate callback to take action when next/done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == lngTextField { // Switch focus to next text field
            latTextField.becomeFirstResponder()
        }
        else if textField == latTextField { //Get weather by coordinates
            getWeatherByCoordinates()
        }
        return true
    }
    
    //Location service callback to receive user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        locationManager.stopUpdatingLocation()
        
        makeWeatherRequest(lat: String(locValue.latitude), lng: String(locValue.longitude))
    }
    
    func startLocationService() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getWeatherByCoordinates() {
        dismissKeyboard()
        
        if latTextField.text != "" && lngTextField.text != "" {
            makeWeatherRequest(lat: latTextField.text!, lng: lngTextField.text!)
        }
        else {
            let alert = UIAlertController(title: "Coordinate Missing", message: "Please enter all coordinates to get weather info", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func makeWeatherRequest(lat:String, lng:String) {
        showActivityIndicator()
        NetworkManager.shared().getWeather(lat:lat, lng:lng) {weather in
            self.hideActivityIndicator()
            self.handleWeatherResponse(weather: weather)
        }
    }
    
    func handleWeatherResponse(weather:Weather?) {
        if (weather != nil) {
            self.setLabels(location: (weather?.name)!, description: (weather?.details[0].desc)!, temperature: (weather?.attributes.tempRoundedCelcius())!)
        }
        else {
            self.showError()
        }
    }
    
    //SHOWING OR DISMISSING
    func setLabels(location:String, description:String, temperature:String) {
        locationLabel.text = location
        descriptionLabel.text = description
        tempLabel.text = temperature
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func showActivityIndicator() {
        //Hide labels first
        setLabels(location: " ", description: " ", temperature: " ")
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    //ERROR HANDLING
    func showError() {
        let alert = UIAlertController(title: "Error", message: "Something went wrong, sorry!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    //BUTTONS
    @IBAction func currentLocationBtnPressed(_ sender: Any) {
        startLocationService()
    }
    
    @IBAction func coordinatesBtnPressed(_ sender: Any) {
        getWeatherByCoordinates()
    }
}

