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
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var subID: Int = 0 //report ID
    var selectedReportID: Int?
    var indReport:IndividualReport?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        //image
        let afLink = "https://static.inaturalist.org/photos/241063922/medium.jpg"
        AF.request(afLink).responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if case .success(let image) = response.result {
                print("image downloaded: \(image)")
                self.reportImg.image = image
            }
        }
        
        self.userName.text = "USER1"
        apiReport(repID: 1){ (result: Result<IndividualReport, Error>) in
            switch result {
            case .success(let report):
                self.indReport = report
                print(report)
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.dateLabel.text = self.indReport?.data.reportDate
            
            //location
            self.locationLabel.text = "\(String(describing: self.indReport?.data.longitude)),\(String(describing: self.indReport?.data.latitude))"
            
        }
        
    }
            
    
    func apiReport(repID: Int, completionHandler: @escaping (Result<IndividualReport, Error>) -> Void) {
        //takes report ID of selected report
        //uses
        let hostname = "69.125.216.66"
        let url = "http://\(hostname)/api/reports/\(repID)"
        
        // make the GET request using Alamofire
        AF.request(url, method:.get, encoding:URLEncoding.queryString).responseData { response in
            //debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    
                    print("Data retrieved: \(data)")
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                       print(JSONString)
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        
                        let result = try decoder.decode(IndividualReport.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(.success(result))
                        }
                    } catch {
                        print(error)
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
                print("error")
                break
            }
        }
    }//apiReport
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
