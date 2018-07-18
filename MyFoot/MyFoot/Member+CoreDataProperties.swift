//
//  Member+CoreDataProperties.swift
//  
//
//  Created by Tayeb Sedraia on 18/07/2018.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var apikey: String?

}
