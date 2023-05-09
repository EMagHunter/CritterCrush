//
//  SingleSubmissionViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/10/23.
//
import Alamofire
import AlamofireImage
import UIKit

protocol SingleReportViewControllerDelegate:AnyObject{
    func SingleReportViewControllerDelete(
        _ controller: SingleReportViewController)
}
class SingleReportViewController: UIViewController{
    
    
    @IBOutlet weak var reportImg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var DetailView: UIView!
    @IBOutlet weak var speciesIcon: UIImageView!
    @IBOutlet weak var speciesName: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    weak var delegate: SingleReportViewControllerDelegate?
    //var subID: Int = 0 //report ID
    @IBOutlet weak var reportImgView: UIView!
   // var selectedReportID: Int?
    var indexOfReport: Int!
    var selectedReport: Datum!
    @IBOutlet weak var deleteButton: UIButton!
    let loginUser: Int = UserDefaults.standard.object(forKey: "userid") as! Int
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        let spinner = view.viewWithTag(100) as! UIActivityIndicatorView
        spinner.startAnimating()
        if loginUser != selectedReport.userID{
            deleteButton.isHidden = true
        }
        else if  loginUser == selectedReport.userID{
            deleteButton.isHidden = false
        }
        self.dateLabel.text = selectedReport.reportDate 
        self.locationLabel.text = String(selectedReport.longitude)
        self.speciesIcon.image = UIImage(named:"icon/icon_bug\(String(describing: selectedReport.speciesID))")
        self.speciesName.text = selectedReport.title
        let imgName = selectedReport.image
        let hostName = localhost.hostname
        let afLink = "\(hostName)/api/reports/image/\(imgName)"
        AF.request(afLink).responseImage { response in
            
            if case .success(let image) = response.result {
                spinner.isHidden = true
                self.reportImg.image = image
            }
        } //
        style()
        
        let userid = selectedReport.userID
        
        let url  = "\(hostName)/api/users/userprofile"
        let param: [String:Int] = [
                        "userid": userid
                    ]

        // call /api/users/userprofile end point to get user information
        AF.request(url, method: .get, parameters: param).responseData { response in
            debugPrint(response)

            switch response.result {
            case .success(let data):
                do {
                    // get the email and pass it to settings page
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    if let data = asJSON as? [String: Any] {
                        if let dict = data["data"] as? [String: Any], let username = dict["username"] as? String {
                            self.usernameLabel.text = username
                        }
                    }
                } catch {
                }
            case .failure(_): break
            }
        }
        
    }//view
    
    
//    //delete report
    @IBAction func delReport() {
        //get report id
        //make report deletion call
        //change to screen: this report has been deleted
        //segue to previous screen
        
        
        let hostName = localhost.hostname
        let afLink = "\(hostName)/api/reports/\(String(describing: selectedReport.reportID))"


        let authToken: String? = KeychainHelper.standard.read(service: "com.crittercrush.authToken", account: "authToken", type: String.self)

        let headers: HTTPHeaders = [
            "Authorization": "\(authToken!)"
        ]


        // make the GET request using Alamofire
        AF.request(afLink, method:.delete, encoding:URLEncoding.queryString, headers: headers).responseData { response in
            //debugPrint(response)
            debugPrint(response)
            if (response.response?.statusCode == 200) {
                self.showDeleteAlert()
                self.delegate?.SingleReportViewControllerDelete(self)
            } else {
                self.showErrorAlert()
            }
        }
        //showDeleteAlert()
        
        
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
        present(alert, animated: true,completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    func showErrorAlert(){
        let alert = UIAlertController(
            title: "Error",
            message: "A error occur and no deletion took place" ,
            preferredStyle: .alert)
        present(alert, animated: true,completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }

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
