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

class MapViewController: UIViewController, UISearchResultsUpdating, SingleReportViewControllerDelegate {
    func SingleReportViewControllerDelete(_ controller: SingleReportViewController) {
        self.navigationController?.isNavigationBarHidden = true
        mapView.removeAnnotations(selectedReports)
        //remove element from batchReport
        if let index = batchReports.firstIndex(where:{ $0 == controller.selectedReport}){
            batchReports.remove(at: index)
        }
        selectedReports.remove(at: controller.indexOfReport)
        mapView.addAnnotations(selectedReports)
       
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
            print(text)
    }
    
    let initialLocation = CLLocation(latitude: 40.73, longitude: -73.8181)
    
    @IBOutlet var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
    var annotationView = MKMarkerAnnotationView()
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var yourReportsButton: UIButton!
    @IBOutlet weak var SLFButton: UIButton!
    @IBOutlet weak var ALBButton: UIButton!
    @IBOutlet weak var SPMButton: UIButton!
    @IBOutlet weak var EABButton: UIButton!
    let loginUser: Int = UserDefaults.standard.object(forKey: "userid") as! Int
    //API CALL
    let batch = BatchReport()
    var selectedReports:[Datum] = []
    var batchReports:[Datum] = []
    
   
    //view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setUpFilter()

        mapView.centerToLocation(initialLocation)
        
        
        let nycCenter = CLLocation(latitude: 40.7678, longitude: -73.9645)
            let region = MKCoordinateRegion(
              center: nycCenter.coordinate,
              latitudinalMeters: 5000,
              longitudinalMeters: 6000)
        
            let region2 = MKCoordinateRegion(
              center: nycCenter.coordinate,
              latitudinalMeters: 12000,
              longitudinalMeters: 12000)
        
            mapView.setCameraBoundary(
              MKMapView.CameraBoundary(coordinateRegion: region2),
              animated: true)
        
        mapView.setRegion(region, animated: false)
        
            
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
            
            selectedReports = batchReports
            mapView.addAnnotations(selectedReports)
//            for bug in batchReports {
//                mapView.addAnnotation(bug)
//            }
             
            
        }//apiReport(userID)

        /*
        //TEST DATA
        for bug in testSLF {
            mapView.addAnnotation(bug)
        }
        */
        
        
    } //viewload
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    //MARK: Search Filter
    func setUpFilter(){
        filterView.isHidden = true
        let button = UIButton(type: .system) // Create a button
        button.backgroundColor = UIColor.black
        button.frame = CGRect(x: 280, y: 45, width: 110, height: 30) // Set the frame of the button
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.setTitle("Search Filter", for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(searchFilterButtonClicked(_:)), for: .touchUpInside)
        button.isOpaque = true
        mapView.addSubview(button)
        
    }
    func setUpCheckBoxes(_ sender: UIButton){
        if(sender.tag == 0){
            sender.tag = 1
            sender.setImage(UIImage(systemName: "checkmark.rectangle"), for: .normal)
        }
        else{
            sender.tag = 0
            sender.setImage(UIImage(systemName: "rectangle"), for: .normal)
        }
        
    }
    @objc func searchFilterButtonClicked(_ sender: UIButton) {
        
        if(sender.tag == 0){
            filterView.isHidden = false
            sender.tag = 1
            sender.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }
        else{
            filterView.isHidden = true
            sender.tag = 0
            sender.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        
    }

    @IBAction func checkYourReport(_ sender:  UIButton) {
        setUpCheckBoxes(sender)
    }
    
    @IBAction func checkSLF(_ sender: UIButton) {
        setUpCheckBoxes(sender)
    }
    
    
    
    @IBAction func checkEAB(_ sender:  UIButton) {
        setUpCheckBoxes(sender)
    }
    
    
    @IBAction func checkALB(_ sender:  UIButton) {
        setUpCheckBoxes(sender)
    }
    
    @IBAction func checkSPM(_ sender:  UIButton) {
        setUpCheckBoxes(sender)
    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        var selectedSpecies = Array(repeating: false, count: 4)
        var allReports = true
        var numSelectedSpecies = 0
        selectedReports.removeAll()
        selectedReports = batchReports

        if(yourReportsButton.tag == 1){
            allReports = false
        }
        if(SLFButton.tag == 1){
            selectedSpecies[0] = true
            numSelectedSpecies += 1
        }
        if(ALBButton.tag == 1){
            selectedSpecies[1] = true
            numSelectedSpecies += 1
        }
        if(EABButton.tag == 1){
           selectedSpecies[2] = true
            numSelectedSpecies += 1
        }
        
        if(SPMButton.tag == 1){
            selectedSpecies[3] = true
            numSelectedSpecies += 1
        }
        let newData = filterData(selectedSpecies: selectedSpecies, AllReports: allReports,numSelectedSpecies: numSelectedSpecies)
        mapView.removeAnnotations(selectedReports)
        selectedReports.removeAll()
        selectedReports = newData
        mapView.addAnnotations(selectedReports)
        
        
    }
    func filterData(selectedSpecies:[Bool],AllReports: Bool,numSelectedSpecies:Int) -> [Datum]{
        //[SLF,ALB,EAB,SPM]
        var returnArray:[Datum] = []
        if (numSelectedSpecies == 4 && AllReports == false){
            for report in selectedReports{
                if(report.userID == loginUser){
                    returnArray.append(report)
                }
            }
        }
        else if( AllReports){
            for report in selectedReports{
                if(selectedSpecies[0] && report.speciesID == SLF.id){
                    returnArray.append(report)
                }
                if(selectedSpecies[1] && report.speciesID == ALB.id){
                    returnArray.append(report)
                
                }
                if(selectedSpecies[2] && report.speciesID == EAB.id){
                    returnArray.append(report)
                }
                if(selectedSpecies[3] && report.speciesID == SPM.id){
                    returnArray.append(report)
                }
            }
        }
        else{
            for report in selectedReports{
                if(selectedSpecies[0] && report.speciesID == SLF.id && report.userID == loginUser){
                    returnArray.append(report)
                
                }
                if(selectedSpecies[1] && report.speciesID == ALB.id && report.userID == loginUser){
                    returnArray.append(report)
                
                }
                if(selectedSpecies[2] && report.speciesID == EAB.id && report.userID == loginUser){
                    returnArray.append(report)
                
                }
                if(selectedSpecies[3] && report.speciesID == SPM.id && report.userID == loginUser){
                    returnArray.append(report)
                
                }
            }
        }
        
        
        return returnArray
        
    }
    
    @IBAction func clickClearButton(_ sender: Any) {
        ALBButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
        EABButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
        SLFButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
        SPMButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
        yourReportsButton.setImage(UIImage(systemName: "rectangle"), for: .normal)
        selectedReports.removeAll()
        selectedReports = batchReports
    }
    
    
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
        
//        //MARK: Search
//        let search = UISearchController(searchResultsController: nil)
//        search.searchResultsUpdater = self
//        search.obscuresBackgroundDuringPresentation = false
//        search.searchBar.placeholder = "Search Report"
//        navigationItem.searchController = search
//
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
    //MARK: Single Report open
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ){
           if segue.identifier == "showReport" {
               let controller = segue.destination as! SingleReportViewController
               controller.delegate = self
               let buttonRight = sender as! UIButton
               let showReport = selectedReports[buttonRight.tag]
               controller.indexOfReport = buttonRight.tag;
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
