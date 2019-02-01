//
//  TracksRemoteDataManager.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

protocol TracksRemoteDataProvider: class {
    func fetchArtists(query: String, completion: @escaping FetchArtistsResults)
}

// This concrete implementation of TracksRemoteDataProvider uses simple URLSession (as it was in the original implementation of the test)
// I considered using Alamofire, but the way we use the models doesn't help us using ObjectMapper to easily map them.
// We don't do any error handling other than reporting the errors and showing a simple generic label in the view, so there's no need to add more complexity.
class TracksRemoteDataManager: TracksRemoteDataProvider {
    
    func fetchArtists(query: String, completion: @escaping FetchArtistsResults) {

        AlamoFireJSONClient.makeAPICall(to: TracksEndpoints.fetchArtists(term: query, limit: 200)) { (result) in
            
            switch result {
            case .success(let json):
                
                if let dict = json as? [String : Any],
                    let results = dict["results"] as? [[String : Any]] {
                    
                    let artists = self.tracksOnArtists(for: results)
                    completion(.success(artists))
                } else {
                    completion(.failure(RemoteError.jsonWrongFormat))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Grouping Tracks by Artists
    // Tracks actually know nothing about the Artists, as the current use case doesn't require so,
    // This way we prevent undesired retain cycles and reduce complexity
    private func tracksOnArtists(for dict: [[String : Any]]) -> [Artist] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        // artistsById keep Artists sorted by id, so we can access them in O(1) time
        // This way the simple algo takes linear time
        var artistsById = [Int: Artist]()
        dict.forEach { jsonTrack in
            
            if let artistId = jsonTrack["artistId"] as? Int,
                let artistName = jsonTrack["artistName"] as? String,
                let trackId = jsonTrack["trackId"] as? Int,
                let trackName = jsonTrack["trackName"] as? String,
                let previewUrl = jsonTrack["previewUrl"] as? String,
                let artworkUrl100 = jsonTrack["artworkUrl100"] as? String,
                let primaryGenreName = jsonTrack["primaryGenreName"] as? String,
                let country = jsonTrack["country"] as? String,
                let stringReleaseDate = jsonTrack["releaseDate"] as? String,
                let releaseDate = dateFormatter.date(from: stringReleaseDate) {
                
                if artistsById[artistId] == nil {
                    artistsById[artistId] = Artist(artistId: artistId, artistName: artistName, tracks: [])
                }
                
                let track = Track(trackId: trackId, artistName: artistName, trackName: trackName, previewUrl: previewUrl, artworkUrl100: artworkUrl100, primaryGenreName: primaryGenreName, country: country, releaseDate: releaseDate)
                
                artistsById[artistId]!.tracks.append(track)
                
            } else {
                // If a particular track is missing information, we ignore it for now.
                // We could track this case to decide if we want to throw an error, or maybe store it with optional info
            }
        }
        return Array(artistsById.values)
    }
}
