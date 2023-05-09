//
//  SceneDelegate.swift
//  CritterCrush
//
//  Created by Ana Fuentes on 2/20/23.
//

import UIKit
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        if let authToken: String = KeychainHelper.standard.read(service: "com.crittercrush.authToken", account: "authToken", type: String.self) {
            let hostName = localhost
            let url  = "\(localhost)/api/users/userprofile"
            
            let headers: HTTPHeaders = [
                "Authorization": "\(authToken)"
                    ]
            // call /api/users/userprofile end point to get user information
            AF.request(url, method: .get, headers: headers).responseData { response in
                debugPrint(response)
                
                switch response.result {
                case .success(let data):
                    do {
                        // get the email and pass it to settings page
                        // Automatically log the user in using the stored credentials
                        // pull the auth token and store it in user defaults
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        
                        if let responseDict = asJSON as? [String: Any],
                            let dataDict = responseDict["data"] as? [String: Any],
                            let token = dataDict["token"] as? String,  let loginUser = dataDict["userid"] as? Int  {
                            
                            KeychainHelper.standard.save(token, service: "com.crittercrush.authToken", account: "authToken")
                            
                            UserDefaults.standard.set(loginUser, forKey: "userid")
                        }
                        
                        //segue
                        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar")
                        
                        
                        self.window?.rootViewController = viewController
                        if self.window?.rootViewController as? UITabBarController != nil {
                            let tabBarController = self.window!.rootViewController as! UITabBarController
                                tabBarController.selectedIndex = 2 // Opens the 4th Tab
                            }
                    } catch {
                    }
                case .failure(_): break
                }
            }
            
            
        } else {
            // Show the login screen
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
            
            window?.rootViewController = viewController
        }
        
        window?.makeKeyAndVisible()
    }//default screen
    
    func showMainAppScreen() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else { return }
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }//main


func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}

func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}

func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}

func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}

func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


}

