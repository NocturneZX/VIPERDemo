//
//  Investor+CoreDataProperties.swift
//  
//
//  Created by Julio Reyes on 8/2/18.
//
//

import Foundation
import CoreData


extension Investor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Investor> {
        return NSFetchRequest<Investor>(entityName: "Investor")
    }

    @NSManaged public var investorAchievements: String?

}
