//
//  SigninViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/21/23.
//https://www.youtube.com/watch?v=-cYLkXKNDJA
//GET: sign up approval
//PARAM: email, username, password
//200: Success
//400: fail, 201: get json, 401: unauthorized

import UIKit
import Alamofire

class SigninViewController: UIViewController {
    
    var userLogin: Int = 0
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
        
    @IBOutlet weak var ResultLabel: UILabel!
    @IBAction func SignupButton(_ sender: Any) {
        
        if(UsernameTextField.text == "" || PasswordTextField.text == "" || rePasswordTextField.text == "" || EmailTextField.text == ""){
            ResultLabel.text = "Please Fill all the Information"
            // check if the password and repassword or the same
        } else if (!isValidEmail(EmailTextField.text!)) {
            ResultLabel.text = "Please Make Sure Email is Valid"
        } else if (PasswordTextField.text != rePasswordTextField.text) {
            ResultLabel.text = "Please Make Sure Passwords are the Same"
        } else if (PasswordTextField.text!.count < 8) {
            ResultLabel.text = "Please Make Sure Password is greater than 8 characters "
        } else{
            let hostname = localhost.hostname
            let url  = "\(hostname)/api/users/register"
            let paremeter = ["username": UsernameTextField.text!, "password": PasswordTextField.text!, "email": EmailTextField.text!]
            
            // Call /api/users/register end point to create a user
            AF.request(url, method: .post, parameters: paremeter, encoding: URLEncoding.queryString).responseData { response in
                debugPrint(response)
                
                switch response.result {
                case .success(let data):
                    do {
//                      pull the auth token and store it in keychain
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        if let responseDict = asJSON as? [String: Any],
                            let dataDict = responseDict["data"] as? [String: Any],
                            let token = dataDict["token"] as? String,  let loginUser = dataDict["userid"] as? Int  {

                            KeychainHelper.standard.save(token, service: "com.crittercrush.authToken", account: "authToken")
                            
                            self.userLogin = loginUser
                            
                            UserDefaults.standard.set(loginUser, forKey: "userid")
                        }
                        
                        // pass username and password to struct
                        user.username = self.UsernameTextField.text
                        user.email = self.EmailTextField.text
                    } catch {
                        self.ResultLabel.text = "A user already exists"
                    }
                case .failure(_): break
                }
                
                // check if user exists in database
                if (response.response?.statusCode == 200) {
                    UserDefaults.standard.set(self.userLogin, forKey: "userid")
                    
                    self.performSegue(withIdentifier: "signupSegue", sender: self)
                } else {
                    self.ResultLabel.text = "A user already exists"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Check if a email is valid
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
