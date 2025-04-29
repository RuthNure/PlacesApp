//
//  Place+CoreDataProperties.swift
//  PlacesApp
//
//  Created by Michael Bonger on 4/28/25.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: Data?
    @NSManaged public var latitude: Double
    @NSManaged public var longtitude: Double

}

extension Place : Identifiable {

}
