//
//  ResultMatch.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 14/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import CollectionKit
import XLPagerTabStrip


class FeedClubController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let team_name = defaults.string(forKey: defaultsssKeys.team_name) else {
            return
        }
        
        print(team_name)
    }
}
extension FeedClubController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "NEWS")
    }
}
