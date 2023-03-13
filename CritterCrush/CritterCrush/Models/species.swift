//
//  species.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 3/12/23.
//

import UIKit

class species: NSObject {
    // place holder -- I will change it to the current one
    var speciesID = ""
    var reportDate = Date()
    var location_Lat = ""
    var location_Long = ""
    var date = Date()
    init (reportDate : Date){
        self.reportDate = reportDate
    }
}
