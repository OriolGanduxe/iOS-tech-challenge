//
//  TrackEntity+CoreDataClass.swift
//  
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//
//

import Foundation
import CoreData
import ObjectMapper // TODO

public class TrackEntity: NSManagedObject {

}

extension TrackEntity {
    
    var model: Track {
        get {
            return Track(trackId: Int(trackId), artistName: artistName, trackName: trackName, previewUrl: previewUrl, artworkUrl100: artworkUrl100, primaryGenreName: primaryGenreName, country: country, releaseDate: releaseDate as Date)
        }
    }
}
