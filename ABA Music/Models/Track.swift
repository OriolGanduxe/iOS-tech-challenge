//
//  Track.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

// I considered using Alamofire ObjectMapper to map the result API request into this class, but because the tracks comes in
// an array with a reference to Artist, and we want them grouped by artists instead of the other way around,
// I left the current and simpler implementation. This way this init can also be used by the CoreData entities

class Track: Equatable {
    var trackId: Int
    var artistName: String
    var trackName: String
    var previewUrl: String
    var artworkUrl100: String
    var primaryGenreName: String
    var country: String
    var releaseDate: Date
    
    init(trackId: Int, artistName: String, trackName: String, previewUrl: String, artworkUrl100: String, primaryGenreName: String, country: String, releaseDate: Date) {
        self.trackId = trackId
        self.artistName = artistName
        self.trackName = trackName
        self.previewUrl = previewUrl
        self.artworkUrl100 = artworkUrl100
        self.primaryGenreName = primaryGenreName
        self.country = country
        self.releaseDate = releaseDate
    }
    
    // TODO: Check it really works
    var artworkUrl500: String {
        get {
            return artworkUrl100.replacingOccurrences(of: "100x100bb.jpg", with: "500x500bb.jpg")
        }
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}
