//
//  Track.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

// Only used in the View layer
class Artist {
    
    var artistName: String
    var tracks: [Track]
    
    init(artistName: String, tracks: [Track]) {
        self.artistName = artistName
        self.tracks = tracks
    }
}
