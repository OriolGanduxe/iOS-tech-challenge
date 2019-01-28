//
//  ArtistEntity+CoreDataProperties.swift
//  
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//
//

import Foundation
import CoreData

extension ArtistEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtistEntity> {
        return NSFetchRequest<ArtistEntity>(entityName: "ArtistEntity")
    }

    @NSManaged public var artistId: Int32
    @NSManaged public var artistName: String
    @NSManaged public var tracks: Set<TrackEntity>
}

// MARK: Generated accessors for tracks
extension ArtistEntity {

    @objc(addTracksObject:)
    @NSManaged public func addToTracks(_ value: TrackEntity)

    @objc(removeTracksObject:)
    @NSManaged public func removeFromTracks(_ value: TrackEntity)

    @objc(addTracks:)
    @NSManaged public func addToTracks(_ values: NSSet)

    @objc(removeTracks:)
    @NSManaged public func removeFromTracks(_ values: NSSet)
}
