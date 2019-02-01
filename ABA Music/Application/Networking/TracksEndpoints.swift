//
//  TracksEndpoints.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 01/02/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation
import Alamofire

struct API {
    static let baseUrl = "https://itunes.apple.com"
}

enum TracksEndpoints: AlamofireEndPoint {
    
    case fetchArtists(term: String, limit: Int)
    case fetchTracks(term: String, limit: Int)
    
    // MARK: - AlamofireEndPoint conforming methods
    
    func provideValues() -> (url: String, httpMethod: HTTPMethod, parameters:[String:Any]?, encoding: ParameterEncoding) {
        
        switch self {
        case let .fetchArtists(term: term, limit: limit):
            let params = parameters(searchTerm: term, attribute: "artistTerm", limit: limit)
            return (url: "\(API.baseUrl)/search", httpMethod: .get, parameters: params, encoding: URLEncoding.default)
            
        case let .fetchTracks(term: term, limit: limit):
            let params = parameters(searchTerm: term, attribute: "songTerm", limit: limit)
            return (url: "\(API.baseUrl)/search", httpMethod: .get, parameters: params, encoding: URLEncoding.default)
        }
    }
    
    // MARK: - Private methods
    
    private func parameters(searchTerm: String, attribute: String, limit: Int)-> [String : String] {
        return [
            "term" : searchTerm,
            "limit" : String(limit),
            "media": "musicVideo",
            "entity": "musicVideo",
            "attribute": attribute]
    }
}
