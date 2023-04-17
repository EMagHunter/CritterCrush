//
//  EditEmailViewController.swift
//  CritterCrush
//
//  Created by Shi Tao Luo on 4/17/23.
//

import UIKit

class EditEmailViewController: UIViewController {

    @IBOutlet weak var currEmailTextField: UITextField!
    @IBOutlet weak var currEmailResLabel: UILabel!
    
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var newEmailResLabel: UILabel!
    
    @IBAction func onEdit(_ sender: Any) {
        // edge cases: new email is empty and new email is same as current email, and new email is not a valid email
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currEmailTextField.text = user.email

    }
    
    // Check if a email is valid
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
