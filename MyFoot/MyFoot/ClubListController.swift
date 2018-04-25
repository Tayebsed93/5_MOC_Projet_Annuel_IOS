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
    let logo : UIImage!
    let name : String!
}

class ClubListController: UITableViewController, UISearchBarDelegate {
    
    var players: [Player]?
    

    
    var clubsStruct = [club]()
    @IBOutlet weak var searchBar: UISearchBar!

    public var addressUrlString = "http://localhost:8888/FootAPI/API/v1"
    public var clubUrlString = "/club"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.title = "Liste des clubs"
        //Recuperer Donnée de la BDD
        clubsStruct = []
        callAPIClub()
        searchBar.text = ""
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = searchBar.text
        
        
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        print("Club nb ")
        print(clubsStruct.count)
        return (clubsStruct.count)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        /*
        var mainImageView = cell?.viewWithTag(1) as! UIImageView
        if let profileImageName = UIImage(named: (players?[indexPath.row].name)!) {
            mainImageView.image = UIImage(named: (players?[indexPath.row].name)!)
        }
        else{
            mainImageView.image = UIImage(named: "profile")
        }
        
        // Nom du joueur
        let name:String
        let labelName = cell?.viewWithTag(2) as! UILabel
        labelName.text = players?[indexPath.row].name
        
        // Age
        let labelAge = cell?.viewWithTag(3) as! UILabel
        let a = Int((players?[indexPath.row].age)!)
        let b: String = String(a)
        labelAge.text = b + " Ans"
        */
        
        let labelName = cell?.viewWithTag(2) as! UILabel
        labelName.text = clubsStruct[indexPath.row].name
        
        
        var paysImage = cell?.viewWithTag(4) as! UIImageView
        paysImage.image = UIImage(named: "France")
        
        var clubImage = cell?.viewWithTag(1) as! UIImageView
        clubImage.image = UIImage(named: "psg")
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //getting the text of that cell
        let currentItem = currentCell.viewWithTag(2) as! UILabel
        
        //self.curentName = currentItem.text!
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Supprimer") { (action, indexPath) in
            print("Suprime", indexPath)
            self.tableView.reloadData()
            
        }
        
        return [delete]
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
    
    
    func callAPIClub() {
        
        let urlToRequest = addressUrlString+clubUrlString
        print(urlToRequest)
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let name = ""
        let logo = ""
        
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
                        if let clubs = json["clubs"] as? [[String: Any]] {
                            
                            for clubjson in clubs {
                                /*
                                if let name = club["nom"]{
                                    
                                    //self.names.append(name as! String)
                                    
                                }
                                if let logo = club["logo"]{
                                    //self.ages.append(age as! Double)
                                }
 */
                                let name = clubjson["nom"]
                                let logo = clubjson["logo"]
                                let myImage = UIImage(named:logo as! String)
                                self.clubsStruct.append(club.init(logo: myImage, name: name as! String))
                                
                                
                                print(clubs.count)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

