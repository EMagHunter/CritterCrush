//
//  SettingsViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/9/23.
//GET:
//POST: Change password
//PARAM: User, Token
//200: Success
//400: fail, 201: get json, 401: unauthorized


import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var seePointsSwitch: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editSegue") {
            if let editVC = segue.destination as? EditViewController {
                editVC.usernameData = usernameLabel.text
                editVC.emailData = userEmailLabel.text
            }
        }
    }
    
    @IBAction func onEdit(_ sender: Any) {
    }
    
    @IBAction func onLogout(_ sender: Any) {
        print("Logout clicked")
    }
    
    @IBAction func onDelete(_ sender: Any) {
        print("Delete Data clicked")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
