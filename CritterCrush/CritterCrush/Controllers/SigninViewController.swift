//
//  SigninViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/21/23.
//
//GET: sign up approval
//PARAM: email, username, password
//200: Success
//400: fail, 201: get json, 401: unauthorized

import UIKit
import Alamofire

class SigninViewController: UIViewController {
    
    
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
            let url  = "http://69.125.216.66/api/users/register"
            let paremeter = ["username": UsernameTextField.text!, "password": PasswordTextField.text!, "email": EmailTextField.text!]
            AF.request(url, method: .post, parameters: paremeter, encoding: URLEncoding.queryString).responseData { response in
                debugPrint(response)
                
                switch response.result {
                case .success(let data):
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        if let responseDict = asJSON as? [String: Any], let dataDict = responseDict["data"] as? [String: Any], let token = dataDict["token"] as? String {
                            UserDefaults.standard.set(token, forKey: "authToken")
                        }
                        user.username = self.UsernameTextField.text
                        user.email = self.EmailTextField.text
                    } catch {
                        self.ResultLabel.text = "A user already exists"
                    }
                case .failure(_): break
                }
                
                // check if user exists in database
                if (response.response?.statusCode == 200) {
                    self.performSegue(withIdentifier: "signupSegue", sender: self)
                } else {
                    self.ResultLabel.text = "A user already exists"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // Check if a email is valid
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
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
