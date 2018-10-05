//
//  SocialT+CoreDataProperties.swift
//  
//
//  Created by Tayeb Sedraia on 04/10/2018.
//
//

import Foundation
import CoreData


extension SocialT {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SocialT> {
        return NSFetchRequest<SocialT>(entityName: "SocialT")
    }

    @NSManaged public var screen_name: String?

}
