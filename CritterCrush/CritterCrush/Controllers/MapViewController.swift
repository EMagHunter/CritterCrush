//
//  MapViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/27/23.
//

import UIKit
import MapKit
import CoreData
class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
}

//TO DO:
//set default location on map
//40.7128° N, 74.0060° W
//User defaults = 
