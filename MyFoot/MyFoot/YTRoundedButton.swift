//
//  YTRoundedButton.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 09/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit

class YTRoundedButton: UIButton {
    
    required init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}


class YTGhostButton: UIButton {
    
    required init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.height / 2
        layer.borderWidth = 2.0
        layer.borderColor = UIColor(red: 231.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0).cgColor
        clipsToBounds = true
    }
}




