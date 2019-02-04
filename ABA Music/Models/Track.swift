//
//  Track.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation
import ObjectMapper

struct Track: Equatable {
    var trackId: Int!
    var artistName: String!
    var trackName: String!
    var previewUrl: String?
    var artworkUrl100: String!
    var primaryGenreName: String!
    var country: String!
    var releaseDate: Date!
    
    init(trackId: Int, artistName: String, trackName: String, previewUrl: String?, artworkUrl100: String, primaryGenreName: String, country: String, releaseDate: Date) {
        self.trackId = trackId
        self.artistName = artistName
        self.trackName = trackName
        self.previewUrl = previewUrl
        self.artworkUrl100 = artworkUrl100
        self.primaryGenreName = primaryGenreName
        self.country = country
        self.releaseDate = releaseDate
    }
    
    // I know this is not nice, but the API seems to support it,
    // and the UI feels much better this way.
    // On a real use case we would have proper images anyway.
    var artworkUrl500: String {
        get {
            return artworkUrl100.replacingOccurrences(of: "100x100bb.jpg", with: "500x500bb.jpg")
        }
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}

extension Track: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        trackId         <- map["trackId"]
        trackName       <- map["trackName"]
        artworkUrl100   <- map["artworkUrl100"]
        artistName      <- map["artistName"]
        previewUrl      <- map["previewUrl"]
        primaryGenreName <- map["primaryGenreName"]
        country         <- map["country"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        releaseDate    <- (map["releaseDate"], DateFormatterTransform(dateFormatter: dateFormatter))
    }
}

