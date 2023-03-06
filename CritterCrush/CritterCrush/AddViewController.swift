//
//  AddViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 3/5/23.
//

import UIKit
import CoreLocation
class AddViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var StreetAddressTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var getButton: UIButton!
    //object that will give you GPS coordinates.
    let locationManager = CLLocationManager()
    //will store the user’s current location
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    //object that will perfom
    let geocoder = CLGeocoder()
    //contains the adresss
    var placemark : CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    var timer: Timer?
    
    //MARK: -CCLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //print("DidFailWithError\(error.localizedDescription)")
        if (error as NSError).code == CLError.locationUnknown.rawValue{
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations\(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -6 {
            return
        }
        if newLocation.horizontalAccuracy < 0{
            return
        }
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy{
            lastLocationError = nil
            location = newLocation
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy{
                stopLocationManager()
                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }
            if !performingReverseGeocoding{
                performingReverseGeocoding = true
                geocoder.reverseGeocodeLocation(newLocation){
                    placemarks, error in
                    self.lastGeocodingError = error
                    if error == nil, let places = placemarks, !places.isEmpty {
                        self.placemark = places.last!
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                    }
                }
            updateLabels()
        }else if distance < 1 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10{
                stopLocationManager()
                updateLabels()
            }
        }
    }
    //MARK: - Actions
    @IBAction func getLocation(){
        let authorizationStatus = locationManager.authorizationStatus
        // ask permistion to use locatiob
        if authorizationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if authorizationStatus == .denied || authorizationStatus == .restricted{
            showLocationServicesDeniedAlert()
            return
        }
        if updatingLocation {
          stopLocationManager()
        } else {
          location = nil
          lastLocationError = nil
          placemark = nil
          lastGeocodingError = nil
          startLocationManager()
        }
        updateLabels()
    }
    //MARK: - Helper Methods
    func showLocationServicesDeniedAlert(){
        let alert = UIAlertController(
            title: "Location Services Denied",
            message: "Please enable location services.",
            preferredStyle: .alert)

        let Action = UIAlertAction(
            title: "Close",
            style: .default,
            handler: nil)
        alert.addAction(Action)

        present(alert, animated: true,completion: nil)

    
    }
    func updateLabels(){
        if let location = location {
            messageLabel.text = ""
            if let placemark = placemark {
                addressConversion(from: placemark)
                
            } else if performingReverseGeocoding {
                  messageLabel.text = "Searching for Address..."
                                                                                                                      
            } else if lastGeocodingError != nil {
                messageLabel.text = "Error Finding Address"
                
            } else {
                messageLabel.text = "No Address Found"
                }
            
        } else {
              messageLabel.text = ""
              let Message: String
              if let error = lastLocationError as NSError? {
                  if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                      showLocationServicesDeniedAlert()
                      Message = ""
                  } else {
                      Message = "Error Getting Location"
                  }
                  
              } else if !CLLocationManager.locationServicesEnabled() {
                  showLocationServicesDeniedAlert()
                  Message = ""
                  
              } else if updatingLocation {
                  Message = "Searching..."
              } else {
                  Message = "Click"
              }
              messageLabel.text = Message
              }
        updateGetButton()
          }
    func startLocationManager(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation  = true
            // checks location for 55 min if it does work then timeout
            timer = Timer.scheduledTimer(
                timeInterval: 55,
                target: self,
                selector: #selector(timeOut),
                userInfo: nil,
                repeats: false
            )
        }
    }
    @objc func timeOut(){
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(
                domain: "MyLocatiosErrorDomain",
                code: 1,
                userInfo: nil)
            updateLabels()
        }
    }
    func stopLocationManager(){
        if updatingLocation{
            locationManager.startUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            //stops the timer of 55 sec
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    func updateGetButton(){
        if updatingLocation{
            getButton.setTitle("Stop Seaching", for: .normal)
        }else {
            getButton.setTitle("Get Location", for: .normal)
        }
    }
    func addressConversion(from placemark:CLPlacemark) {
        //1
        var streetAddress = ""
        StreetAddressTextField.text = ""
        //fancy name for house number
        if let tmp = placemark.subThoroughfare{
            streetAddress += tmp + " "
            
        }
        //street name
        if let temp = placemark.thoroughfare{
            streetAddress += temp
        }
        //4
        StreetAddressTextField.text = streetAddress
        
        if let temp = placemark.locality{
            cityTextField.text = temp
        }
        if let temp = placemark.administrativeArea {
            stateTextField.text = temp
          }
          if let temp = placemark.postalCode {
              zipcodeTextField.text = temp
          }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()

        // Do any additional setup after loading the view.
    }
    

}
