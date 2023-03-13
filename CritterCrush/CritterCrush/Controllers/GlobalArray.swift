//
//  GlobalArray.swift
//  CritterCrush
//
//  Created by min joo on 3/13/23.
//
import SwiftUI
import UIKit
import Foundation
import Combine

class GlobalArray: ObservableObject{
    var globalArray : [Any] = []
    //private init(){}
    init(globalArray: [Any]){
        self.globalArray = globalArray
    }
    
    func getArray()->[Any]{
        return globalArray
    }

    func addDataInArray(data : Any){
        globalArray.append(data)
    }
}

let listSpecies = GlobalArray(globalArray: [SLF,ALB,EAB,SPM])
