//
//  TabBarDetailMatch.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TabBarFeed: ButtonBarPagerTabStripViewController {
    
    var homeTeam = String()
    var awayTeam = String()
    var homeScore = String()
    var awayScore = String()
    var homeLogo = String()
    var awayLogo = String()
    var match_id = String()
    var containerVC : ContainerMatch!
    
    let graySpotifyColor = UIColor(red: 21/255.0, green: 21/255.0, blue: 24/255.0, alpha: 1.0)
    let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = GREENBlACK_THEME
        settings.style.buttonBarItemBackgroundColor = GREENBlACK_THEME
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = GREEN_OLDCELL
            newCell?.label.textColor = .white
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwitterSearchTimelineController")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedClubController")
        
        
        return [child_1, child_2]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "segueContainer")
        {
            print(homeTeam)
            
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
    
    
    
    
}


