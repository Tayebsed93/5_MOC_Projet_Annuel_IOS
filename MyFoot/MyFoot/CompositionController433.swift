//
//  CompositionController433.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 30/09/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//
import Foundation

import UIKit
import Alamofire
import SwiftyJSON


class CompositionController433: UIViewController, UITextFieldDelegate,UINavigationControllerDelegate {
    
    struct defaultsKeys {
        static let key0 = "0"
        static let key1 = "1"
        static let key2 = "2"
        static let key3 = "3"
        static let key4 = "4"
        static let key5 = "5"
        static let key6 = "6"
        static let key7 = "7"
        static let key8 = "8"
        static let key9 = "9"
        static let key10 = "10"
        static let key11 = "11"
    }
    
    var nationality = String()
    var competition_id = Int()
    var stringComposition = String()
    
    var passapikey = String()
    var dates = [Int]()
    var names = [String]()
    var ages = [Double]()
    
    var newapikey = String()
    var nation = [String]()
    
    var players: [Player]?
    //var composition = [String]()
    var composition = [String](repeating: "0", count: 11)
    
    var isPlayer = Bool()
    var isCorrect = false
    
    var curentName = String()
    var curentTag = Int()
    var dispositif = String()
    
    let defaults = UserDefaults.standard
    
    @IBOutlet var BtnGroup: [UIButton]!
    
    
    public var addressUrlString = "http://localhost:8888/FootAPI/API/v1"
    public var addressUrlStringProd = "http://poubelle-connecte.pe.hu/FootAPI/API/v1"
    public var playerUrlString = "/player"
    public var playerUrlCompo = "/composition"
    public var scoreUrl = "/user"
    
    
    
    //let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Composition (4-3-3)"
        
        if isPlayer == true {
            //Supprime tout
            defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            defaults.set(self.passapikey, forKey: defaultsKeys.key11)
            
            //defaults_comp.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            defaults_comp.set(competition_id, forKey: competitionKeys.competition_id)
        }
        else {
            
            
            switch (self.curentTag)
            {
            case 0:
                defaults.set(self.curentName, forKey: defaultsKeys.key0)
                
            case 1:
                defaults.set(self.curentName, forKey: defaultsKeys.key1)
                
            case 2:
                defaults.set(self.curentName, forKey: defaultsKeys.key2)
                
            case 3:
                defaults.set(self.curentName, forKey: defaultsKeys.key3)
                
            case 4:
                defaults.set(self.curentName, forKey: defaultsKeys.key4)
                
            case 5:
                defaults.set(self.curentName, forKey: defaultsKeys.key5)
                
            case 6:
                defaults.set(self.curentName, forKey: defaultsKeys.key6)
                
            case 7:
                defaults.set(self.curentName, forKey: defaultsKeys.key7)
                
            case 8:
                defaults.set(self.curentName, forKey: defaultsKeys.key8)
                
            case 9:
                defaults.set(self.curentName, forKey: defaultsKeys.key9)
                
            case 10:
                defaults.set(self.curentName, forKey: defaultsKeys.key10)
                
                
            default:
                print("Integer out of range")
            }
        }
        
        
        // Getting
        
        if let string0 = defaults.string(forKey: defaultsKeys.key0) {
            BtnGroup[0].setTitle(string0, for: .normal)
            composition[0] = string0
            
        }
        if let string1 = defaults.string(forKey: defaultsKeys.key1) {
            BtnGroup[1].setTitle(string1, for: .normal)
            composition[1] = string1
        }
        
        if let string2 = defaults.string(forKey: defaultsKeys.key2) {
            BtnGroup[2].setTitle(string2, for: .normal)
            composition[2] = string2
        }
        
        if let string3 = defaults.string(forKey: defaultsKeys.key3) {
            BtnGroup[3].setTitle(string3, for: .normal)
            composition[4] = string3
        }
        if let string3 = defaults.string(forKey: defaultsKeys.key4) {
            BtnGroup[4].setTitle(string3, for: .normal)
            composition[3] = string3
        }
        if let string3 = defaults.string(forKey: defaultsKeys.key5) {
            BtnGroup[5].setTitle(string3, for: .normal)
            composition[5] = string3
        }
        if let string3 = defaults.string(forKey: defaultsKeys.key6) {
            BtnGroup[6].setTitle(string3, for: .normal)
            composition[6] = string3
        }
        if let string3 = defaults.string(forKey: defaultsKeys.key7) {
            BtnGroup[8].setTitle(string3, for: .normal)
            //composition.append(string3)
            //composition.insert(string3, at:8)
            composition[8] = string3
        }
        if let string3 = defaults.string(forKey: defaultsKeys.key8) {
            
            BtnGroup[7].setTitle(string3, for: .normal)
            composition[7] = string3
        }
        if let string3 = defaults.string(forKey: defaultsKeys.key9) {
            
            BtnGroup[9].setTitle(string3, for: .normal)
            composition[10] = string3
        }
        if let string3 = defaults.string(forKey: defaultsKeys.key10) {
            
            BtnGroup[10].setTitle(string3, for: .normal)
            composition[9] = string3
        }
        
        self.stringComposition = composition.joined(separator: "; ")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = GREENBlACK_THEME
        
    }
    
    
    func callAPICompo()
    {
        let myUrl = NSURL(string: addressUrlStringProd+playerUrlCompo);
        
        let request = NSMutableURLRequest(url:myUrl as! URL);
        request.addValue(defaults.string(forKey: defaultsKeys.key11)!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST";
        
        let competition_id = defaults_comp.integer(forKey: competitionKeys.competition_id)
        let param = [
            "nation"  : self.nationality,
            "player"    : qtt + stringComposition,
            "competition_id"    : competition_id
            ] as [String : Any]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParameters(parameters: param, boundary: boundary) as Data
        
        
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
                self.alerteMessage(message: "La composition a été crée avec succès" as! String)
            }
            
            
            
            //JSONSerialization in Object
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                DispatchQueue.main.async()
                    {
                        
                        if let message = json["message"]
                        {
                            self.alerteMessage(message: message as! String)
                        }
                        
                        
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: Any]?, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        return body
    }
    
    
    ///
    // Resultat de la compo
    ////
    func callAPIResultCompo() {
        let defaults = UserDefaults.standard
        let urlToRequest = addressUrlStringProd+playerUrlCompoResult
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        
        request.addValue(defaults.string(forKey: defaultsKeys.key11)!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
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
                        if let compositions = json["composition"] as? [[String: Any]] {
                            
                            for composition in compositions {
                                if let _nation = composition["nation"]{
                                    
                                    self.nation.append(_nation as! String)
                                    
                                }
                                if let _api_key = composition["api_key"]{
                                    self.newapikey = _api_key as! String
                                }
                            }
                        }
                        
                        if let messageError = json["message"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                        
                        for na in self.nation {
                            if na == self.nationality {
                                //self.callAPIScore(newkey: self.newapikey)
                                self.isCorrect = true
                                
                            }
                            else {
                                self.isCorrect = false
                            }
                        }
                        
                        if self.isCorrect == true {
                            //self.callAPIScore(newkey: self.newapikey)
                        }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        ;task.resume()
    }
    
    @IBAction func BtnActionGroup(_ sender: UIButton) {
        
        if (((sender as AnyObject).tag == 0))
        {
            selectedButton(curentTag: 0, nationality: self.nationality, curentPost: GOAL, dispositif: qtt)
        }
        else if (((sender as AnyObject).tag == 1))
        {
            selectedButton(curentTag: 1, nationality: self.nationality, curentPost: DEFENSSEUR, dispositif: qtt)
        }
        else if (((sender as AnyObject).tag == 2))
        {
            selectedButton(curentTag: 2, nationality: self.nationality, curentPost: DEFENSSEUR, dispositif: qtt)
        }
        else if (((sender as AnyObject).tag == 3))
        {
            selectedButton(curentTag: 3, nationality: self.nationality, curentPost: DEFENSSEUR, dispositif: qtt)
            
        }
        else if (((sender as AnyObject).tag == 4))
        {
            selectedButton(curentTag: 4, nationality: self.nationality, curentPost: DEFENSSEUR, dispositif: qtt)
            
        }
        else if (((sender as AnyObject).tag == 5))
        {
            selectedButton(curentTag: 5, nationality: self.nationality, curentPost: MILLIEU, dispositif: qtt)
        }
        else if (((sender as AnyObject).tag == 6))
        {
            selectedButton(curentTag: 6, nationality: self.nationality, curentPost: MILLIEU, dispositif: qtt)
        }
        else if (((sender as AnyObject).tag == 7))
        {
            selectedButton(curentTag: 7, nationality: self.nationality, curentPost: ATTAQUANT, dispositif: qtt)
        }
        else if (((sender as AnyObject).tag == 8))
        {
            selectedButton(curentTag: 8, nationality: self.nationality, curentPost: MILLIEU, dispositif: qtt)
            
        }
        else if (((sender as AnyObject).tag == 9))
        {
            selectedButton(curentTag: 9, nationality: self.nationality, curentPost: ATTAQUANT, dispositif: qtt)
            
        }
        else if (((sender as AnyObject).tag == 10))
        {
            selectedButton(curentTag: 10, nationality: self.nationality, curentPost: ATTAQUANT, dispositif: qtt)
        }
    }
    
    
    func selectedButton (curentTag :Int, nationality: String, curentPost: String, dispositif: String) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerController") as? PlayerController {
            viewController.nationality = nationality
            viewController.curentTag = curentTag
            viewController.curentPost = curentPost
            viewController.dispositif = dispositif
            viewController.apikey = defaults.string(forKey: defaultsKeys.key11)!
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    @IBAction func BackButton(_ sender: UIBarButtonItem) {
        //self.dismiss(animated: true, completion: nil)
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    @IBAction func ValiderCompo(_ sender: Any) {
        
        // create the alert
        let alert = UIAlertController(title: "Confirmation", message: "Voulez-vous valider la composition ?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.destructive, handler: { action in
            
        }))
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Oui", style: UIAlertActionStyle.default, handler: { action in
            //self.callAPICompo()
            if self.composition.contains("0") {
                self.alerteMessage(message: "Veuillez selectionner tous les joueurs pour valider la composition")
            }
            else {
                self.callAPICompo()
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            
        }))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
}







