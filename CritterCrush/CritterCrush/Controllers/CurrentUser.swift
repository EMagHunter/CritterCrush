//
//  CurrentUser.swift
//  CritterCrush
//
//  CURRENTLY SIGNED IN USER
//

import UIKit
//IT MIGHT ALSO BE A BETTER DESIGN TO STORE LOG IN USER INFO INTO USERDEFAULTS

class CurrentUser: NSObject {
    var userName: String!
    var userID: Int!
    var loginTime: Date!
    
    init(userName: String, userID: Int){
        self.userName = userName
        self.userID = userID
        loginTime = Date()
    }
    
    func dispose()
        {
            self.userName = nil
            self.userID = nil
            self.loginTime = nil
            print("Disposed Singleton instance")
        }
}
