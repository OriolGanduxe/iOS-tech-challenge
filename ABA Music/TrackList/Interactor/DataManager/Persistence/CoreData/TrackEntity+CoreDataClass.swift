//
//  TrackEntity+CoreDataClass.swift
//  
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//
//

import Foundation
import CoreData
import ObjectMapper

public class TrackEntity: NSManagedObject {

}

extension TrackEntity {
    
    var model: Track {
        get {
            return Track(trackId: Int(trackId), artistName: artistName, trackName: trackName, previewUrl: previewUrl, artworkUrl100: artworkUrl100, primaryGenreName: primaryGenreName, country: country, releaseDate: releaseDate as Date)
        }
    }
}

// TODO
//extension TrackEntity: Mappable {
//
//    public func mapping(map: Map) {
//
//
//
////    @NSManaged public var trackId: Int32        @NSManaged public var artistName: String?
////        @NSManaged public var trackName: String?
////        @NSManaged public var previewUrl: String?
////        @NSManaged public var artworkUrl100: String?
////        @NSManaged public var primaryGenreName: String?
////        @NSManaged public var country: String?
////        @NSManaged public var releaseDate: NSDate?
//
//    }
//
//
//}
