//
//  TrackListInteractor.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

class TrackListInteractor {
    
    weak var presenter: TrackListPresenterProtocol!
    var remoteDataProvider: TracksRemoteDataProvider!
    var persistenceDataProvider: TracksPersistenceDataProvider!
}

extension TrackListInteractor: TrackListInteractorProtocol {
    
    func retrieveTracks(query: String, remote: Bool, completion: @escaping FetchTrackResults) {

        if remote {

            remoteDataProvider.fetchByTrackName(query: query) { [weak self] (result) in
                guard let self = self else { return }
                
                // We don't know who implements TracksRemoteDataProvider, but we are failry sure this could come from another thread (as it's remote)
                // So we dispatch to the main thread to update the UI properly
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let tracks):
                        self.persistenceDataProvider.storeTracks(tracks: tracks, completion: { (_) in
                            // Ignoring store result, we will show the tracks in the UI regardless they were cached or not
                            // Maybe we could log here that something went wrong to come and visit this code
                        })
                    case .failure(_):
                        break
                    }
                    completion(result)
                }
            }
        } else {
            persistenceDataProvider.cachedTracks(query: query) { (result) in
                completion(result)
            }
        }
    }
}
