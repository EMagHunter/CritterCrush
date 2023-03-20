//
//  MapViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/27/23.
//
import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    let initialLocation = CLLocation(latitude: 40.73, longitude: -73.8181)
    
    @IBOutlet var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
    
    
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
