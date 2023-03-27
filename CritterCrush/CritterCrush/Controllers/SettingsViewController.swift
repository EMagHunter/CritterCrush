//
//  SettingsViewController.swift
//  CritterCrush
//
//  Created by min joo on 3/9/23.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var seePointsSwitch: UISwitch!
    
    var password: String?
    
    func passData(username: String, email: String) {
        usernameLabel.text = username
        userEmailLabel.text = email
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
