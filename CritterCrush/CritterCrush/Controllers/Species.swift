//
//  Species.swift
//  CritterCrush
//
//  Created by min joo on 3/9/23.
//

import Foundation
import UIKit

/*
 FOR USE IN SPECIES VIEW, SEARCH FILTERS
//Species:
ID
Name
Scientific Name
*/

class Species: NSObject {
    var name: String
    var science: String
    var id: Int
    
    init(name: String, science: String, id: Int){
        self.name = name
        self.science = science
        self.id = id
    }
}

//global variables of Species
let SLF = Species(name: "Spotted lanternfly", science: "Lycorma delicatula", id: 1)
let ALB = Species(name: "Asian longhorned beetle", science: "Anoplophora glabripennis", id: 2)
let EAB = Species(name: "Emerald ash borer", science:"Agrilus planipennis", id: 3)
let SPM = Species(name: "Spongy moth", science:"Lymantria dispar", id: 4)

let speciesList = [SLF,ALB,EAB,SPM]
