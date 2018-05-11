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

class FacebookLoginViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var imageFacebook: UIImageView!
    @IBOutlet weak var facebookName: UILabel!
    
    var dict : [String : AnyObject]!
    
    struct user {
        let name : String!
        let picture : String!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
        dismissButton.backgroundColor = .white
        dismissButton.setTitleColor(FACEBOOK_COLOR_BLUE, for: .normal)

        //creating button
        let loginButton = LoginButton(readPermissions: [.publicProfile,.email])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        //adding it to view
        view.addSubview(loginButton)
        
        view.backgroundColor = FACEBOOK_COLOR_BLUE
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        //if the user is already logged in
        if let accessToken = AccessToken.current{
            getFBUserData()
            print("User is logged in with acess token: \(AccessToken.current)")
        }

        // Do any additional setup after loading the view, typically from a nib.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dimissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("Cancelled")
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            getFBUserData()
            print("User is logged in with acess token: \(accessToken)")
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        self.facebookName.text = ""
        self.imageFacebook.image = UIImage()
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((AccessToken.current) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(self.dict)
                    let picture = self.dict["picture"]
                    let email = self.dict["email"]
                    let name = self.dict["name"]
                    if let data = picture!["data"] as? [String: Any] {
                        self.facebookName.text = name as! String
                        self.imageFacebook.loadImageUsingUrlString(urlString: data["url"] as! String) 
                    }
                    
                    self.callAPIRegister(name: name as! String, email: email as! String)
                }
            })
        }

    }
    
    func callAPIRegister(name: String, email: String) {
        let urlToRequest = addressUrlStringProd+registerUrlString
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = String(format:"name=%@&email=%@&password=%@",name,email,MDP_DEFAULT)
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        
        let task = session4.dataTask(with: request as URLRequest)
        { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else
            {
                
                print("ERROR: \(error?.localizedDescription)")
                
                self.alerteMessage(message: (error?.localizedDescription)!)
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Response : \n \(dataString)") //JSONSerialization in String
            
            
            //JSONSerialization in Object
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                DispatchQueue.main.async()
                    {
                        print(json)
                        if let apiKey = json["apiKey"]
                        {
                            
                            //self.passData(apiKey: apiKey as! String)
                        }
                        
                        if let messageError = json["message"]
                        {
                            
                            
                            if messageError as! String == "You are successfully registered" {
                                self.alerteMessage(message: messageError as! String)
                                //let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                //let tabVc = storyboard.instantiateViewController(withIdentifier: "LoginController")
                                //self.present(tabVc, animated: true, completion: nil)
                                //self.dismiss(animated: true, completion: nil)
                            }
                            
                            
                        }
                        
                }
                
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    
    //FUNCTION POP UP
    func alerteMessage(message : String) {
        
        var newMessage = ""
        if (message == "Could not connect to the server." ) {
            newMessage = "Impossible de se connecter au serveur."
            
            let alert = UIAlertController(title: "Erreur", message: newMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
