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

        presenter.showTrackDetail(for: track)
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }

    func testupdateTracksSuccess() {
        
        let view = MockTrackListViewExpectArtists(testCase: self)
        presenter.view = view
        presenter.updateTracks(query: "foo", fetchRemote: true)
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("Timeout: \(error)")
            }
        }
    }
    
    func testupdateTracksFailure() {
        
        mockInteractor.simulateFailure = true
        let view =  MockTrackListViewExpectError(testCase: self)
        presenter.view = view
        presenter.updateTracks(query: "foo", fetchRemote: true)
        
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
    
    func retrieveTracks(query: String, remote: Bool, completion: @escaping FetchTrackResults) {
        if simulateFailure {
            completion(.failure(remote ? MockErrors.simulatedRemoteError : MockErrors.simulatedPersistenceError))
        } else {
            let track1 = Track(trackId: 1, artistName: "artistZZ", trackName: "trackBB", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre1", country: "countryRoads", releaseDate: Date())
            let track2 = Track(trackId: 2, artistName: "artistZZ", trackName: "trackCC", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre2", country: "countryRoads", releaseDate: Date())
            let track3 = Track(trackId: 3, artistName: "artistAA", trackName: "trackAA", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre2", country: "countryRoads", releaseDate: Date())
            let track4 = Track(trackId: 4, artistName: "artistAA", trackName: "trackZZ", previewUrl: "fakeUrl", artworkUrl100: "fakeArtworkUrl", primaryGenreName: "genre2", country: "countryRoads", releaseDate: Date())
            
            completion(.success([track1, track2, track3, track4]))
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
    
    func showEmpty() {}

    func showArtistTracks(artists: [Artist]) {
        XCTAssert(artists.count == 2)
        checkArtistsOrder(artists: artists)
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
    
    private func checkArtistsOrder(artists: [Artist]) {
    
        var prevArtistName = ""
        var prevTrackName = ""

        for artist in artists {
    
            if artist.artistName < prevArtistName {
                XCTFail("Artists not in ascending order")
            } else {
                prevArtistName = artist.artistName
            }
            
            for track in artist.tracks {
                if track.trackName < prevTrackName {
                    XCTFail("Tracks not in ascending order")
                } else {
                    prevTrackName = track.trackName
                }
            }
            prevTrackName = ""
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
    
    func showEmpty() {}

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
    
    func presentTrackDetailModule(track: Track) {
        XCTAssert(track.trackId == 10)
        exp.fulfill()
    }
    
    func dismissTrackDetailModule() {}
}
