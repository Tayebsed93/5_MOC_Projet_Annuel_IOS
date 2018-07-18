//
//  TabBarDetailMatch.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 03/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TabBarDetailMatch: ButtonBarPagerTabStripViewController {
    
    var homeTeam = String()
    var awayTeam = String()
    var homeScore = String()
    var awayScore = String()
    var homeLogo = String()
    var awayLogo = String()
    var match_id = String()
    var containerVC : ContainerMatch!
    
    var passlogo = String()
    var league_id = String()
    var urlResult = String()
    var passnameclub = String()
    
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
        
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailMatchController") as? DetailMatchController
        //let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClassementController") as? ClassementController
        //child_1?.passnameclub = passnameclub
        //child_1?.passlogo = passlogo
        
        //child_2?.passnameclub = passnameclub
        //child_2?.passlogo = passlogo
        return [child_1!]
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DeconnexionClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func DateClick(_ sender: Any) {
        if let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePopUpViewController") as? DatePopUpViewController {
            popup.showTimePicker = true
            popup.delegate = self as! PopupDelegate
            self.present(popup, animated: true)
            
        }
    }
    
}

extension TabBarDetailMatch: PopupDelegate {
    func popupValueSelected(value: String) {
        if let DetailMatch = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultatMatchController") as? ResultatMatchController {
            let url = DetailMatch.leagueIdURLToLiveMatch(dateDebut: value, dateFin: value)
            DetailMatch.calendrierStruct = []
            DetailMatch.callAPIResultat(urlResult: url)
            
        }
        
        
        
    }
}




