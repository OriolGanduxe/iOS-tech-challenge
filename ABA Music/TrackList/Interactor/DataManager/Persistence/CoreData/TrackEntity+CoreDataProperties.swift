//
//  TrackEntity+CoreDataProperties.swift
//  
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//
//

import Foundation
import CoreData


extension TrackEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackEntity> {
        return NSFetchRequest<TrackEntity>(entityName: "TrackEntity")
    }

    @NSManaged public var trackId: Int32
    @NSManaged public var artistName: String
    @NSManaged public var trackName: String
    @NSManaged public var previewUrl: String
    @NSManaged public var artworkUrl100: String
    @NSManaged public var primaryGenreName: String
    @NSManaged public var country: String
    @NSManaged public var releaseDate: NSDate

}
