//
//  License+CoreDataProperties.swift
//  
//
//  Created by Tayeb Sedraia on 18/07/2018.
//
//

import Foundation
import CoreData


extension License {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<License> {
        return NSFetchRequest<License>(entityName: "License")
    }

    @NSManaged public var verifie: String?

}
