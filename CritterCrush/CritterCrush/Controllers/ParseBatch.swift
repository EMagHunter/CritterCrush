// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let individualReport = try? JSONDecoder().decode(IndividualReport.self, from: jsonData)

import Foundation
import MapKit

// MARK: - IndividualReport
struct ParseBatch: Codable {
    let data: [Datum]
    let status: Int
}

// MARK: - Datum
class Datum: NSObject, Codable, MKAnnotation{
    let reportID: Int
    let reportDate: String
    let userID, speciesID, numberSpecimens: Int
    let longitude: Double
    let latitude: Double
    let image: String
    
    //MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
    enum CodingKeys: String, CodingKey {
        case reportID = "reportId"
        case reportDate, userID, speciesID, numberSpecimens, longitude, latitude, image
    }
    
    var title: String? {
        .init(speciesList[speciesID-1].name)
    }
}
