//
//  EditEmailViewController.swift
//  CritterCrush
//
//  Created by Shi Tao Luo on 4/17/23.
//

import UIKit
import Alamofire

class EditEmailViewController: UIViewController {

    @IBOutlet weak var currEmailTextField: UITextField!
    @IBOutlet weak var currEmailResLabel: UILabel!
    
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var newEmailResLabel: UILabel!
    
    var currEmail: String?
    
    @IBAction func onEdit(_ sender: Any) {
        // edge cases: new email is empty and new email is same as current email, and new email is not a valid email
        guard let newEmail = newEmailTextField.text, !newEmail.isEmpty else {
            newEmailResLabel.text = "Make sure your new email is not empty"
            return
        }
        
        guard let currEmail = currEmailTextField.text, currEmail != newEmail else {
            newEmailResLabel.text = "Make sure your new email is different from current email"
            return
        }
        
        if (!isValidEmail(newEmail)) {
            newEmailResLabel.text = "Make sure it is a valid email"
        }
        
        // call the api: /api/userprofile
        let url = "http://69.125.216.66/api/users/userprofile"
        let authToken: String? = KeychainHelper.standard.read(service: "com.crittercrush.authToken", account: "authToken", type: String.self)
        
        let headers: HTTPHeaders = [
            "Authorization": "\(authToken!)"
        ]
        
        let parameter = ["email": newEmail]
        
        AF.request(url, method: .patch, parameters: parameter, encoding: URLEncoding.queryString, headers: headers).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                // Handle success response
                print("Response: \(data)")
                
            case .failure(let error):
                // Handle failure response
                print("Error: \(error)")
            }
            
            if (response.response?.statusCode == 200) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let profileViewController = storyboard.instantiateViewController(withIdentifier: "profile")
                self.navigationController?.pushViewController(profileViewController, animated: true)
            } else {
                self.newEmailResLabel.text = "Email already in use"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currEmailTextField.text = currEmail
    }
    
    // Check if a email is valid
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
