//
//  Track.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

class Track: Equatable {
    var trackId: Int
    var artistName: String
    var trackName: String
    var previewUrl: String
    var artworkUrl100: String
    var primaryGenreName: String
    var country: String
    var releaseDate: Date // TODO: Make this Date
    
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
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}
