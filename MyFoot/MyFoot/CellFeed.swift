//
//  CellFeed.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 17/06/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import FoldingCell
import UIKit

class CellFeed: FoldingCell {
    
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet weak var lblTest: UILabel!
    
    @IBOutlet weak var imagePostMini: UIImageView!
    @IBOutlet weak var imagePostBig: UIImageView!
    
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
            //openNumberLabel.text = String(number)
        }
    }
    
    var imagePost: String = "" {
        didSet {
            imagePostBig.loadImageUsingUrlString(urlString: imagePost)
            imagePostMini.loadImageUsingUrlString(urlString: imagePost)
        }
    }
    
    var test: String = "" {
        didSet {
            lblTest.text = test
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

// MARK: - Actions ⚡️

extension CellFeed {
    
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
