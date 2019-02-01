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

    func testRetrievePersistentTracksSuccess() {
        
        let exp = expectation(description: "Interactor should retrieve tracks")
        
        interactor.retrieveTracks(query: "foo", remote: false) { (results) in
            switch results {
            case .success(let tracks):
                XCTAssert(tracks.count == 2)
                XCTAssert(tracks[0].trackId == 1)
                XCTAssert(tracks[1].trackId == 2)

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
    
    func testRetrieveRemoteTracksSuccess() {
        
        let exp = expectation(description: "Interactor should retrieve tracks")
        
        interactor.retrieveTracks(query: "foo", remote: true) { (results) in
            switch results {
            case .success(let tracks):
                XCTAssert(tracks.count == 2)
                XCTAssert(tracks[0].trackId == 1)
                XCTAssert(tracks[1].trackId == 2)

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
    
    func testRetrievePersistentTracksFailure() {
        
        let exp = expectation(description: "Interactor should retrieve tracks")
        
        persistenceDataManager.simulateFailure = true
        interactor.retrieveTracks(query: "foo", remote: false) { (results) in
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
    
    func testRetrieveRemoteTracksFailure() {
        
        let exp = expectation(description: "Interactor should retrieve tracks")
        
        remoteDataManager.simulateFailure = true
        interactor.retrieveTracks(query: "foo", remote: true) { (results) in
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
    
    func fetchByTrackName(query: String, completion: @escaping FetchTrackResults) {
        if simulateFailure {
            completion(.failure(MockErrors.simulatedRemoteError))
        } else {
            let track1 = Track(trackId: 1, artistName: "artist1", trackName: "track1", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre1", country: "countryRoads", releaseDate: Date())
            let track2 = Track(trackId: 2, artistName: "artist2", trackName: "track2", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre2", country: "countryRoads", releaseDate: Date())

            completion(.success([track1, track2]))
        }
    }
    
    func fetchByArtistName(query: String, completion: @escaping FetchTrackResults) {
        // TODO
    }
}

class MockTracksPersistenceDataManager: TracksPersistenceDataProvider {
    
    var simulateFailure = false

    func cachedTracks(query: String, completion: (Result<[Track]>) -> Void) {
        if simulateFailure {
            completion(.failure(MockErrors.simulatedPersistenceError))
        } else {
            let track1 = Track(trackId: 1, artistName: "artist1", trackName: "track1", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre1", country: "countryRoads", releaseDate: Date())
            let track2 = Track(trackId: 2, artistName: "artist2", trackName: "track2", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre2", country: "countryRoads", releaseDate: Date())

            completion(.success([track1, track2]))
        }
    }
    
    func storeTracks(tracks: [Track], completion: @escaping StoreResults) {
        if simulateFailure {
            completion(.failure(MockErrors.simulatedPersistenceError))
        } else {
            completion(.success(()))
        }
    }
}

