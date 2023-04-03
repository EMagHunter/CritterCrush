//
//  IndividualReport.swift
//  CritterCrush
// parses json
//  Created by min joo on 4/2/23.
//
import MapKit
import Foundation

//{"reportId":1,"reportDate":"2023-03-17T13:38:22","userID":1,"speciesID":1,"numberSpecimens":1,"longitude":0,"latitude":0,"verifyTrueCount":0,"verifyFalseCount":0}

struct IndividualReport: Codable {
    let reportId: Int
    let reportDate: String
    let userID: Int
    let speciesID: Int
    let numberSpecimens: Int
    let longitude: Float
    let latitude: Float
    let verifyTrueCount: Int
    let verifyFalseCount: Int
}
