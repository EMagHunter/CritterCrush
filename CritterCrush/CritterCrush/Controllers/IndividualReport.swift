//
//  IndividualReport.swift
//  CritterCrush
// parses json
//  Created by min joo on 4/2/23.
//
import MapKit
import Foundation

// MARK: - IndividualReport
struct IndividualReport: Codable {
    let data: DataClass
    let status: Int
}

// MARK: - DataClass
struct DataClass: Codable {
    let reportId: Int
    let reportDate: String
    let userID, speciesID, numberSpecimens: Int
    let longitude: Double
    let latitude: Double
    let image: String

    enum CodingKeys: String, CodingKey {
        case reportId = "reportId"
        case reportDate, userID, speciesID, numberSpecimens, longitude, latitude, image
    }
}
