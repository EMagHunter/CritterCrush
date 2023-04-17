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

class MapViewController: UIViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
            print(text)
    }
    
    let initialLocation = CLLocation(latitude: 40.73, longitude: -73.8181)
    
    @IBOutlet var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
    var annotationView = MKMarkerAnnotationView()
    
    //API CALL
    let batch = BatchReport()
    var batchReports:[Datum] = []
    
    //view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.centerToLocation(initialLocation)
        
        
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
        
        //API Call
        
        batch.mapApiReport(mapNo: 20){ [self] (result: Result<ParseBatch, Error>) in
            switch result {
            case .success(let report):
                self.batch.batchReport = report
                print(report)
            case .failure(let error):
                print(error.localizedDescription)
            }
            batchReports = self.batch.batchReport!.data
            print("Update: \(batchReports[0])")
            
            
            for bug in batchReports {
                mapView.addAnnotation(bug)
            }
             
            
        }//apiReport(userID)

        /*
        //TEST DATA
        for bug in testSLF {
            mapView.addAnnotation(bug)
        }
        */
        
        
    } //viewload
    
    
    func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        mapView.selectAnnotation(annotationView.annotation!, animated: true)
    }//mapView
    
}

extension MapViewController: MKMapViewDelegate {

    func mapView( _ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
       //  1
        /*
        guard let  annotation  = annotation as? Submission else {
            return nil
            
        }
        */
        
        guard let  annotation  = annotation as? Datum else {
            return nil
            
        }
        print(annotation)
        
        //MARK: Search
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Report"
        navigationItem.searchController = search
        
        //USE species list to grab name
       // let speciesList = [SLF,ALB,EAB,SPM]
        
        //MARK: Icon
        var image = ""
        var color = UIColor.red
        
        image = "icon/icon_bug\(annotation.speciesID)"
        
        color = speciesList[(annotation.speciesID-1)].color
        
        let identifier = "Submission"
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            let imgName = annotation.image
            let hostName =   "69.125.216.66"
            let afLink = "http://\(hostName)/api/reports/image/\(imgName)"
            
            if let url = URL(string: afLink) {
                AF.request(url).responseImage {
                    response in
                    switch response.result {
                    case .success(let image1):
                        imageView.image = image1
                    case .failure(_):
                        break
                    }
                }
            }//imageAPI
            annotationView?.leftCalloutAccessoryView = imageView
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(showDetail(_:)), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = rightButton
            
                
                
        }
        if let annotationView = annotationView {
            annotationView.annotation = annotation
            // a reference to part of the list it reference to
            let buttonRight = annotationView.rightCalloutAccessoryView as! UIButton
            if let index = batchReports.firstIndex(of: annotation) {
                buttonRight.tag = index
            }
            
        }
        else{
            annotationView?.annotation = annotation
       }
        let glyphImage = UIImage(named: image)
        annotationView?.glyphImage = glyphImage
        annotationView?.markerTintColor = color
        return annotationView
   }
    
    @objc func showDetail(_ sender: UIButton) {
        performSegue(withIdentifier: "showReport", sender: sender)
        
       }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        viewDidLoad()
    }

    //MARK: Single Report open
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ){
           if segue.identifier == "showReport" {
               let controller = segue.destination as! SingleReportViewController
               let buttonRight = sender as! UIButton
               let showReport = batchReports[buttonRight.tag]
               controller.selectedReport = showReport
           }
       } //edit report segue
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
