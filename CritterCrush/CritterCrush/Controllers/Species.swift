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
        self.id = id
        self.science = science
    }
}

//global variables of Species
let SLF = Species(name: "Spotted Lanternfly", science: "Lycorma delicatula", id: 1)
let ALB = Species(name: "Asian Longhorned Beetle", science: "Anoplophora glabripennis", id: 2)
let EAB = Species(name: "Emerald Ash Borer", science:"Agrilus planipennis", id: 3)
let spongy = Species(name: "Spongy Moth", science:"Lymantria dispar", id: 4)
