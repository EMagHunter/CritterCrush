//
//  Submission.swift
//  CritterCrush
//
//  Created by min joo on 3/19/23.
//
import UIKit
import Foundation
//custom class to store CSV read object in
class Submission: NSObject {
    //LocationLon,LocationLat,SpeciesName,NumberSpecimens,ReportID,UserID,SpeciesID,VerifyTrueCount,VerifyFalseCount,ReportDate,Image
    
    var locationLon: Float
    var locationLat: Float
    var speciesName: String
    var numberSpecimens: Int
    var reportID: Int
    var userID: Int
    var speciesID: Int
    var verifyTrueCount: Int
    var verifyFalseCount: Int
    var reportDate: String
    //CHANGE REPORTDATE TO DATE LATER
    var imageURL: String
    
    init(locationLon: Float, locationLat: Float, speciesName: String, numberSpecimens: Int, reportID: Int, userID: Int, speciesID: Int, verifyTrueCount: Int, verifyFalseCount: Int, reportDate: String, imageURL: String) {
        self.locationLon = locationLon
        self.locationLat = locationLat
        self.speciesName = speciesName
        self.numberSpecimens = numberSpecimens
        self.reportID = reportID
        self.userID = userID
        self.speciesID = speciesID
        self.verifyTrueCount = verifyTrueCount
        self.verifyFalseCount = verifyFalseCount
        self.reportDate = reportDate
        self.imageURL = imageURL
    }
}
