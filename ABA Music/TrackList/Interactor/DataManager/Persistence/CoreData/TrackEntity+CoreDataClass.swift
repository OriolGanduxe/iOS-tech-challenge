//
//  TrackEntity+CoreDataClass.swift
//  
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//
//

import Foundation
import CoreData

public class TrackEntity: NSManagedObject {

}

extension TrackEntity {
    
    // TrackEntity is the persistent form of Track, so we have utility methods to get and set the model
    
    var model: Track {
        get {
            return Track(trackId: Int(trackId), artistName: artistName, trackName: trackName, previewUrl: previewUrl, artworkUrl100: artworkUrl100, primaryGenreName: primaryGenreName, country: country, releaseDate: releaseDate as Date)
        }
    }
    
    convenience init(track: Track, context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    
        self.trackId = Int32(track.trackId)
        self.trackName = track.trackName
        self.artistName = track.artistName
        self.previewUrl = track.previewUrl
        self.artworkUrl100 = track.artworkUrl100
        self.primaryGenreName = track.primaryGenreName
        self.country = track.country
        self.releaseDate = track.releaseDate as NSDate
    }
}
