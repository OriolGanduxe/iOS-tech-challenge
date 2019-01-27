//
//  TracksPersistenceDataManager.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation
import CoreData

typealias StoreResults = (Result<Void>) -> Void

protocol TracksPersistenceDataProvider: class {
    func cachedArtists(query: String, completion: FetchArtistsResults)
    func storeArtists(artists: [Artist], completion: StoreResults)
}

class TracksPersistenceDataManager: TracksPersistenceDataProvider {
    
    func cachedArtists(query: String, completion: FetchArtistsResults) {
                
        let request: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
        request.predicate = NSPredicate(format: "artistName CONTAINS %@", query)
        
        do {
            let artists = try CoreDataStack.managedObjectContext.fetch(request)
            let models = artists.map { $0.model }
            completion(.success(models))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func storeArtists(artists: [Artist], completion: StoreResults) {
        
        do {
            let artistsIds = artists.map { $0.artistId }
            let existingIds = try checkArtistIdExists(ids: artistsIds)
        
            let context = CoreDataStack.managedObjectContext
            for artist in artists {
                
                if !existingIds.contains(artist.artistId) {
                    // Skipping existing artists
                    
                    let newArtistEntity = ArtistEntity(using: context)
                    newArtistEntity.artistId = Int32(artist.artistId)
                    newArtistEntity.artistName = artist.artistName
                    
                    for track in artist.tracks {
                        
                        let newTrackEntity = TrackEntity(using: context)
                        newTrackEntity.trackId = Int32(track.trackId)
                        newTrackEntity.trackName = track.trackName
                        newTrackEntity.artistName = track.artistName
                        newTrackEntity.previewUrl = track.previewUrl
                        newTrackEntity.artworkUrl100 = track.artworkUrl100
                        newTrackEntity.primaryGenreName = track.primaryGenreName
                        newTrackEntity.country = track.country
                        newTrackEntity.releaseDate = track.releaseDate as NSDate
                        
                        newArtistEntity.addToTracks(newTrackEntity)
                    }
                }
            }
            
            try CoreDataStack.saveContext()
            completion(.success(()))
        
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    // Given a list of artistIds to check, it returns the subset of artistIDs that exists currently in database
    // Checking the existence of all artists together for performance reasons
    private func checkArtistIdExists(ids: [Int]) throws -> [Int] {
        
        let request: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
        request.predicate = NSPredicate(format: "artistId IN %@", ids)
        
        let artists = try CoreDataStack.managedObjectContext.fetch(request)
        return artists.map { Int($0.artistId) }
    }
}
