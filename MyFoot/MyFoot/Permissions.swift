//
//  Permissions.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 04/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import Foundation
import CoreLocation
import AddressBook
import AVFoundation
import Photos
import EventKit
import CoreBluetooth
import CoreMotion
import CloudKit
import Accounts

@objc public protocol Permission {
    var type: PermissionType { get }
}

@objc public class NotificationsPermission: NSObject, Permission {
    public let type: PermissionType = .notifications
    public let notificationCategories: Set<UIUserNotificationCategory>?
    public init(notificationCategories: Set<UIUserNotificationCategory>? = nil) {
        self.notificationCategories = notificationCategories
    }
}

@objc public class LocationWhileInUsePermission: NSObject, Permission {
    public let type: PermissionType = .locationInUse
}
/*
 @objc public class LocationAlwaysPermission: NSObject, Permission {
 public let type: PermissionType = .locationAlways
 }
 */
/*
 @objc public class ContactsPermission: NSObject, Permission {
 public let type: PermissionType = .contacts
 }
 */

public typealias requestPermissionUnknownResult = () -> Void
public typealias requestPermissionShowAlert     = (PermissionType) -> Void

/*
 @objc public class EventsPermission: NSObject, Permission {
 public let type: PermissionType = .events
 }
 */

@objc public class MicrophonePermission: NSObject, Permission {
    public let type: PermissionType = .microphone
}

@objc public class CameraPermission: NSObject, Permission {
    public let type: PermissionType = .camera
}

@objc public class PhotosPermission: NSObject, Permission {
    public let type: PermissionType = .photos
}
/*
 @objc public class RemindersPermission: NSObject, Permission {
 public let type: PermissionType = .reminders
 }
 */

@objc public class BluetoothPermission: NSObject, Permission {
    public let type: PermissionType = .bluetooth
}

@objc public class MotionPermission: NSObject, Permission {
    public let type: PermissionType = .motion
}
