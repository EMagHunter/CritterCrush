//
//  EditPasswordViewController.swift
//  CritterCrush
//
//  Created by Shi Tao Luo on 4/17/23.
//

import UIKit
import Alamofire

class EditPasswordViewController: UIViewController {

    
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    @IBOutlet weak var passResLabel: UILabel!
    
    @IBAction func onEdit(_ sender: Any) {
        // form validation
        guard let newPass = newPassTextField.text, newPass.count >= 8 else {
            passResLabel.text = "Make sure your new password is greater than 8 characters"
            return
        }
        
        
        guard let confirmPass = confirmPassTextField.text, newPass == confirmPass else {
            passResLabel.text = "Make sure your new password is same"
            return
        }
        
        // call the api: /api/userprofile
        let hostName = localhost.hostname
        let url = "\(hostName)/api/users/userprofile"
        let authToken: String? = KeychainHelper.standard.read(service: "com.crittercrush.authToken", account: "authToken", type: String.self)
        
        let headers: HTTPHeaders = [
            "Authorization": "\(authToken!)"
        ]
        
        let parameter = ["password": newPass]
        
        AF.request(url, method: .patch, parameters: parameter, encoding: URLEncoding.queryString, headers: headers).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                // Handle success response
                print("Response: \(data)")
                
                // save the new auth token
                do {
                    if let asJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let token = asJSON["data"] as? String {
                        KeychainHelper.standard.save(token, service: "com.crittercrush.authToken", account: "authToken")
                    }
                } catch {
                    
                }
                
                
            case .failure(let error):
                // Handle failure response
                print("Error: \(error)")
            }
            
            if (response.response?.statusCode == 200) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let profileViewController = storyboard.instantiateViewController(withIdentifier: "profile")
                self.navigationController?.pushViewController(profileViewController, animated: true)
            } else {
                self.passResLabel.text = "Error: Try Again Later"
            }
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
