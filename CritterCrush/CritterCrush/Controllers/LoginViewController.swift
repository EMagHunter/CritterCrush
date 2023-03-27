//
//  LoginViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/20/23.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController {
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var ResultLabel: UILabel!
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
            debugPrint(response)
            if (response.response?.statusCode == 200) {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                self.ResultLabel.text = "Incorrect username or password"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
