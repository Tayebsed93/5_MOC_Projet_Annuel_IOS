//
//  FacebookUser+CoreDataProperties.swift
//  
//
//  Created by Tayeb Sedraia on 16/07/2018.
//
//

import Foundation
import CoreData


extension FacebookUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FacebookUser> {
        return NSFetchRequest<FacebookUser>(entityName: "FacebookUser")
    }

    @NSManaged public var apikey: String?

}
