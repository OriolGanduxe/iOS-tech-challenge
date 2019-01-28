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

// This implementation of TracksPersistenceDataProvider uses CoreData and make some assumptions such as:
// 1) There's no clean up method, so tracks and artists are never deleted unless you wipe the app. This could be improved if needed.
// 2) CacheArtists method fetches by artist name and is case insensitive
// 3) If we are storing an artist that already exist (same artistId) it ignores it, so it's not possible to update artists
// 4) Tracks are tied to artists, they come all together with the fetched artist
class TracksPersistenceDataManager: TracksPersistenceDataProvider {
    
    func cachedArtists(query: String, completion: FetchArtistsResults) {
                
        let request: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
        request.predicate = NSPredicate(format: "artistName CONTAINS[c] %@", query)
        
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
                    
                    let _ = ArtistEntity(artist: artist, context: context)
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
