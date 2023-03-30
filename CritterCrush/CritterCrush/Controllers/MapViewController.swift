//
//  MapViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/27/23.
//GET: Reports (last 7 days)
//PARAM: current date
//200: Success
//400: fail, 201: get json, 401: unauthorized



import Foundation
import UIKit
import MapKit
import CoreData
import Alamofire
import AlamofireImage

class MapViewController: UIViewController {
    let initialLocation = CLLocation(latitude: 40.73, longitude: -73.8181)
    
    @IBOutlet var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
    var annotationView = MKMarkerAnnotationView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.centerToLocation(initialLocation)
        for bug in testSLF {
            mapView.addAnnotation(bug)
        }
        
        let nycCenter = CLLocation(latitude: 40.73, longitude: -73.8181)
            let region = MKCoordinateRegion(
              center: nycCenter.coordinate,
              latitudinalMeters: 50000,
              longitudinalMeters: 60000)
            mapView.setCameraBoundary(
              MKMapView.CameraBoundary(coordinateRegion: region),
              animated: true)
            
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
            mapView.setCameraZoomRange(zoomRange, animated: true)
        
    }
    
    ///
}
extension MapViewController: MKMapViewDelegate {

    func mapView( _ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
       //  1
        guard let  annotation  = annotation as? Submission else {
            return nil
            
        }
        var image = ""
        var color = UIColor.red
        if annotation.speciesName == "Spotted Lanternfly"{
            image = "icon/icon_bug1"
            color = .blue
        }
        else if annotation.speciesName == "Asian Longhorned Beetle"{
            image = "icon/icon_bug2"
            color = .red
        }
                else if annotation.speciesName == "Emerald ash borer"{
                    image = "icon/icon_bug3"
                    color = .white
        
                }
                else if annotation.speciesName == "Spongy moth"{
                    image = "icon/icon_bug4"
                    color = .yellow
        
                }

        let identifier = "Submission"
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            if let url = URL(string: annotation.imageURL) {
                AF.request(url).responseImage {
                    response in
                    switch response.result {
                    case .success(let image1):
                        imageView.image = image1
                    case .failure(_):
                        break
                    }
                }
            }
            annotationView!.leftCalloutAccessoryView = imageView
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(showDetail(_:)), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = rightButton
        }
        if let annotationView = annotationView {

            let glyphImage = UIImage(named: image)
            annotationView.glyphImage = glyphImage
            annotationView.markerTintColor = color
        }
        else{
            annotationView?.annotation = annotation
       }
        return annotationView
   }
    @objc func showDetail(_ sender: UIButton) {
    }
}
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

//TO DO:
//set default location on map
//40.7128° N, 74.0060° W
//User defaults = 
