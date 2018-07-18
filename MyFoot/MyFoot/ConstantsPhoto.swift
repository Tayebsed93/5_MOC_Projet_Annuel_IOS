//
//  ConstantsPhoto.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 04/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit

enum ConstantsPhoto{
    struct UI {
        static let contentWidth: CGFloat                 = 280.0
        static let dialogHeightSinglePermission: CGFloat = 260.0
        static let dialogHeightTwoPermissions: CGFloat   = 360.0
        static let dialogHeightThreePermissions: CGFloat = 460.0
    }
    
    struct NSUserDefaultsKeys {
        static let requestedInUseToAlwaysUpgrade = "PS_requestedInUseToAlwaysUpgrade"
        static let requestedBluetooth            = "PS_requestedBluetooth"
        static let requestedMotion               = "PS_requestedMotion"
        static let requestedNotifications        = "PS_requestedNotifications"
    }
    
    struct InfoPlistKeys {
        static let locationWhenInUse             = "NSLocationWhenInUseUsageDescription"
        static let locationAlways                = "NSLocationAlwaysUsageDescription"
    }
}

