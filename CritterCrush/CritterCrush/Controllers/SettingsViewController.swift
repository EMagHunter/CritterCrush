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
        // test edit
    }
    
    @IBAction func onLogout(_ sender: Any) {
        // Remove the auth token
        UserDefaults.standard.removeObject(forKey: "authToken")
        
        // redirect user to login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "login")
        self.present(loginViewController, animated: true, completion: nil)
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
        
        // get the auth token from user defaults
        if let authToken = UserDefaults.standard.string(forKey: "authToken") {
            // set the header for the AF request
            let headers: HTTPHeaders = [
                "Authorization": authToken
            ]
            
            // call /api/users/userprofile end point to get user information
            AF.request(url, method: .get, headers: headers).responseData { response in
                debugPrint(response)

                switch response.result {
                case .success(let data):
                    do {
                        // get the email
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
}
