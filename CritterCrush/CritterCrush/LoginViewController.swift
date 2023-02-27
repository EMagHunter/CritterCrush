//
//  LoginViewController.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/20/23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var UsernameTextField: UITextField!
    
    
    @IBOutlet weak var ResultLabel: UILabel!
    @IBAction func LoginButton(_ sender: Any) {
        guard let email = UsernameTextField.text else{return}
        guard let password = PasswordTextField.text else{return}
        
        if (UsernameTextField.text == "" && PasswordTextField.text == ""){
            ResultLabel.text = "Enter UserName and password"
        }
        else{
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
