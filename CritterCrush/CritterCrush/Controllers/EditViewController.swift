//
//  EditViewController.swift
//  CritterCrush
//
//  Created by Shi Tao Luo on 3/24/23.
//

import UIKit

class EditViewController: UIViewController {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    var usernameData: String?
    var userEmailData: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.text = userEmailData
    }
}
