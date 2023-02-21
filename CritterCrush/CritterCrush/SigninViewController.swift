//
//  SigninViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/21/23.
//

import UIKit

class SigninViewController: UIViewController {

    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var ResultLabel: UILabel!
    @IBAction func SignupButton(_ sender: Any) {
        if(UsernameTextField.text == "" || PasswordTextField.text == ""){
            ResultLabel.text = "Please Enter Username and Password"
        }else{
            //will make an http request using alamofire
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
