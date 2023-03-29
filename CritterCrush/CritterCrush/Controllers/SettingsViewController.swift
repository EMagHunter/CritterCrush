//
//  SettingsViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/9/23.
//GET:
//POST: Change password
//PARAM: User, Token
//200: Success
//400: fail, 201: get json, 401: unauthorized


import UIKit
import Alamofire

class SettingsViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var seePointsSwitch: UISwitch!
    
    var usernameData = ""
    var userEmailData = ""
    var userPasswordData = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editSegue") {
            if let editVC = segue.destination as? EditViewController {
                editVC.usernameData = usernameLabel.text
                editVC.userEmailData = userEmailLabel.text
            }
        }
    }
    
    @IBAction func onEdit(_ sender: Any) {

    }
    
    @IBAction func onLogout(_ sender: Any) {
        print("Logout clicked")
    }
    
    @IBAction func onDelete(_ sender: Any) {
        print("Delete Data clicked")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = usernameData
        userEmailLabel.text = userEmailData
        
        usernameLabel.text = user.username
        
        let url  = "http://69.125.216.66/api/users/userprofile"
        
        let headers: HTTPHeaders = [
            "Authorization": authToken.token!
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
//            debugPrint(response)
            
            // get the email
            switch response.result {
            case .success(let data):
                do {
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    if let data = asJSON as? [String: Any] {
                        if let dict = data["data"] as? [String: Any], let email = dict["email"] as? String {
                            self.userEmailLabel.text = email
                        }
                    }
                } catch {
                }
            case .failure(_): break
            }
        }
    }
}
