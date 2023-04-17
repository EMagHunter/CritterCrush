//
//  SingleSubmissionViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/10/23.
//
import Alamofire
import AlamofireImage
import UIKit

class SingleReportViewController: UIViewController{
    
    
    @IBOutlet weak var reportImg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var DetailView: UIView!
    @IBOutlet weak var speciesIcon: UIImageView!
    @IBOutlet weak var speciesName: UILabel!
    //var subID: Int = 0 //report ID
    @IBOutlet weak var reportImgView: UIView!
    var selectedReportID: Int?
    var selectedReport: Datum!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateLabel.text = selectedReport.reportDate 
        self.locationLabel.text = String(selectedReport.longitude)
        self.speciesIcon.image = UIImage(named:"icon/icon_bug\(String(describing: selectedReport.speciesID))")
        self.speciesName.text = selectedReport.title
        let imgName = selectedReport.image
        let hostName =   "69.125.216.66"
        let afLink = "http://\(hostName)/api/reports/image/\(imgName)"
        AF.request(afLink).responseImage { response in
            
            if case .success(let image) = response.result {
                self.reportImg.image = image
            }
        } //
        style()
        
        
        //self.userName.text = "USER1"
//        apiReport(repID: 1){ (result: Result<IndividualReport, Error>) in
//            switch result {
//            case .success(let report):
//                self.indReport = report
//                //print(report)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            self.dateLabel.text = self.indReport!.data.reportDate
//
//            //location
//            self.locationLabel.text = "\(String(describing: self.indReport!.data.longitude)),\(String(describing: self.indReport!.data.latitude))"
//
//            //image
//            //print(self.indReport!.data.image)
//
//            let img = self.indReport!.data.image
//            let hostname = "69.125.216.66"
//            let url = "http://\(hostname)/api/reports/image/\(img)"
//
//            AF.request(url).responseImage { response in
//                //debugPrint(response)
//                //debugPrint(response.result)
//
//                if case .success(let image) = response.result {
//                   // print("image downloaded: \(image)")
//                    self.reportImg.image = image
//                    self.reportImg.contentMode = .scaleAspectFill
//                    self.reportImg.layer.masksToBounds = true
//                    self.reportImg.layer.cornerRadius = 10
//                    self.reportImg.layer.borderColor = UIColor.lightGray.cgColor
//                    self.reportImg.layer.borderWidth = 1
//
//                }
//            }
//
//        }
        
    }//view
    
    
//    //delete report
    @IBAction func delReport() {
        //get report id
        //make report deletion call
        //change to screen: this report has been deleted
        //segue to previous screen
        
        
        let hostName =   "69.125.216.66"
        let afLink = "http://\(hostName)/api/reports/\(String(describing: selectedReportID))"
        
        
        let authToken: String? = KeychainHelper.standard.read(service: "com.crittercrush.authToken", account: "authToken", type: String.self)
        
        let headers: HTTPHeaders = [
            "Authorization": "\(authToken!)"
        ]
        
        
        // make the GET request using Alamofire
        AF.request(afLink, method:.delete, encoding:URLEncoding.queryString, headers: headers).responseData { response in
            //debugPrint(response)
            debugPrint(response)
//        case success:
//            do {
//                
//            }
        }
        
        
    }//delete
    
    
    
    func style(){
        self.reportImg.contentMode = .scaleAspectFill
        //self.reportImg.layer.masksToBounds = true
        self.reportImg.layer.cornerRadius = 10
        self.reportImg.layer.borderColor = UIColor.lightGray.cgColor
        self.reportImg.layer.borderWidth = 1
        self.reportImg.contentMode = .scaleAspectFill
        
        self.DetailView.backgroundColor = UIColor.white
        self.DetailView.layer.shadowColor = UIColor.black.cgColor
        self.DetailView.layer.shadowOpacity = 0.3
        self.DetailView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.DetailView.layer.shadowRadius = 15
        self.DetailView.layer.cornerRadius = 20
        self.DetailView.layer.masksToBounds = false
        
        self.reportImgView.backgroundColor = UIColor.white
        self.reportImgView.layer.shadowColor = UIColor.black.cgColor
        self.reportImgView.layer.shadowOpacity = 0.3
        self.reportImgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.reportImg.layer.shadowRadius = 15
        self.reportImgView.layer.cornerRadius = 10
        self.reportImgView.layer.masksToBounds = false
       
        
        
    }//style
    func showDeleteAlert(){
        let alert = UIAlertController(
            title: "Deletion Sucessul",
            message: "The information has been deleted" ,
            preferredStyle: .alert)
        //        let Action = UIAlertAction(
        //            title: "Exit",
        //            style: .default,
        //            handler: nil)
        //        alert.addAction(Action)
        present(alert, animated: true,completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }
//    func apiReport(repID: Int, completionHandler: @escaping (Result<IndividualReport, Error>) -> Void) {
//        //takes report ID of selected report
//        //uses
//        let hostname = "69.125.216.66"
//        let url = "http://\(hostname)/api/reports/\(repID)"
//
//        // make the GET request using Alamofire
//        AF.request(url, method:.get, encoding:URLEncoding.queryString).responseData { response in
//            //debugPrint(response)
//            switch response.result {
//            case .success(let data):
//                do {
//
//                    //print("Data retrieved: \(data)")
//                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
//                       //print(JSONString)
//                    }
//
//                    do {
//                        let decoder = JSONDecoder()
//
//                        let result = try decoder.decode(IndividualReport.self, from: data)
//                        DispatchQueue.main.async {
//                            completionHandler(.success(result))
//                        }
//                    } catch {
//                        //print(error)
//                        completionHandler(.failure(error))
//                    }
//                }
//            case .failure(let error):
//                completionHandler(.failure(error))
//               // print("error")
//                break
//            }
//        }
//    }//apiReport
//
////    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
}
