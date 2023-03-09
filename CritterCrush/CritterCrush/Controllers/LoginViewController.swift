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
        guard let username = UsernameTextField.text else{return}
        guard let password = PasswordTextField.text else{return}
        
        if (UsernameTextField.text == "" && PasswordTextField.text == ""){
            ResultLabel.text = "Enter UserName and password"
        }
        else{
            let url  = "http://69.125.216.66/api/users/login"
            let paremeter = ["username": username, "password": password]
            AF.request(url, method: .get, parameters: paremeter,encoding: URLEncoding.queryString).response{ response in
                debugPrint(response)
            }
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
