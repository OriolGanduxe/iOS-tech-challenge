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
    
    var model: Artist {
        get {
            let modelTracks = self.tracks.map { $0.model }
            return Artist(artistId: Int(artistId), artistName: artistName, tracks: modelTracks)
        }
    }
}
