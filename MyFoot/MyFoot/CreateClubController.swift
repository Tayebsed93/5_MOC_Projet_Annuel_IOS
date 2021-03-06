//
//  PlayerController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

struct userClub {
    let logo : UIImage!
    let name : String!
}


class CreateClubController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var players: [Player]?
    var imageclick = ""
    var spinner = UIActivityIndicatorView()
    let imagePicker = UIImagePickerController()
    
    
    
    @IBOutlet weak var nameClub: UITextField!
    
    @IBOutlet weak var namePresident: UITextField!
    
    @IBOutlet weak var motdepasse: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var imageLicense: UIImageView!
    @IBOutlet weak var createClubBtn: UIButton!
    @IBOutlet weak var logoBtn: UIButton!
    @IBOutlet weak var licenseBtn: UIButton!
    
    @IBOutlet weak var twittername: UITextField!
    
    @IBOutlet weak var boutonadd: UIButton!
    
    var clubsStruct = [userClub]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        

        self.view.backgroundColor = GREEN_THEME
    initDesign()
        loadDataLicense()
        if (license?.count)! > 0 {
            if ((license![0].verifie?.description)!) == "true" {
                boutonadd.isEnabled = true
                boutonadd.alpha = 1
            }
            else {
                boutonadd.isEnabled = false
                boutonadd.alpha = 0.5
            }
            
            
        }
        else {
            boutonadd.isEnabled = false
            boutonadd.alpha = 0.5
        }
        
        //boutonadd.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //Boutton cree
        createClubBtn.setTitleColor(.white, for: .normal)
        createClubBtn.setTitle("Ajouter votre club !", for: .normal)
        createClubBtn.layer.cornerRadius = 10
        createClubBtn.backgroundColor = GREENBlACK_THEME
        
        //Boutton logo
        logoBtn.setTitleColor(.white, for: .normal)
        logoBtn.setTitle("Logo", for: .normal)
        logoBtn.layer.cornerRadius = 10
        logoBtn.backgroundColor = GREENBlACK_THEME
        
        //Boutton license
        licenseBtn.setTitleColor(.white, for: .normal)
        licenseBtn.setTitle("License (Scan)", for: .normal)
        licenseBtn.layer.cornerRadius = 10
        licenseBtn.backgroundColor = GREENBlACK_THEME
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if (nameClub.text?.isEmpty)! || (namePresident.text?.isEmpty)!  {
            boutonadd.isEnabled = false
            boutonadd.alpha = 0.5
        }
        
    }
    
    
    func initDesign(){

        namePresident.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        nameClub.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        let attributedPlaceholderTwitter = NSAttributedString(string: "Twitter", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.white])
        twittername.textColor = .white
        twittername.attributedPlaceholder = attributedPlaceholderTwitter
        twittername.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: .white)
        
        
        //Nom du club
        let attributedPlaceholderClub = NSAttributedString(string: "Nom du club", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.white])
        nameClub.textColor = .white
        nameClub.attributedPlaceholder = attributedPlaceholderClub
        nameClub.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: .white)
        
        
        //Nom du president
        let attributedPlaceholderPresident = NSAttributedString(string: "Président du club", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.white])
        namePresident.textColor = .white
        namePresident.attributedPlaceholder = attributedPlaceholderPresident
        namePresident.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: .white)
        
        //Email
        let attributedPlaceholderEmail = NSAttributedString(string: "E-mail", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.white])
        email.textColor = .white
        email.attributedPlaceholder = attributedPlaceholderEmail
        email.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: .white)
        
        //Mot de passe
        let attributedPlaceholderPassword = NSAttributedString(string: "Mot de passe", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.white])
        motdepasse.textColor = .white
        motdepasse.attributedPlaceholder = attributedPlaceholderPassword
        motdepasse.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: .white)
    }
    func createBodyWithParameters(nameClub: String?, parameters: [String: String]?, parametersFile: [String: NSData]?, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }

        let mimetype = "image/png"
        
        var fileName = String()
        var nameClubNoSpace = String()
        if parametersFile != nil {
            for (key, value) in parametersFile! {
                if key == LICENSE_CONSTANTE {
                    nameClubNoSpace = (nameClub?.replacingOccurrences(of: " ", with: "_",
                                                                      options: NSString.CompareOptions.literal, range:nil))!
                    fileName = nameClubNoSpace + "-license.jpg"
                } else { fileName = nameClubNoSpace + "-club.jpg" }
                
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
                body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                body.append(value as Data)
                body.appendString(string: "\r\n")
                body.appendString(string: "--\(boundary)--\r\n")
            }
        }
        return body
    }
    
    func myImageUploadRequest()
    {
        let myUrl = NSURL(string: addressUrlStringProd+clubUrlString);
        
        let request = NSMutableURLRequest(url:myUrl as! URL);
        request.httpMethod = "POST";

        let param = [
            "nom"  : nameClub.text!,
            "name"    : namePresident.text!,
            "password"    : motdepasse.text!,
            "email"    : email.text!,
            "screen_name": twittername.text!,
            "role"      : role_president
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imageData = NSData()
        if imageLogo.image != nil
        {
            imageData = UIImagePNGRepresentation(imageLogo.image!)! as NSData
        }
    
        
        let paramFile = [
            LOGO_CONSTANTE  : imageData
        ]
        
        
        request.httpBody = createBodyWithParameters(nameClub: nameClub.text, parameters: param, parametersFile: paramFile, boundary: boundary) as Data
        
        showActivityIndicatory()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("Response = \(response)")
            
            // Print out reponse body
            if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                print("Response data = \(responseString)")
                
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                if let messageError = json!["message"]
                {
                    self.alerteMessage(message: messageError as! String)
                }
                if let messageSucess = json!["message_club"]
                {
                    self.alerteMessage(message: messageSucess as! String)
                }
                
                DispatchQueue.main.async()
                    {
                        self.spinner.stopAnimating()
                    }

            
            }catch
            {
                DispatchQueue.main.async()
                {
                    //self.alerteMessage(message: ERROR_CONSTANTE as! String)
                    self.spinner.stopAnimating()
                }
                print(error)
            }
        }
        
        task.resume()
    }

    
    @IBAction func boutonCreeClub(_ sender: Any) {
        myImageUploadRequest()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }

    //Enleve le clavier
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //passworkTxt.resignFirstResponder()
        view.endEditing(true)
    }
    
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let vc = navVC.viewControllers.first as! ReconaissanceController
        
        vc.name = nameClub.text!
    }
    
    //Clique sur le bouton ajouter logo
    @IBAction func boutonAjoutLicense(_ sender: Any) {
        imageclick = LICENSE_CONSTANTE

        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReconaissanceController") as? ReconaissanceController {
            viewController.name = namePresident.text!
            viewController.club = nameClub.text!
            setupDataReconaissance(_name: namePresident.text!, _club: nameClub.text!)

            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    
    //Clique sur le bouton ajouter logo
    @IBAction func boutonAjoutLogo(_ sender: Any) {
    imageclick = LOGO_CONSTANTE
    openPhotoLibrary()
    }
    
    //Fonction qui récupère l'image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if imageclick == LOGO_CONSTANTE {
                self.imageLogo.image  = image
            }
 
        }
        picker.dismiss(animated: true)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showActivityIndicatory() {
        self.spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(spinner)
        spinner.startAnimating()
  
    }
}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


