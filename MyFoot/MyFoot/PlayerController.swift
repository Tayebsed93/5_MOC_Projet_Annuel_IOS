//
//  PlayerController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation

struct players {
    let name : String!
    let age : Int
}

class PlayerController: UITableViewController, UISearchBarDelegate {
    

    var playerStruct = [players]()
    var nb: Int = 0
    var nationality = String()
    var name = String()
    var apikey = String()
    var curentName = String()
    var curentTag = Int()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //Recuperer Donnée de la BDD
        callAPIPlayer()
        
        
        //players?.count
        searchBar.text = ""

        searchBar.isHidden = true
        self.title = nationality
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
    
    
    func callAPIPlayer() {
        
        //let config = URLSessionConfiguration.default
        let urlToRequest = addressUrlStringProd+playerUrlString
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.addValue(apikey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = String(format:"nationality=%@",self.nationality)
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        
        let task = session4.dataTask(with: request as URLRequest)
        { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else
            {
                
                print("ERROR: \(error?.localizedDescription)")
                
                //self.alerteMessage(message: (error?.localizedDescription)!)
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            //JSONSerialization in Object
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                DispatchQueue.main.async()
                    {
                        if let clubs = json["players"] as? [[String: Any]] {
                            
                            for playerjson in clubs {
                                if let name = playerjson["Name"], let age = playerjson["Age"]{
                                    self.playerStruct.append(players.init(name: name as! String, age: age as! Int))
                                }
                                
                                self.tableView.reloadData()
                            }
                        
                        if let messageError = json["message"]
                        {
                            //self.alerteMessage(message: messageError as! String)
                        }
                        
                        
              
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (playerStruct.count)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
    
         var mainImageView = cell?.viewWithTag(1) as! UIImageView
        if let profileImageName = UIImage(named: (playerStruct[indexPath.row].name)!) {
            mainImageView.image = UIImage(named: (playerStruct[indexPath.row].name)!)
            }
            else{
                mainImageView.image = UIImage(named: "profile")
            }
        
        // Nom du joueur
        let name:String
        let labelName = cell?.viewWithTag(2) as! UILabel
        labelName.text = playerStruct[indexPath.row].name
        
        // Age
        let labelAge = cell?.viewWithTag(3) as! UILabel
        let a = Int((playerStruct[indexPath.row].age))
        let b: String = String(a)
        labelAge.text = b + " Ans"
        
        var paysImage = cell?.viewWithTag(4) as! UIImageView
        paysImage.image = UIImage(named: nationality)
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //getting the text of that cell
        let currentItem = currentCell.viewWithTag(2) as! UILabel
        
        self.curentName = currentItem.text!
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Supprimer") { (action, indexPath) in
            print("Suprime", indexPath)
            self.tableView.reloadData()
            
        }
        
        //self.tableView.reloadData()
        return [delete]
    }
    
    
    
    @IBAction func DeconnexionClick(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            viewController.isPlayer = false
            viewController.curentName = self.curentName
            viewController.curentTag = self.curentTag
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: false)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
