//
//  SigninViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/21/23.
//

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
        }
        
        else{
            let url  = "http://69.125.216.66/api/users/register"
            let paremeter = ["username": UsernameTextField.text!, "password": PasswordTextField.text!, "email": EmailTextField.text!]
            AF.request(url, method: .post, parameters: paremeter,encoding: URLEncoding.queryString).response{ response in
                debugPrint(response)
            }
            // need to only go into this segue when the post request is sucessful
            self.performSegue(withIdentifier: "signupSegue", sender: self)
          
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
