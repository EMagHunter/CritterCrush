//
//  TestData.swift
//  CritterCrush
//
//  Created by min joo on 3/19/23.
//

import Foundation
import UIKit
import CoreLocation
//initializes an Array for each author that is current assistant to display into table view and to pick quotes from
class TestData:NSObject {
    //goes through csv data
    func getCSVData() -> Array<Submission> {
        
        
        let filename = "test_slf" //LocationLon,LocationLat,SpeciesName,NumberSpecimens,ReportID,UserID,SpeciesID,VerifyTrueCount,VerifyFalseCount,ReportDate,Image

        guard let file = Bundle.main.url(forResource: filename, withExtension: "csv")
                
        else {

            fatalError("Couldn't find \(filename) in main bundle.")
        }
        //use file in bundle
        
        do {
            let contents = try String(contentsOf: file, encoding: String.Encoding.macOSRoman )
            //separate by line
            let lines: [String] = contents.components(separatedBy:"\n")
            //parse by tab
            var library = [[String]]()
            for line in lines {
                library.append(line.components(separatedBy: ","))
            }
            
            var subList = [Submission]()
            
            for q in library {
                
                //let reportID: Int? = Int(q[5])
                /*
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_us")
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from:reportTime)
                print(date)
                 */
                print("line ")
                print(q)
                let newSubmission = Submission(locationLon:Double(q[0])!, locationLat:Double(q[1])!, speciesName:q[2], numberSpecimens:Int(q[3])!, reportID: Int(q[4])!, userID:Int(q[5])!, speciesID:Int(q[6])!, verifyTrueCount:Int(q[7])!,  verifyFalseCount:Int(q[8])!, reportDate: q[9], imageURL:q[10], coordinate: CLLocationCoordinate2D(latitude: Double(q[1])!, longitude: Double(q[0])!), title: q[2]
                );
                
                subList.append(newSubmission)
            }
            
            return subList
            
        }
        catch {
            return []
        }
    }
}

let testData = TestData()
var testSLF:Array<Submission> = testData.getCSVData()
