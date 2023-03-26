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
