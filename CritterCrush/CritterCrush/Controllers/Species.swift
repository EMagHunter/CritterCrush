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
    var color: UIColor

    let salmon = UIColor(red: 1.00, green: 0.54, blue: 0.53, alpha: 1.00)
        
    let mustard = UIColor(red: 0.96, green: 0.64, blue: 0.38, alpha: 1.00)
        
    let periwinkle = UIColor(red: 0.59, green: 0.69, blue: 0.97, alpha: 1.00)
        
    let jade = UIColor(red: 0.49, green: 0.70, blue: 0.58, alpha: 1.00)
    
    //initialize
    init(name: String, science: String, id: Int){
        self.name = name
        self.science = science
        self.id = id
        
        
        switch self.id {
        case 1:
            self.color = jade
        case 2:
            self.color = mustard
        case 3:
            self.color = salmon
        case 4:
            self.color = periwinkle
        default:
            self.color = .black
        }
        
    }//init
    
}


//global variables of Species
let SLF = Species(name: "Spotted lanternfly", science: "Lycorma delicatula", id: 1)
let ALB = Species(name: "Asian longhorned beetle", science: "Anoplophora glabripennis", id: 2)
let EAB = Species(name: "Emerald ash borer", science:"Agrilus planipennis", id: 3)
let SPM = Species(name: "Spongy moth", science:"Lymantria dispar", id: 4)

let speciesList = [SLF,ALB,EAB,SPM]
