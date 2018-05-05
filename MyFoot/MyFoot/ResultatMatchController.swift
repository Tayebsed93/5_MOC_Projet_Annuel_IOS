//
//  PlayerController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation


struct classement {
    let logo : String!
    let name : String!
}

protocol MyProtocol: class {
    func sendData(date: String)
}

class ResultatMatchController: UITableViewController, MyProtocol {

    
public var adressUrlCountryStringExterne = "https://apifootball.com/api/?action=get_leagues&country_id=173&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
    
    public var adressUrlTeamStringExterne = "https://apifootball.com/api/?action=get_standings&league_id=128&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
    
    
    var date: String?
    func sendData(date: String) {
        self.date = date
        print(date)
    }
    
    var testValue: String = ""
    var classementStruct = [classement]()
    

    
    

    override func viewDidAppear(_ animated: Bool) {

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = GREENBlACK_THEME
        
        self.title = "Résultat des matchs"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        //Recuperer Donnée de la BDD
        classementStruct = []
        callAPI()
        

        //self.tableView.delegate = self
        //self.tableView.dataSource = self
        //self.tableView.reloadData()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (classementStruct.count)
        return 10
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        //Club logo gauche
        var clubImage = cell?.viewWithTag(10) as! UIImageView
        //if let clubImageURLString = classementStruct[indexPath.row].logo {
        //    clubImage.loadImageUsingUrlString(urlString: clubImageURLString)
        //} else{
            clubImage.image = UIImage(named: "psg")
        //}
        
        //Nom club gauche
        let labelClubGauche = cell?.viewWithTag(1) as! UILabel
        //labelHeure.text = classementStruct[indexPath.row].name
        labelClubGauche.text = "Real Madrid"
        
        //Horloge logo
        var horlogeImage = cell?.viewWithTag(2) as! UIImageView
            horlogeImage.image = UIImage(named: "horloge")
        

        
        return cell!
  
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Mardi 25 septembre 2018"
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    
    
    @IBAction func DeconnexionClick(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateClubController") as? CreateClubController {
            /*
             viewController.nationality = self.nationality
             viewController.isPlayer = false
             viewController.curentName = self.curentName
             viewController.curentTag = self.curentTag
             */
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    func callAPI() {
        
        let urlToRequest = adressUrlCountryStringExterne
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
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
                
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [[String:Any]]
                DispatchQueue.main.async()

                    {
                        if let nb = json?.count {
                            for i in 0..<nb {
                                if let league_id = json![i]["league_id"], let league_name = json![i]["league_name"] {
                                    print(league_id)
                                    self.tableView.reloadData()
                                }
                                    
                            }
                        }
 
 
                        
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
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
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        let name = classementStruct[(indexPath?.row)!].name
        
        let alertController = UIAlertController(title: name, message: "Selectionner votre rôle", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Supporter", style: .default) { (action) in
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVc = storyboard.instantiateViewController(withIdentifier: "tbController") as! UITabBarController
            
            ///////// 1er controller
            //Convertie la tabViewController en UINavigationController
            let navigation = tabVc.viewControllers?[0] as! UINavigationController
            
            //Convertie la UINavigationController en UIViewController (Home)
            let homeController = navigation.topViewController as? HomeController
            
            //Change la page vers Home
            self.present(tabVc, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Acteur interne", style: .default) { (action) in
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as? LoginController {
                if let navigator = self.navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
            
        }
        let action3 = UIAlertAction(title: "Annuler", style: .cancel) { (action) in
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
 */
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
