//
//  TrackListPresenterTests.swift
//  ABA MusicTests
//
//  Created by Oriol Ganduxé Pregona on 27/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import XCTest
@testable import ABA_Music

class TrackListPresenterTests: XCTestCase {

    var presenter: TrackListPresenter!
    var mockInteractor: MockTrackListInteractor!
    
    override func setUp() {

        presenter = TrackListPresenter()
        // View is injected in the concrete tests, as we set the expectations there
        mockInteractor = MockTrackListInteractor()
        presenter.interactor = mockInteractor
    }

    func testShowTrackDetail() {
        
        presenter.wireFrame = MockTrackListWireFrame(testCase: self)
        let track = Track(trackId: 10, artistName: "artist10", trackName: "track10", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre10", country: "countryRoads", releaseDate: Date())

        presenter.showTrackDetail(for: track, from: UIView())
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }

    func testUpdateArtistsSuccess() {
        
        presenter.view = MockTrackListViewExpectArtists(testCase: self)
        presenter.updateArtists(query: "foo", fetchRemote: true)
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }
    
    func testUpdateArtistsFailure() {
        
        mockInteractor.simulateFailure = true
        presenter.view = MockTrackListViewExpectError(testCase: self)
        presenter.updateArtists(query: "foo", fetchRemote: true)
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }
}

class MockTrackListInteractor: TrackListInteractorProtocol {
    
    var presenter: TrackListPresenterProtocol!
    var remoteDataProvider: TracksRemoteDataProvider!
    var persistenceDataProvider: TracksPersistenceDataProvider!
    
    var simulateFailure = false
    
    func retrieveArtists(query: String, remote: Bool, completion: @escaping FetchArtistsResults) {
        if simulateFailure {
            completion(.failure(remote ? MockErrors.simulatedRemoteError : MockErrors.simulatedPersistenceError))
        } else {
            let track1 = Track(trackId: 1, artistName: "artist1", trackName: "track1", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre1", country: "countryRoads", releaseDate: Date())
            let track2 = Track(trackId: 2, artistName: "artist2", trackName: "track2", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre2", country: "countryRoads", releaseDate: Date())
            
            let artist1 = Artist(artistId: 1, artistName: "artist1", tracks: [track1])
            let artist2 = Artist(artistId: 2, artistName: "artist2", tracks: [track2])
            
            completion(.success([artist1, artist2]))
        }
    }
}

class MockTrackListViewExpectArtists: TrackListViewProtocol {
    
    var presenter: TrackListPresenterProtocol!
    
    let exp: XCTestExpectation
    let expLoadingEnabled: XCTestExpectation
    let expLoadingDisabled: XCTestExpectation

    init(testCase: XCTestCase) {
        exp = testCase.expectation(description: "Should show artists")
        expLoadingEnabled = testCase.expectation(description: "Should load once at least")
        expLoadingDisabled = testCase.expectation(description: "Should stop loading once at least")
    }
    
    func showArtistTracks(artists: [Artist]) {
        XCTAssert(artists.count == 2)
        exp.fulfill()
    }
    
    func showError(_ error: Error) {
        XCTFail("Unexpected error: \(error.localizedDescription)")
    }
    
    func loading(enabled: Bool) {
        if enabled {
            expLoadingEnabled.fulfill()
        } else {
            expLoadingDisabled.fulfill()
        }
    }
}

class MockTrackListViewExpectError: TrackListViewProtocol {
    
    var presenter: TrackListPresenterProtocol!
    
    let exp: XCTestExpectation
    let expLoadingEnabled: XCTestExpectation
    let expLoadingDisabled: XCTestExpectation
    
    init(testCase: XCTestCase) {
        exp = testCase.expectation(description: "Should show artists")
        expLoadingEnabled = testCase.expectation(description: "Should load once at least")
        expLoadingDisabled = testCase.expectation(description: "Should stop loading once at least")
    }
    
    func showArtistTracks(artists: [Artist]) {
        XCTFail("Unexpected show success")
    }
    
    func showError(_ error: Error) {
        exp.fulfill()
    }
    func loading(enabled: Bool) {
        if enabled {
            expLoadingEnabled.fulfill()
        } else {
            expLoadingDisabled.fulfill()
        }
    }
}

class MockTrackListWireFrame: TrackListWireFrameProtocol {
    
    let exp: XCTestExpectation
    
    init(testCase: XCTestCase) {
        exp = testCase.expectation(description: "Should show TrackDetail module")
    }
    
    func createTrackListModule() -> UIViewController {
        // Not tested here
        return UIViewController()
    }
    
    func presentTrackDetailModule(track: Track, from: UIView) {
        XCTAssert(track.trackId == 10)
        exp.fulfill()
    }
}
