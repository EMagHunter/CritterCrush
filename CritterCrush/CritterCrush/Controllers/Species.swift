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
    var desc: String
    var risk: String
    var link: URL
    
    //SLF
    let salmon = UIColor(red: 1.00, green: 0.54, blue: 0.53, alpha: 1.00)
    let desc1 = "The Spotted lanternfly (SLF) is an invasive species from Asia, first discovered in the US in 2014. It feeds primarily on trees of heaven (Ailanthus altissima) but can feed on a wide variety of plants such as maple, walnut, fruit trees and more."
    let risk1 = "The SLF can fly short distances, and is also spread through human activity. It lays its eggs on vehicles, furniture, stone, etc., which are then transported to new areas causing spread. The Spotted lanternfly poses a threat to New York's forests, as well as its agriculture and tourism industry."
    let link1 = URL(string:"https://www.dec.ny.gov/animals/113303.html")
    
    //ALB
    let mustard = UIColor(red: 0.96, green: 0.64, blue: 0.38, alpha: 1.00)
    let desc2 = "The Asian longhorned beetle (ALB) is an invasive wood-boring insect from China and Korea that feeds on hardwoods such as maple, willow, birch, etc. They are black and shiny with distinctive white marking and spots on wing covers and antennae. They were found in Brooklyn maple trees in 1996, likely hitchhiking from China shipping. The ALB pose a threat to the hardwood and maple industry and they compromise the structural integrity of the tree."
    let risk2 = "Currently, Manhattan, eastern Queens, Staten Island, and Islip infestation sites have been eradicated. International standards have been set to require chemically treated or kiln dried wooden packing materials to reduce introductions. Quarantines have been established in infested areas and tree treatment and removal in NYC. If you have a pool, check your filter for anything resembling an ALB when cleaning."
    let link2 = URL(string:"https://www.dec.ny.gov/animals/7255.html")
    
    //EAB
    let periwinkle = UIColor(red: 0.59, green: 0.69, blue: 0.97, alpha: 1.00)
    let desc3 = "The emerald ash borer (EAB) is an invasive beetle from Asia that kills North American ash species (Fraxinus sp.). The first EAB infestation to be discovered in NYS was in 2009. All of New York’s native ash trees are prone to EAB damage, and as of summer 2022, EAB is present in almost all of New York’s counties, even in NYC. They are very small but destructive. The adults are smaller than a penny and seen from late May through early September, and most common in June and July."
    let risk3 = "Increased woodpecker activity is often a first sign of EAB infestation, which can lead to large strips of bark falling off. Beneath the bark, S-shaped larval galleries may be visible. Most trees die within 2 to 4 years of infestation. The EAB spread has been directly traced to ash firewood or ash nursery stock, and other ash products like chips and mulch generally present less risk. NYS has a regulation restricting movement of firewood to protect its forests."
    let link3 = URL(string:"https://www.dec.ny.gov/animals/7253.html")
      
    //SPM
    let jade = UIColor(red: 0.49, green: 0.70, blue: 0.58, alpha: 1.00)
    let desc4 = "The Spongy Moth is a non native insect from France that has naturalized itself in New York forest communities, so they will always be around. Their caterpillars are known to feed on the leaves of a wide variety of trees, and oak is their preferred tree. Their populations are naturally controlled by predation, disease, and temperature in NYS. Their cyclical outbreaks are every 10-15 years in NY, and they are destructive at high population levels."
    let risk4 = "The DEC does not provide funding for controlling spongy moths on private property, and their populations are typically not managed unless the forests are ecologically or culturally protected. Spongy moth catepillars and adults can be killed by squishing, and egg masses can be destroyed by scraping off trees and structures and dropped into a container of detergent."
    let link4 = URL(string:"https://www.dec.ny.gov/animals/83118.html")
    
    //initialize
    init(name: String, science: String, id: Int){
        self.name = name
        self.science = science
        self.id = id
        
        
        switch self.id {
        case 1:
            self.color = jade
            self.desc = desc1
            self.risk = risk1
            self.link = link1!
        case 2:
            self.color = mustard
            self.desc = desc2
            self.risk = risk2
            self.link = link2!
        case 3:
            self.color = salmon
            self.desc = desc3
            self.risk = risk3
            self.link = link3!
        case 4:
            self.color = periwinkle
            self.desc = desc4
            self.risk = risk4
            self.link = link4!
        default:
            self.color = .black
            self.desc = desc1
            self.risk = risk1
            self.link = link1!
        }
        
    }//init
    
}


//global variables of Species
let SLF = Species(name: "Spotted lanternfly", science: "Lycorma delicatula", id: 1)
let ALB = Species(name: "Asian longhorned beetle", science: "Anoplophora glabripennis", id: 2)
let EAB = Species(name: "Emerald ash borer", science:"Agrilus planipennis", id: 3)
let SPM = Species(name: "Spongy moth", science:"Lymantria dispar", id: 4)

let speciesList = [SLF,ALB,EAB,SPM]
