//
//  LoginController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 13/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class LoginController: UIViewController {
    
    var passnameclub = String()
    
    let emailTextField: UITextField = {
        let e = UITextField()
        
        let attributedPlaceholder = NSAttributedString(string: "email", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.white])
        e.textColor = .white
        e.attributedPlaceholder = attributedPlaceholder
        e.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: .white)
        return e
    }()
    
    let passwordTextField: UITextField = {
        let p = UITextField()
        let attributedPlaceholder = NSAttributedString(string: "mot de passe", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.white])
        p.textColor = .white
        p.isSecureTextEntry = true
        p.attributedPlaceholder = attributedPlaceholder
        p.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: .white)
        return p
    }()
    
    let loginButton: UIButton = {
        let l = UIButton(type: .system)
        l.setTitleColor(.white, for: .normal)
        l.setTitle("Connexion", for: .normal)
        l.layer.cornerRadius = 10
        l.backgroundColor = GREENBlACK_THEME
        l.addTarget(self, action: #selector(connexionAction), for: .touchUpInside)
        return l
    }()
    
    let logo: UIImageView = {
        let l = UIImageView()
        //l.image = #imageLiteral(resourceName: "icon")
        l.contentMode = .scaleAspectFill
        l.layer.masksToBounds = true
        l.layer.cornerRadius = 20
        return l
    }()
 
    
    let forgotPassword: UIButton = {
        let f = UIButton(type: .system)
        f.setTitleColor(.white, for: .normal)
        f.setTitle("Mot de passe oublié?", for: .normal)
        f.backgroundColor = GREEN_THEME
        return f
    }()
    
    let haveAccountButton: UIButton = {
        let color = GREENBlACK_THEME
        let font = UIFont.systemFont(ofSize: 16)
        
        let h = UIButton(type: .system)
        h.backgroundColor = GREEN_THEME
        let attributedTitle = NSMutableAttributedString(string:
            "Pas encore de compte? ", attributes: [NSAttributedStringKey.foregroundColor:
                color, NSAttributedStringKey.font : font ])
        
        attributedTitle.append(NSAttributedString(string: "Crée ton club", attributes:
            [NSAttributedStringKey.foregroundColor: UIColor.white,
             NSAttributedStringKey.font: font]))
        
        h.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        h.setAttributedTitle(attributedTitle, for: .normal)
        return h
    }()
    
    

    
    
    public var mutableURLRequest: NSMutableURLRequest!
    public var url: NSURL?
    public var addressUrlString = "http://localhost:8888/FootAPI/API/v1"
    public var addressUrlStringProd = "http://poubelle-connecte.pe.hu/FootAPI/API/v1"
    var test = ""
    
    var api:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = GREEN_THEME
        
        setupAddLogo()
        setupTextFieldComponents()
        setupLoginButton()
        setupForgotPsswdButton()
        setupHaveAccountButton()
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func signupAction() {
        //let signupcontroller = CreateClubController()
        //navigationController?.pushViewController(signupcontroller, animated: true)
    }
    
    @objc func connexionAction() {
        callAPILogin()
        //let signupcontroller = SignupController()
        //navigationController?.pushViewController(signupcontroller, animated: true)
    }
    
    fileprivate func setupAddLogo() {
        view.addSubview(logo)
        if #available(iOS 11.0, *) {
            logo.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 64, bottom: nil,
                         bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0,
                         height: 150, width: 150)
        } else {
            // Fallback on earlier versions
        };if #available(iOS 11.0, *) {
            logo.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 64, bottom: nil,
                         bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0,
                         height: 150, width: 150)
        } else {
            // Fallback on earlier versions
        }
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupTextFieldComponents() {
        setupEmailField()
        setupPasswordField()
    }
    
    fileprivate func setupEmailField() {
        view.addSubview(emailTextField)
        
        emailTextField.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0,
                               left: view.leftAnchor, leftPad: 24, right: view.rightAnchor,
                               rightPad: 24, height: 30, width: 0)
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupPasswordField() {
        view.addSubview(passwordTextField)
        
        passwordTextField.anchors(top: emailTextField.bottomAnchor, topPad: 8, bottom: nil,
                                  bottomPad: 0, left: emailTextField.leftAnchor, leftPad: 0,
                                  right: emailTextField.rightAnchor, rightPad: 0, height: 30, width: 0)
    }
    
    fileprivate func setupLoginButton() {
        view.addSubview(loginButton)
        
        loginButton.anchors(top: passwordTextField.bottomAnchor, topPad: 12, bottom: nil,
                            bottomPad: 0, left: passwordTextField.leftAnchor, leftPad: 0,
                            right: passwordTextField.rightAnchor, rightPad: 0, height: 50, width: 0)
    }
    
    fileprivate func setupForgotPsswdButton() {
        view.addSubview(forgotPassword)
        
        forgotPassword.anchors(top: loginButton.bottomAnchor, topPad: 8, bottom: nil,
                               bottomPad: 0, left: loginButton.leftAnchor, leftPad: 0,
                               right: loginButton.rightAnchor, rightPad: 0, height: 30, width: 0)
    }
    
    fileprivate func setupHaveAccountButton() {
        view.addSubview(haveAccountButton)
        
        if #available(iOS 11.0, *) {
            haveAccountButton.anchors(top: nil, topPad: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      bottomPad: 8, left: view.leftAnchor, leftPad: 12, right: view.rightAnchor,
                                      rightPad: 12, height: 30, width: 0)
        } else {
            // Fallback on earlier versions
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func callAPILogin() {
        let urlToRequest = addressUrlStringProd+loginUrlString
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = String(format:"email=%@&password=%@",emailTextField.text!,passwordTextField.text!)
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
            
            
            //JSONSerialization in Object
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                DispatchQueue.main.async()
                    {
                        print(json)
                        if let apiKey = json["apiKey"], let role = json["role"], let name_club = json["name_club"]
                        {
                            if name_club as! String == self.passnameclub {
                                self.passData(role: role as! String, apiKey: apiKey as! String)
                            }
                            else {
                                self.alerteMessage(message: "Vous n'êtes pas enregistré en tant que membre de ce club : " + self.passnameclub )
                            }
                            
                        }
                        
                        if let messageError = json["message"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                        
                }
                /*
                 DispatchQueue.main.async() {
                 self.dismiss(animated: true, completion: nil)
                 }
                 */
                
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    func passData(role:String, apiKey : String) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        print("Tayeb " ,role)
        
        if role == "president" {
            print("Passe")
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ActualityTableViewController") as? ActualityTableViewController {
                if let navigator = self.navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }


    }
    
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
    
    //Enleve le clavier
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //passworkTxt.resignFirstResponder()
        view.endEditing(true)
    }
    
    
}




