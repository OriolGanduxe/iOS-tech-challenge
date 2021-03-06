//
//  TracksRemoteDataManager.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol TracksRemoteDataProvider: class {
    func fetchByArtistAndTrackName(query: String, completion: @escaping FetchTrackResults)
}

// We don't do any error handling other than reporting the errors and showing a simple generic label in the view, so there's no need to add more complexity.

// Because the requirement was being able to fetch by artist and track name together, we are firing two requests in paralel, as the API only supports fetching by one attribute at a time.
class TracksRemoteDataManager: TracksRemoteDataProvider {
    
    func fetchByArtistAndTrackName(query: String, completion: @escaping FetchTrackResults) {

        let dispatchGroup = DispatchGroup()
        var byTrackNameTracks = [Track]()
        var byArtistNameTracks = [Track]()
        var byTrackError: Error?
        var byArtistError: Error?

        dispatchGroup.enter()
        let trackEndPoint = TracksEndpoints.fetchTracks(term: query, limit: 200)
        Alamofire.request(trackEndPoint.url, method: trackEndPoint.httpMethod, parameters: trackEndPoint.parameters, encoding: trackEndPoint.encoding).validate().responseArray(keyPath: "results") { (response: DataResponse<[Track]>) in
            switch response.result {
            case .success(let tracks):
                byTrackNameTracks = tracks
            case .failure(let error):
                byTrackError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        let artistEndPoint = TracksEndpoints.fetchArtists(term: query, limit: 200)
        Alamofire.request(artistEndPoint.url, method: artistEndPoint.httpMethod, parameters: artistEndPoint.parameters, encoding: artistEndPoint.encoding).validate().responseArray(keyPath: "results") { (response: DataResponse<[Track]>) in
            switch response.result {
            case .success(let tracks):
                byArtistNameTracks = tracks
            case .failure(let error):
                byArtistError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let artistError = byArtistError, let _ = byTrackError {
                // If both failed, return error
                completion(.failure(artistError))
            } else {
                // If any of them succeeded, let's show the tracks
                completion(.success(byArtistNameTracks + byTrackNameTracks))
            }
        }
    }
}
