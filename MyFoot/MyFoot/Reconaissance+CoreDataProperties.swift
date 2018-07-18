//
//  Reconaissance+CoreDataProperties.swift
//  
//
//  Created by Tayeb Sedraia on 17/07/2018.
//
//

import Foundation
import CoreData


extension Reconaissance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reconaissance> {
        return NSFetchRequest<Reconaissance>(entityName: "Reconaissance")
    }

    @NSManaged public var club: String?
    @NSManaged public var name: String?

}
