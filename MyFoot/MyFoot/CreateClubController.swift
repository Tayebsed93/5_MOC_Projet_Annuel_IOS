//
//  PlayerController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation

struct userClub {
    let logo : UIImage!
    let name : String!
}



class CreateClubController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var players: [Player]?
    var imageclick = ""
    
    
    @IBOutlet weak var nameClub: UITextField!
    
    @IBOutlet weak var namePresident: UITextField!
    
    @IBOutlet weak var motdepasse: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var imageLicense: UIImageView!
    @IBOutlet weak var createClubBtn: UIButton!
    @IBOutlet weak var logoBtn: UIButton!
    @IBOutlet weak var licenseBtn: UIButton!
    
    
    var clubsStruct = [userClub]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    public var addressUrlString = "http://localhost:8888/FootAPI/API/v1"
    public var clubUrlString = "/club"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //Boutton cree
        createClubBtn.setTitleColor(.white, for: .normal)
        createClubBtn.setTitle("Ajouter votre club !", for: .normal)
        createClubBtn.layer.cornerRadius = 10
        createClubBtn.backgroundColor = GREENBlACK_THEME
        
        //Boutton logo
        logoBtn.setTitleColor(.white, for: .normal)
        logoBtn.setTitle("Photo", for: .normal)
        logoBtn.layer.cornerRadius = 10
        logoBtn.backgroundColor = GREENBlACK_THEME
        
        //Boutton license
        licenseBtn.setTitleColor(.white, for: .normal)
        licenseBtn.setTitle("Photo", for: .normal)
        licenseBtn.layer.cornerRadius = 10
        licenseBtn.backgroundColor = GREENBlACK_THEME
        
        
        //Recuperer Donnée de la BDD
        //callAPIClub()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func callAPIClub() {
        
        let urlToRequest = addressUrlString+clubUrlString
        print(urlToRequest)
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        /*
        guard let nameClub = nameClub.text else {
            return
        }
        
        print(imageLogo.image)
        
        guard let imageLicense = imageLicense.image else {
            return
        }
        guard let imageLogo = imageLogo.image else {
            return
        }
 */
        

        
        var imageStr:String = ""
        if (imageLogo.isEqual(nil)) {
            imageLogo = nil
            
        } else {
            let imageData:Data = UIImagePNGRepresentation(imageLogo.image!)!
            imageStr = imageData.base64EncodedString()
            
        }
        
        //let paramString = String(format:"nom=%@&logo=%@&name=%@&email=%@&password=%@&license=%@",nameClub,imageLogo,namePresident.text!, email.text!, motdepasse.text!,imageLicense)
        let paramString = String(format:"nom=%@&logo=%@&name=%@&email=%@&password=%@&license=%@",nameClub.text!,imageStr ,namePresident.text!, email.text!, motdepasse.text!,"")
        print(paramString)
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
                        
                        if let messageError = json["message"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                        if let messageError = json["message_user"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                        if let messageError = json["message_club"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                        
                }
                
                
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    
    @IBAction func boutonCreeClub(_ sender: Any) {
        callAPIClub()
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }

    
    
    //Enleve le clavier
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //passworkTxt.resignFirstResponder()
        view.endEditing(true)
    }
    
    //Clique sur le bouton ajouter logo
    @IBAction func boutonAjoutLicense(_ sender: Any) {
        imageclick = "License"
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            
            
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.present(picker, animated: true)
            
        } else {
            print("Erreur")
        }
    }
    
    
    //Clique sur le bouton ajouter logo
    @IBAction func boutonAjoutLogo(_ sender: Any) {
    imageclick = "Logo"
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let picker = UIImagePickerController()
                
                
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                self.present(picker, animated: true)
                
            } else {
                print("Erreur")
            }
    }
    
    //Fonction qui récupère l'image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            print(imageclick)
            if imageclick == "Logo" {
                self.imageLogo.image  = image
            }
            else if imageclick == "License" {
                self.imageLicense.image  = image
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
    
    
}


