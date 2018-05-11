//
//  PlayerController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation

struct club {
    let logo : String!
    let name : String!
}

class ClubListController: UITableViewController, UISearchBarDelegate {
    

    var clubsStruct = [club]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = GREENBlACK_THEME
        
        self.title = "Liste des clubs"
        self.tableView.separatorStyle = .none
        //Recuperer Donnée de la BDD
        clubsStruct = []
        callAPIClub()

        
        searchBar.text = ""
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = searchBar.text
        
        
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (clubsStruct.count)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        
        let labelName = cell?.viewWithTag(2) as! UILabel
        labelName.text = clubsStruct[indexPath.row].name
        
        
        var paysImage = cell?.viewWithTag(4) as! UIImageView
        paysImage.image = UIImage(named: DRAPEAU_FRANCE_IMG)
        
        //Club logo
        var clubImage = cell?.viewWithTag(1) as! UIImageView
        if let clubImageURLString = clubsStruct[indexPath.row].logo {
            clubImage.loadImageUsingUrlString(urlString: clubImageURLString)
        } else{
            clubImage.image = UIImage(named: EMPTY_LOGO_IMG)
        }
        return cell!
    }
    

    /*
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Supprimer") { (action, indexPath) in
            print("Suprime", indexPath)
            self.tableView.reloadData()
            
        }
        
        return [delete]
    }
 */
    
    
    
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
    
    
    func callAPIClub() {
        
        let urlToRequest = addressUrlStringProd+clubUrlString
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
                
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                DispatchQueue.main.async()
                    {
                        print(json)
                        if let clubs = json["0"] as? [[String: Any]] {
                            
                            for clubjson in clubs {
                                if let name = clubjson["nom"], let logo = clubjson["logo"]{
                                    self.clubsStruct.append(club.init(logo: logo as! String, name: name as! String))
                                }

                                self.tableView.reloadData()
                            }
                        }
                        
                        if let messageError = json["message"]
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        let name = clubsStruct[(indexPath?.row)!].name
        let logo = clubsStruct[(indexPath?.row)!].logo
        
        let alertController = UIAlertController(title: name, message: "Selectionner votre rôle", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Supporter", style: .default) { (action) in
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVc = storyboard.instantiateViewController(withIdentifier: "tbController") as! UITabBarController
            
            /////////****** 1er controller
            //Convertie la tabViewController en UINavigationController
            let navigation = tabVc.viewControllers?[0] as! UINavigationController
            
            //Convertie la UINavigationController en UIViewController (Home)
            let resultatController = navigation.topViewController as? ResultatMatchController
            
            resultatController?.passnameclub = name!
            resultatController?.passlogo = logo!
            //Change la page vers Home
            self.present(tabVc, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Membre", style: .default) { (action) in
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
