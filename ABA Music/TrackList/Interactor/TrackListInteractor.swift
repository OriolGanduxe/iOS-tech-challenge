//
//  TrackListInteractor.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

class TrackListInteractor {
    
    var presenter: TrackListPresenterProtocol!
    var remoteDataProvider: TracksRemoteDataProvider!
    var persistenceDataProvider: TracksPersistenceDataProvider!
}

extension TrackListInteractor: TrackListInteractorProtocol {
    
    func retrieveArtists(query: String, remote: Bool, completion: @escaping FetchArtistsResults) {

        if remote {
            remoteDataProvider.fetchArtists(query: query) { [weak self] (result) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let artists):
                        self.persistenceDataProvider.storeArtists(artists: artists, completion: { (_) in
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
            persistenceDataProvider.cachedArtists(query: query) { (result) in
                completion(result)
            }
        }
    }
}
