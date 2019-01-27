//
//  TrackListInteractorTests.swift
//  ABA MusicTests
//
//  Created by Oriol Ganduxé Pregona on 27/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import XCTest
@testable import ABA_Music

class TrackListInteractorTests: XCTestCase {

    var interactor: TrackListInteractor!
    var remoteDataManager: MockTracksRemoteDataManager!
    var persistenceDataManager: MockTracksPersistenceDataManager!

    override func setUp() {
        interactor = TrackListInteractor()
        remoteDataManager = MockTracksRemoteDataManager()
        persistenceDataManager = MockTracksPersistenceDataManager()

        interactor.remoteDataProvider = remoteDataManager
        interactor.persistenceDataProvider = persistenceDataManager
    }

    func testRetrievePersistentArtistsSuccess() {
        
        let exp = expectation(description: "Interactor should retrieve artists")
        
        interactor.retrieveArtists(query: "foo", remote: false) { (results) in
            switch results {
            case .success(let artists):
                XCTAssert(artists.count == 2)
                XCTAssert(artists[0].tracks.count == 1)
                XCTAssert(artists[0].tracks[0].trackId == 1)
                XCTAssert(artists[1].tracks.count == 1)
                XCTAssert(artists[1].tracks[0].trackId == 2)

                exp.fulfill()
            case .failure(let error):
                XCTFail("Unexpected error \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }
    
    func testRetrieveRemoteArtistsSuccess() {
        
        let exp = expectation(description: "Interactor should retrieve artists")
        
        interactor.retrieveArtists(query: "foo", remote: true) { (results) in
            switch results {
            case .success(let artists):
                XCTAssert(artists.count == 1)
                XCTAssert(artists[0].tracks.count == 2)
                XCTAssert(artists[0].tracks[0].trackId == 1)
                XCTAssert(artists[0].tracks[1].trackId == 2)

                exp.fulfill()
            case .failure(let error):
                XCTFail("Unexpected error \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }
    
    func testRetrievePersistentArtistsFailure() {
        
        let exp = expectation(description: "Interactor should retrieve artists")
        
        persistenceDataManager.simulateFailure = true
        interactor.retrieveArtists(query: "foo", remote: false) { (results) in
            switch results {
            case .success(_):
                XCTFail("Unexpected success")

            case .failure(let error):
                XCTAssert(error is MockErrors)
                XCTAssert(error as! MockErrors == MockErrors.simulatedPersistenceError)
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }
    
    func testRetrieveRemoteArtistsFailure() {
        
        let exp = expectation(description: "Interactor should retrieve artists")
        
        remoteDataManager.simulateFailure = true
        interactor.retrieveArtists(query: "foo", remote: true) { (results) in
            switch results {
            case .success(_):
                XCTFail("Unexpected success")
                
            case .failure(let error):
                XCTAssert(error is MockErrors)
                XCTAssert(error as! MockErrors == MockErrors.simulatedRemoteError)
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

enum MockErrors: Error {
    case simulatedPersistenceError, simulatedRemoteError
}

class MockTracksRemoteDataManager: TracksRemoteDataProvider {
    
    var simulateFailure = false
    
    func fetchArtists(query: String, completion: @escaping FetchArtistsResults) {
        if simulateFailure {
            completion(.failure(MockErrors.simulatedRemoteError))
        } else {
            let track1 = Track(trackId: 1, artistName: "artist1", trackName: "track1", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre1", country: "countryRoads", releaseDate: Date())
            let track2 = Track(trackId: 2, artistName: "artist2", trackName: "track2", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre2", country: "countryRoads", releaseDate: Date())
            
            let artist1 = Artist(artistId: 1, artistName: "artist1", tracks: [track1, track2])
            
            completion(.success([artist1]))
        }
    }
}

class MockTracksPersistenceDataManager: TracksPersistenceDataProvider {
    
    var simulateFailure = false

    func cachedArtists(query: String, completion: (Result<[Artist]>) -> Void) {
        if simulateFailure {
            completion(.failure(MockErrors.simulatedPersistenceError))
        } else {
            let track1 = Track(trackId: 1, artistName: "artist1", trackName: "track1", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre1", country: "countryRoads", releaseDate: Date())
            let track2 = Track(trackId: 2, artistName: "artist2", trackName: "track2", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre2", country: "countryRoads", releaseDate: Date())

            let artist1 = Artist(artistId: 1, artistName: "artist1", tracks: [track1])
            let artist2 = Artist(artistId: 2, artistName: "artist2", tracks: [track2])

            completion(.success([artist1, artist2]))
        }
    }
    
    func storeArtists(artists: [Artist], completion: (Result<Void>) -> Void) {
        if simulateFailure {
            completion(.failure(MockErrors.simulatedPersistenceError))
        } else {
            completion(.success(()))
        }
    }
}

