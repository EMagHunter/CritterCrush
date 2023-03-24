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
