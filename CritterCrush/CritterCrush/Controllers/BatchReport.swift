//
//  IndividualReport.swift
//  CritterCrush
// parses json
//  Created by min joo on 4/2/23.
//
import MapKit
import Foundation
import UIKit
import Alamofire

// MARK: - IndividualReport
//use individual report

class BatchReport:NSObject {
    
    //get reports using API call
    //last 5 days
    func getReports() -> Array<IndividualReport> {
        let reports = [IndividualReport]()
        
        //use apiReport to return report
        
        
        return reports
    } //get report, return array
    
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
}
