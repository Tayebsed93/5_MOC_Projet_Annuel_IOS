//
//  DetailMatchController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 20/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import XLPagerTabStrip
class DetailMatchController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    struct goalMatch {
        var time_goal : Int!
        let home_scorer : String!
        let score : String!
        let away_scorer: String!
        
    }
    
    struct homeLinupMatch {
        let lineup_player : String!
        let lineup_number : String!
        let lineup_position: String!
        
    }
    

    @IBOutlet weak var headerContenair: UIView!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    var homeTeam = String()
    var awayTeam = String()
    var homeScore = String()
    var awayScore = String()
    var homeLogo = String()
    var awayLogo = String()
    var match_id = String()
    var containerVC : ContainerMatch!
    
    

    var detailGoalStruct = [goalMatch]()
    var detailHomelinupStruct = [homeLinupMatch]()
    
    var selected_segmented = 0
    
    var dict = [String: AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        let nibName = UINib(nibName: "CustomCellLeft", bundle: nil)
        self.tableViewOutlet.register(nibName, forCellReuseIdentifier: "CustomCellLeft")
        
        let nibNameRight = UINib(nibName: "CustomCellRight", bundle: nil)
        self.tableViewOutlet.register(nibNameRight, forCellReuseIdentifier: "CustomCellRight")
        
        let composition = UINib(nibName: "CompositionCell", bundle: nil)
        self.tableViewOutlet.register(composition, forCellReuseIdentifier: "CompositionCell")
        
        if #available(iOS 10.0, *) {
            
            self.tableViewOutlet.refreshControl = UIRefreshControl()
            self.tableViewOutlet.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    
        
        getAPi(){status,tweetsArray,error in
            if status{
                
                for tweet in tweetsArray!{
                    //print("\(tweet)\n")
                    
                }
            }
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = GREY_THEME
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableViewOutlet.refreshControl?.endRefreshing()
            }
            self?.tableViewOutlet.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "segueContainer")
        {
            containerVC = segue.destination as! ContainerMatch
            containerVC.passhomeTeam = homeTeam
            containerVC.passawayTeam = awayTeam
            containerVC.passhomeScore = homeScore
            containerVC.passawayScore = awayScore
            containerVC.passhomeLogo = homeLogo
            containerVC.passawayLogo = awayLogo
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedAction(_ sender: Any) {
        
        if segmented.selectedSegmentIndex == 0 {
            selected_segmented = 0
 
        }
        
        if segmented.selectedSegmentIndex == 1 {
            selected_segmented = 1
            let composition = UINib(nibName: "CompositionCell", bundle: nil)
            self.tableViewOutlet.register(composition, forCellReuseIdentifier: "CompositionCell")
        }
        
        self.tableViewOutlet.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selected_segmented == 0 {
            return detailGoalStruct.count
        } else {
            return detailHomelinupStruct.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CustomCellLeft = tableView.dequeueReusableCell(withIdentifier: "CustomCellLeft", for: indexPath) as! CustomCellLeft
        let CustomCellRight = tableView.dequeueReusableCell(withIdentifier: "CustomCellRight", for: indexPath) as! CustomCellRight
        let CompositionCell = tableView.dequeueReusableCell(withIdentifier: "CompositionCell", for: indexPath) as! CompositionCell
        
        CustomCellLeft.selectionStyle = .none
        CustomCellRight.selectionStyle = .none
        CompositionCell.selectionStyle = .none
        if selected_segmented == 0 {
            if (detailGoalStruct[indexPath.row].home_scorer == "") {
                
                //Nom du buteur
                let away_scorer = CustomCellRight.viewWithTag(1) as! UILabel
                away_scorer.text = detailGoalStruct[indexPath.row].away_scorer
                
                //Logo description
                var logo_description = CustomCellRight.viewWithTag(2) as! UIImageView
                logo_description.image = UIImage(named: LOGO_BALL)
                
                //Minute buteur
                let time_goal = CustomCellRight.viewWithTag(3) as! UILabel
                time_goal.text = detailGoalStruct[indexPath.row].time_goal.description
                
                return CustomCellRight
            } else {
                
                //Nom du buteur
                let home_scorer = CustomCellLeft.viewWithTag(1) as! UILabel
                home_scorer.text = detailGoalStruct[indexPath.row].home_scorer
                
                //Logo description
                var logo_description = CustomCellLeft.viewWithTag(2) as! UIImageView
                logo_description.image = UIImage(named: LOGO_BALL)
                
                //Minute buteur
                let time_goal = CustomCellLeft.viewWithTag(3) as! UILabel
                time_goal.text = detailGoalStruct[indexPath.row].time_goal.description
                return CustomCellLeft
            }
        }
        
        else {
            
            //Nom Titulaire
            let lineup_player = CompositionCell.viewWithTag(1) as! UILabel
            lineup_player.text = detailHomelinupStruct[indexPath.row].lineup_player.description
           
            //Numéro
            let lineup_number = CompositionCell.viewWithTag(2) as! UILabel
            lineup_number.text = detailHomelinupStruct[indexPath.row].lineup_number.description
            
            //Photo Joueur
            var picture_player = CompositionCell.viewWithTag(3) as! UIImageView

            if let picture = UIImage(named: detailHomelinupStruct[indexPath.row].lineup_player.description) {
                picture_player.image = picture
            }
            else {
                picture_player.image = UIImage(named: "profile")
            }
            return CompositionCell
        }
        
    }
    
    

    

    
    public func getAPi(completion: @escaping ((Bool, [String]?, String?)->Void)){
        
        let urlString = "https://apifootball.com/api/?action=get_events&match_id="+match_id+"&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"
        var result = [String]()
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(url!, headers: ["Authorization":"Bearer AAAAAAAAAAAAAAAAAAAAABjczAAAAAAAmpsyum03hAwA3jfPdbcpIrWLwXY%3Dg5wRYqAQUdGvCiPYoWV6vAsJ5ELWctM37PDkaAFXeX1NOFgn8Y"])
            .responseJSON { (response) in
                if response.result.isSuccess{
                    DispatchQueue.main.async { [unowned self] in
                        let json = JSON(response.result.value)
                        let goalscorerArray = json[0]["goalscorer"].arrayValue
                        let cardsArray = json[0]["cards"].arrayValue
                        let lineup = json[0]["lineup"]
                        let home  = lineup["home"]
                        let startinglineupshomeArray = home["starting_lineups"].arrayValue

                        var result = [String]()
                        var image = [String]()
                        for statuses in goalscorerArray{
                            let score = statuses["score"].description
                            let away_scorer = statuses["away_scorer"].description
                            let time_goal = statuses["time"].description
                            let home_scorer = statuses["home_scorer"].description
                            
                            let time_nocaractere = time_goal
                            let time = time_nocaractere.replace(target: " '", withString: "")
                            let timeok = time_nocaractere.replace(target: "'", withString: "")
                            let timeInt = Int(timeok)
                            self.detailGoalStruct.append(goalMatch.init(time_goal: timeInt, home_scorer: home_scorer, score: score, away_scorer: away_scorer))
                            
                    
                        }
                        
                        for homesLine in startinglineupshomeArray{
                            let lineup_player = homesLine["lineup_player"].description
                            let lineup_number = homesLine["lineup_number"].description
                            let lineup_position = homesLine["lineup_position"].description
                            
                            
                            self.detailHomelinupStruct.append(homeLinupMatch.init(lineup_player: lineup_player, lineup_number: lineup_number, lineup_position: lineup_position))
                            
                        }
                        
                        
                        
                     

                    

              self.tableViewOutlet.reloadData()
                        
                        completion(true, result, nil)
                    }
                }
                    
                    
                else{
                    completion(false, nil, "error")
                }
        }
    }
    
    
    
}

extension DetailMatchController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "RESUME")
    }
    
}

