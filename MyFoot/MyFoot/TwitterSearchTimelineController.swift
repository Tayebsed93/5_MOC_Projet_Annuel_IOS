//
//  TwitterSearchTimelineController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 29/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import TwitterKit
import XLPagerTabStrip

class TwitterSearchTimelineController: TWTRTimelineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        // Do any additional setup after loading the view, typically from a nib.
        guard let team_name = defaultsTwitter.string(forKey: TwitterKeys.team_name) else {
            return
        }
        
        
        //let ok = TWTRSearchTimelineDataSource(searchQuery: "OM", apiClient: TWTRAPIClient())
        
        let screen_name = dictionnaryTwitter[team_name]
        print(screen_name)
        let ok = TWTRUserTimelineDataSource(screenName: screen_name!, apiClient: TWTRAPIClient())
        //TWTRSearchTimelineDataSource(searchQuery: "puppies filter:media", apiClient: TWTRAPIClient())
        //ok.resultType = "popular"
        
        self.dataSource = ok
        
        
    }
    
    // NAVIGATION BAR
    func setupNavigationBarItems() {
        self.navigationController?.navigationBar.barTintColor = GREENBlACK_THEME
        setupRemainingNavItems()
    }
    
    private func setupRemainingNavItems() {
        //let titleImageView = UIImageView(image: #imageLiteral(resourceName: "title_icon"))
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "twitter-logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titleImageView
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let navBarSeparatorView = UIView()
        navBarSeparatorView.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230)
        view.addSubview(navBarSeparatorView)
        navBarSeparatorView.anchors(top: view.topAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, height: 0, width: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension TwitterSearchTimelineController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TWITTER")
    }
    
}


