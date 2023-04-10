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

class DetailSubmissionViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    
    //STRUCT TO PASS REPORTS
    struct bugReport{
        var subID: Int = 0 //report ID
        var bugID: Int = 0 //bugID
        var subDate: String
        //we only need report ID
    }
    //
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var speciesName: UILabel!
    @IBOutlet weak var scienceName: UILabel!
    @IBOutlet weak var bugIcon: UIImageView!
    
    @IBOutlet weak var viewBug: UIView!
    var titleStringViaSegue: String!
    var bugID: Int!
    var selectedBug: bugReport!
    
    override func viewDidLoad() {
        addTopView()
        
        super.viewDidLoad()
        
        //collection view
        
        let nib = UINib(nibName:"ReportCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ReportCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    
        // Do any additional setup after loading the view.
        
    }
    func addTopView(){
        
        self.speciesName.text = self.titleStringViaSegue
        
        // Do any additional setup after loading the view.
        
        self.speciesName.text = self.titleStringViaSegue
        self.bugIcon.image = UIImage(named:"icon/icon_bug\(bugID ?? 1)")
        if let i = speciesList.firstIndex(where: { $0.id == bugID }) {
            self.scienceName.text = speciesList[i].science
        }
        self.viewBug.layer.masksToBounds = true
        self.viewBug.layer.cornerRadius = 10
        self.viewBug.layer.borderColor = UIColor.lightGray.cgColor
        self.viewBug.layer.borderWidth = 1
        
        
    }
   
    //MARK: Image grabbing
    //TEST FILE
    //testSLF is an array of test submissions
    
    //MARK:
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testSLF.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // @IBOutlet weak var reportImg: UIImageView!
        //@IBOutlet weak var dateLabel: UILabel!
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportCell", for: indexPath) as! ReportCell
        
        let labelDate = testSLF[indexPath.row].reportDate
        let bug = testSLF[indexPath.row]
        
        //update labels and images
        print(labelDate)
        cell.dateLabel?.text = labelDate
        if self.speciesName.text == "Spotted lanternfly"{
            cell.backgroundImage.image = UIImage(named: "backgroundFrame_bug1")
        }else if speciesName.text == "Asian longhorned beetle"{
            cell.backgroundImage.image = UIImage(named: "backgroundFrame_bug2")
        }
        else if speciesName.text == "Emerald ash borer"{
                cell.backgroundImage.image = UIImage(named: "backgroundFrame_bug3")
    
            }
        else if speciesName.text == "Spongy moth"{
                cell.backgroundImage.image = UIImage(named: "backgroundFrame_bug4")
        }
        cell.backgroundImage.contentMode = .scaleToFill
        let afLink = bug.imageURL
        AF.request(afLink).responseImage { response in
            debugPrint(response)

           // print(response.request)
            //print(response.response)
           // debugPrint(response.result)

            if case .success(let image) = response.result {
                print("image downloaded: \(image)")
                cell.reportImg?.image = image
            }
        }
        
        
        //get bug.id into navigation segue
        
        return cell
    }
    
    // MARK: - Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let bug = testSLF[indexPath.item]
        
        selectedBug = bugReport(subID:bug.reportID, bugID:bug.speciesID, subDate:bug.reportDate)
        
        let singleSegue = "showSingleReport"
        
        self.performSegue(withIdentifier: singleSegue, sender: self)
        
      }
    
    let singleSegue = "showSingleReport"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == singleSegue {
            if let destVC = segue.destination as? SingleReportViewController {
                destVC.selectedReportID = selectedBug.bugID
            }
        }
    }

}
