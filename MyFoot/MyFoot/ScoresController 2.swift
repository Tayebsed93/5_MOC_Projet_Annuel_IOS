//
//  ScoresController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 20/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation

struct scorestruct {
    let name : String!
    let email : String!
    let score : Int!
    let picture : String!
}

class ScoresController: UITableViewController {
    
    var scoresStruct = [scorestruct]()
    var passapikey = String()
    
    private let image = UIImage(named: "cancel")!.withRenderingMode(.alwaysTemplate)
    private let topMessage = "Score"
    private let bottomMessage = "L'affichage des scores n'est pas disponible."
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = GREENBlACK_THEME
        
        self.title = "Scores"
        self.tableView.separatorStyle = .none
        //Recuperer Donnée de la BDD
        scoresStruct = []
        callAPIScore()
        
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupEmptyBackgroundView()
    }
    
    // MARK: - Empty Data
    func setupEmptyBackgroundView() {
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableView.backgroundView = emptyBackgroundView
        self.tableView.backgroundView?.isHidden = true
        
    }
    
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.scoresStruct = []
            self?.callAPIScore()
            self?.tableView.reloadData()
        })
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (scoresStruct.count)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.selectionStyle = .none
        
        //Logo
        var logo = cell?.viewWithTag(1) as! UIImageView
        if scoresStruct[indexPath.row].picture != "", let pictureURLString = scoresStruct[indexPath.row].picture {
            cell?.imageView?.loadImageUsingUrlString(urlString: pictureURLString)
        }
        else{
            cell?.imageView?.image = UIImage(named: "profile")
        }
        
        //Name User
        let name = cell?.viewWithTag(2) as! UILabel
        name.text = scoresStruct[indexPath.row].name
        
        //Score User
        let score = cell?.viewWithTag(3) as! UILabel
        let a = Int((scoresStruct[indexPath.row].score)!)
        let b: String = String(a)
        score.text = b + " Point"
            
        
        return cell!
    }
        
    
    
    
    func callAPIScore() {
        
        let apiKey = passapikey
        let urlToRequest = addressUrlStringProd+userUrlString
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        //request.addValue("226f791098549052f704eb37b2ae7999", forHTTPHeaderField: "Authorization")
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
                        
                        if let scores = json["scores"] as? [[String: Any]] {
                            self.tableView.backgroundView?.isHidden = true
                            for scorejson in scores {
                                if let name = scorejson["name"], let email = scorejson["email"], let score = scorejson["score"], var picture = scorejson["picture"] {
                                    
                                    
                                    self.scoresStruct.append(scorestruct.init(name: name as! String, email: email as! String, score: score as! Int, picture: picture as! String))
                                }
                                
                                self.tableView.reloadData()
                            }
                        }
                        
                        print(self.scoresStruct.count)
                        if self.scoresStruct.count == 0 {
                            self.tableView.backgroundView?.isHidden = false
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

