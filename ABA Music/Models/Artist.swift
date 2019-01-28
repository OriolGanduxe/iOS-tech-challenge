//
//  Track.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

// Same decision taken than in Track class about ObjectMapper

class Artist: Equatable {
    
    var artistId: Int
    var artistName: String
    var tracks: [Track]
    
    init(artistId: Int, artistName: String, tracks: [Track]) {
        self.artistId = artistId
        self.artistName = artistName
        self.tracks = tracks
    }
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.artistId == rhs.artistId
    }
}
