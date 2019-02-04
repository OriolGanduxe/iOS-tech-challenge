//
//  TracksRemoteDataManagerTests.swift
//  ABA MusicTests
//
//  Created by Oriol Ganduxé Pregona on 01/02/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//


import XCTest
@testable import ABA_Music
import OHHTTPStubs
import Alamofire

class TracksRemoteDataManagerTests: XCTestCase {
    
    var remoteDataManager: TracksRemoteDataManager!
    
    override func setUp() {
        remoteDataManager = TracksRemoteDataManager()
    }
    
    func testAlamofireSuccessRequest() {
        
        let exp = expectation(description: "Wait for response")
        
        let cleanUrl = API.baseUrl.replacingOccurrences(of: "https://", with: "")
        stub(condition: isHost(cleanUrl)) { _ in
            let stubPath = OHPathForFile("sampleCorrectRequest.json", type(of: self))
            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
        }

        remoteDataManager.fetchByArtistAndTrackName(query: "foo") { (results) in
            
            switch results {
            case .success(let tracks):
                // Doubles the mock jason, because it perfroms the call twice (for songName and artistName)
                XCTAssert(tracks.count == 4)
                exp.fulfill()
                
            case .failure(let error):
                XCTFail("Unexpected failure: \(error.localizedDescription)")
            }
        }
        
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }
    
    func testAlamofireMalformedRequest() {
        
        let exp = expectation(description: "Wait for response")
        
        let cleanUrl = API.baseUrl.replacingOccurrences(of: "https://", with: "")
        stub(condition: isHost(cleanUrl)) { _ in
            let stubPath = OHPathForFile("sampleWrongRequest.json", type(of: self))
            return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type":"application/json"])
        }
        
        remoteDataManager.fetchByArtistAndTrackName(query: "foo") { (results) in
            switch results {
            case .success(_):
                XCTFail("Expecting error")
                
            case .failure(_):
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }
    
    func testAlamofireWrongCodeRequest() {
        
        let exp = expectation(description: "Wait for response")
        
        let cleanUrl = API.baseUrl.replacingOccurrences(of: "https://", with: "")
        stub(condition: isHost(cleanUrl)) { _ in
            let stubPath = OHPathForFile("sampleCorrectRequest.json", type(of: self))
            return fixture(filePath: stubPath!, status: 400, headers: ["Content-Type":"application/json"])
        }
        
        remoteDataManager.fetchByArtistAndTrackName(query: "foo") { (results) in
            switch results {
            case .success(_):
                XCTFail("Expecting error")
                
            case .failure(_):
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }
}

