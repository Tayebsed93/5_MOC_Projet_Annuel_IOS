//
//  FacebookLoginViewController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 11/05/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit

class FacebookLoginViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    var dict : [String : AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
        dismissButton.backgroundColor = .white
        dismissButton.setTitleColor(FACEBOOK_COLOR_BLUE, for: .normal)

        //creating button
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        //adding it to view
        view.addSubview(loginButton)
        
        //if the user is already logged in
        if let accessToken = AccessToken.current{
            getFBUserData()
            print("User is logged in with acess token: \(accessToken)")
        }
        
        view.backgroundColor = FACEBOOK_COLOR_BLUE
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dimissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //when login button clicked
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((AccessToken.current) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(self.dict)
                }
            })
        }
        

    }
    
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
