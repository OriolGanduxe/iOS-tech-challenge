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
    func cachedTracks(query: String, completion: FetchTrackResults)
    func storeTracks(tracks: [Track], completion: @escaping  StoreResults)
}

// This implementation of TracksPersistenceDataProvider uses CoreData and make some assumptions such as:
// 1) There's no clean up method, so tracks and artists are never deleted unless you wipe the app. This could be improved if needed.
// 2) CacheArtists method fetches by artist name and is case insensitive
// 3) If we are storing an artist that already exist (same artistId) it ignores it, so it's not possible to update artists
// 4) Tracks are tied to artists, they come all together with the fetched artist
class TracksPersistenceDataManager: TracksPersistenceDataProvider {
    
    func cachedTracks(query: String, completion: FetchTrackResults) {
                
        let request: NSFetchRequest<TrackEntity> = TrackEntity.fetchRequest()
        request.predicate = NSPredicate(format: "trackName CONTAINS[c] %@ || artistName CONTAINS[c] %@", query, query)
        
        do {
            let tracks = try CoreDataStack.managedObjectContext.fetch(request)
            let models = tracks.map { $0.model }
            completion(.success(models))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func storeTracks(tracks: [Track], completion: @escaping StoreResults) {
        
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return; }
            
            do {
                let trackIds: [Int] = tracks.map { $0.trackId }
                
                let context = CoreDataStack.newBackgroundContext()
                let existingIds = try self.checkTrackIdExists(ids: trackIds, context: context)
                
                for track in tracks {
                    
                    if !existingIds.contains(track.trackId) {
                        // Skipping existing artists
                        
                        let _ = TrackEntity(track: track, context: context)
                    }
                }
                
                try CoreDataStack.saveContext(context: context)
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Given a list of trackIds to check, it returns the subset of trackIds that exists currently in database
    // Checking the existence of all tracks together for performance reasons
    private func checkTrackIdExists(ids: [Int], context: NSManagedObjectContext) throws -> [Int] {
        
        let request: NSFetchRequest<TrackEntity> = TrackEntity.fetchRequest()
        request.predicate = NSPredicate(format: "trackId IN %@", ids)
        
        let artists = try context.fetch(request)
        return artists.map { Int($0.trackId) }
    }
}
