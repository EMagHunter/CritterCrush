//
//  LoginViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/20/23.
//MARK: API CALLS
//GET: authentication token
//PARAM: username, password
//200: Success
//400: fail, 201: get json, 401: unauthorized

import UIKit
import Alamofire

struct user {
    static var username: String?
    static var password: String?
    static var email: String? 
}

class LoginViewController: UIViewController {
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var ResultLabel: UILabel!
    
    var responseBody: Any?
    
    @IBAction func LoginButton(_ sender: Any) {
        guard let username = UsernameTextField.text, !username.isEmpty else {
            ResultLabel.text = "Please enter username"
            return
        }
        
        guard let password = PasswordTextField.text, !password.isEmpty else {
            ResultLabel.text = "Please enter password"
            return
        }
        let hostname = "69.125.216.66"
        let url  = "http://\(hostname)/api/users/login"
        let paremeter = ["username": username, "password": password]
        
        // Call /api/users/login end point
        AF.request(url, method: .get, parameters: paremeter, encoding: URLEncoding.queryString).responseData { response in
            debugPrint(response)
            
            switch response.result {
            case .success(let data):
                do {
                    // pull the auth token and store it in user defaults
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    
                    if let responseDict = asJSON as? [String: Any],
                        let dataDict = responseDict["data"] as? [String: Any],
                        let token = dataDict["token"] as? String,  let loginUser = dataDict["userid"] as? Int  {
                        
                        KeychainHelper.standard.save(token, service: "com.crittercrush.authToken", account: "authToken")
                        
                        UserDefaults.standard.set(loginUser, forKey: "userid")
                    }
                    
                    // pass username and password to struct
                    user.username = username
                    user.password = password
                } catch {
                }
            case .failure(_): break
            }
            
            // if response is success, perform segue
            if (response.response?.statusCode == 200) {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                self.ResultLabel.text = "Incorrect Username or Password"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
}
