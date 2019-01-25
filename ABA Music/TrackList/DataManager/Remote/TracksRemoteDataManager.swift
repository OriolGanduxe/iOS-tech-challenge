//
//  TracksRemoteDataManager.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

protocol TracksRemoteDataProvider: class {
    func fetchArtists(completion: @escaping FetchArtistsResults)
}

class TracksRemoteDataManager: TracksRemoteDataProvider {
    
    func fetchArtists(completion: @escaping FetchArtistsResults) {
        // TODO: Inject term

        let term = "Jackson"
        if let urlString = "https://itunes.apple.com/search?term=\(term)&media=musicVideo&entity=musicVideo&attribute=artistTerm&limit=200".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard let self = self, let data = data else { return }
                    do {
                        if let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let results = dict["results"] as? [[String : Any]] {
                                
                                let artists = self.tracksOnArtists(for: results)
                                completion(.success(artists))
                            } else {
                                completion(.failure(RemoteError.jsonWrongFormat))
                            }
                        } else {
                            completion(.failure(RemoteError.jsonWrongFormat))
                        }
                        
                    } catch let error {
                        completion(.failure(error))
                        print(error.localizedDescription)
                    }
                }
                task.resume()
            }
        } else {
            completion(.failure(RemoteError.genericError))
        }
    }
    
    private func tracksOnArtists(for dict: [[String : Any]]) -> [Artist] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
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
