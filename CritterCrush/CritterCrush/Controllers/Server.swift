//
//  Server.swift
//  CritterCrush
//
//  Created by min joo on 5/9/23.
//

import Foundation
import Alamofire
import UIKit

class Server: NSObject {
    var hostname: String
    
    init(hostname: String) {
        self.hostname = hostname
    }
}

let localhost = Server(hostname:"http://69.125.216.66")
