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
    var batchReport:ParseBatch?
    //get reports using API call
    //last 5 days
    func getReports() -> Array<IndividualReport> {
        let reports = [IndividualReport]()
        
        //use apiReport to return report
        //only if unwrapped
        //http://69.125.216.66/api/reports?userid=1
        
        apiReport(userID: 1){ (result: Result<ParseBatch, Error>) in
            switch result {
            case .success(let report):
               // batchReport = report
                print(report)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            print(self.batchReport!.data[0])
            
            
        }//apiReport(userID)

        return reports
    } //get report, return array
    
    func apiReport(userID: Int, completionHandler: @escaping (Result<ParseBatch, Error>) -> Void) {
        //takes report ID of selected report
        //uses
        let hostname = "69.125.216.66"
        let param = ["userid":userID]
        let url = "http://\(hostname)/api/reports"
        
        // make the GET request using Alamofire
        AF.request(url, method:.get, parameters: param,  encoding:URLEncoding.queryString).responseData { response in
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
                        
                        let result = try decoder.decode(ParseBatch.self, from: data)
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