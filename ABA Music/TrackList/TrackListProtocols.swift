//
//  TrackListProtocols.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias FetchArtistsResults = (Result<[Artist]>) -> Void

protocol TrackListViewProtocol: class {
    var presenter: TrackListPresenterProtocol! { get set }

    func showEmpty()
    func showArtistTracks(artists: [Artist])
    func showError(_ error: Error)
    func loading(enabled: Bool)
}

protocol TrackListPresenterProtocol: class {
    var view: TrackListViewProtocol! { get set }
    var interactor: TrackListInteractorProtocol! { get set }
    var wireFrame: TrackListWireFrameProtocol! { get set }
    
    func viewSizeWillChange(to size: CGSize) // TODO: Add to tests
    func showTrackDetail(for track: Track)
    func updateArtists(query: String, fetchRemote: Bool)
}

protocol TrackListInteractorProtocol: class {
    var presenter: TrackListPresenterProtocol! { get set }
    var remoteDataProvider: TracksRemoteDataProvider! { get set }
    var persistenceDataProvider: TracksPersistenceDataProvider! { get set }
    
    func retrieveArtists(query: String, remote: Bool, completion: @escaping FetchArtistsResults)
}

protocol TrackListWireFrameProtocol: class {
    func createTrackListModule() -> UIViewController
    func presentTrackDetailModule(track: Track)
    func dismissTrackDetailModule()  // TODO: Add to tests
}
