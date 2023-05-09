//
//  DetailSubmissionViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/10/23.
//
//MARK: API CALLS
//
//PARAM: speciesID, userID (logged in)
//400: fail, 201: get json, 401: unauthorized

import Alamofire
import AlamofireImage

import UIKit
import MapKit
////STRUCT TO PASS REPORTS
//struct bugReport{
//    var subID: Int = 0 //report ID
//    var bugID: Int = 0 //bugID
//    var subDate: String
//    //we only need report ID
//    var reportImage:Image!
//    var reportLocationText = ""
//
//}


class DetailSubmissionViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    
    //
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var speciesName: UILabel!
    @IBOutlet weak var scienceName: UILabel!
    @IBOutlet weak var bugIcon: UIImageView!
    
    @IBOutlet weak var viewBug: UIView!
    
    /*
         destination.titleStringViaSegue = speciesList[bugIndex].name
         destination.bugID = speciesList[bugIndex].id
     */
    
    var titleStringViaSegue: String!
    var bugID: Int!
    var selectedBug: Datum!
    var reportImageHolder:Image!
    
    //API CALL
    let batch = BatchReport()
    var batchReports:[Datum] = []
    
    override func viewDidLoad() {
        addTopView()
        
        super.viewDidLoad()
        
        //collection view
        
        let nib = UINib(nibName:"ReportCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ReportCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    
        // Do any additional setup after loading the view.
        let loginUser: Int = UserDefaults.standard.object(forKey: "userid") as! Int
        
        batch.apiReport(userID: loginUser, speciesID: self.bugID){ [self] (result: Result<ParseBatch, Error>) in
            switch result {
            case .success(let report):
                self.batch.batchReport = report
                batchReports = self.batch.batchReport!.data
                print(report)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            //print("Update: \(batchReports[0])")
            self.collectionView.reloadData()
        }//apiReport(userID)

        
        //get the batch report
    }//view did load
    
    
    func addTopView(){
        
        self.speciesName.text = self.titleStringViaSegue
        
        // Do any additional setup after loading the view.
        
        self.speciesName.text = self.titleStringViaSegue
        //self.bugIcon.image = UIImage(named:"bugicon\(bugID ?? 1)")
        self.bugIcon.image = UIImage(named:"icon/icon_bug\(bugID ?? 1)")
        if let i = speciesList.firstIndex(where: { $0.id == bugID }) {
            self.scienceName.text = speciesList[i].science
        }
        self.viewBug.layer.masksToBounds = true
        self.viewBug.layer.cornerRadius = 10
        self.viewBug.layer.borderColor = UIColor.lightGray.cgColor
        self.viewBug.layer.borderWidth = 1
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        viewDidLoad()
        
    }
   
    //MARK: Image grabbing
    //TEST FILE
    //testSLF is an array of test submissions
    
    //MARK:
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return batchReports.count
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // @IBOutlet weak var reportImg: UIImageView!
        //@IBOutlet weak var dateLabel: UILabel!
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportCell", for: indexPath) as! ReportCell
        
        let labelDate = batchReports[indexPath.row].reportDate
        
        let bug = batchReports[indexPath.row]
        cell.spinner.startAnimating()
        
        
        //update labels and images
        //print(labelDate)
        cell.dateLabel?.text = labelDate
        
        cell.backgroundImage.image = UIImage(named:"frame_bug\(self.bugID!)")
        
        //MARK: Image
        
        cell.backgroundImage.contentMode = .scaleToFill
        let imgName = bug.image
        let hostName = localhost.hostname
        let afLink = "\(hostName)/api/reports/image/\(imgName)"
        AF.request(afLink).responseImage { response in
            
            if case .success(let image) = response.result {
               // print("image downloaded: \(image)")
                cell.spinner.isHidden = true
                cell.reportImg?.image = image
            }
        } //image
        
        
        //get bug.id into navigation segue
        
        return cell
    }
    
    // MARK: - Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let bug = batchReports[indexPath.item]
        
        let selectedLocationText = "\(String(describing: bug.longitude)),\(String(describing: bug.latitude))"
        let cell = collectionView.cellForItem(at: indexPath) as! ReportCell
        selectedBug = batchReports[indexPath.row]
       
        
        let singleSegue = "showSingleReport"
        
        self.performSegue(withIdentifier: singleSegue, sender: self)
        
      }
    
    let singleSegue = "showSingleReport"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == singleSegue {
            if let destVC = segue.destination as? SingleReportViewController {
                destVC.selectedReport = selectedBug
                
        
            }
        }
    }

}
