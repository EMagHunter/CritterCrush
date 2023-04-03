//
//  SingleSubmissionViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/10/23.
//
import Alamofire
import AlamofireImage
import UIKit

class SingleSubmissionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var subID: Int = 0 //report ID
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedReportID: Int?
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        print(apiReport(repID: 1))
        // Do any additional setup after loading the view.
    }
    
    func apiReport(repID: Int) -> (IndividualReport)? {
    
        var report: IndividualReport? = nil
       let url = "http://69.125.216.66/api/reports/\(repID)"
        //let url = "http://69.125.216.66/api/reports/1"
        // make the GET request using Alamofire
        
        AF.request(url, method:.get, encoding:URLEncoding.queryString).responseData { response in
            //            debugPrint(response)
                switch response.result {
                case .success(let data):
                    do {
                        
                        print("Data retrieved: \(data)")
                        
                        do {
                            let decoder = JSONDecoder()
                            
                            let result = try decoder.decode(IndividualReport.self, from: data)
                            print(result)
                            report = result
                        } catch {
                          print(error)
                        }
                    }
                case .failure(_): break
                    }
                }
        return report
    }//apiReport
    
    
    //MARK: TABLE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlesubmissioncell", for: indexPath) as! SingleSubmissionCell
        /*
            
        if let report = testSLF.enumerated().first(where: {$0.element.reportID == selectedReportID}) {
            print(report)
            
            cell.dateLabel.text = testSLF[report].reportDate
            
            cell.userName.text = testSLF[report].userID
            
            
            let afLink = bug.imageURL
            AF.request(afLink).responseImage { response in
                debugPrint(response)

                print(response.request)
                print(response.response)
                debugPrint(response.result)

                if case .success(let image) = response.result {
                    print("image downloaded: \(image)")
                    cell.reportImg?.image = image
                }
            }
            
            cell.reportImg.image
           // do something with foo.offset and foo.element
        } else {
           // item could not be found
        }
        */
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
