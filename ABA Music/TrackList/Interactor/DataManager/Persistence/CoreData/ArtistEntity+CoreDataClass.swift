//
//  ArtistEntity+CoreDataClass.swift
//  
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//
//

import Foundation
import CoreData

@objc(ArtistEntity)
public class ArtistEntity: NSManagedObject {

}

extension ArtistEntity {
    
    // ArtistEntity is the persistent form of Artist, so we have utility methods to get and set the model
    
    var model: Artist {
        get {
            let modelTracks = self.tracks.map { $0.model }
            return Artist(artistId: Int(artistId), artistName: artistName, tracks: modelTracks)
        }
    }
    
    convenience init(artist: Artist, context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.artistId = Int32(artist.artistId)
        self.artistName = artist.artistName
        
        for track in artist.tracks {
            self.addToTracks(TrackEntity(track: track, context: context))
        }
    }
}
