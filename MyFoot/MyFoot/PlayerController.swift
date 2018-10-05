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
    var name : String!
    let age : Int
}

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

class PlayerController: UITableViewController {
    

    var playerStruct = [players]()
    var nb: Int = 0
    var nationality = String()
    var name = String()
    var apikey = String()
    var curentName = String()
    var curentTag = Int()
    var curentPost = String()
    var dispositif = String()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //Recuperer Donnée de la BDD
        callAPIPlayer()
        
        

        self.title = nationality
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
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
        let paramString = String(format:"nationality=%@&position=%@",self.nationality, self.curentPost)
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
                                
                                for i in 0..<self.playerStruct.count {
                                    if self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key0) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key1) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key2) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key3) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key4) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key5) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key6) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key7) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key8) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key9) || self.playerStruct[i].name == defaults.string(forKey: defaultsKeys.key10) {
                                        self.playerStruct.remove(at: i)
                                    }
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
        
        if dispositif == qqd {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
                viewController.nationality = self.nationality
                viewController.isPlayer = false
                viewController.curentName = self.curentName
                viewController.curentTag = self.curentTag
                viewController.dispositif = qqd
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: false)
                }
            }
        }
        else if dispositif == qtt {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController433") as? CompositionController433 {
                viewController.nationality = self.nationality
                viewController.isPlayer = false
                viewController.curentName = self.curentName
                viewController.curentTag = self.curentTag
                viewController.dispositif = qtt
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: false)
                }
            }
        }
        
        
        
    }
    

    @IBAction func DeconnexionClick(_ sender: Any) {
        
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
