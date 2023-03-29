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

struct authToken {
    static var token: String?
}

struct user {
    static var username: String?
    static var password: String?
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
        
        let url  = "http://69.125.216.66/api/users/login"
        let paremeter = ["username": username, "password": password]
        
        AF.request(url, method: .get, parameters: paremeter, encoding: URLEncoding.queryString).responseData { response in
//            debugPrint(response)
            
            switch response.result {
            case .success(let data):
                do {
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    if let data = asJSON as? [String: Any] {
                        authToken.token = (data["data"] as! String)
                    }
                    
                    // pass username and password to struct
                    user.username = username
                    user.password = password
                    self.performSegue(withIdentifier: "loginSegue", sender: self)

                } catch {
                    self.ResultLabel.text = "Incorrect username or password"
                }
            case .failure(_): break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
}
