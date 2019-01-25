//
//  TrackListProtocols.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias FetchArtistsResults = (Result<[Artist]>) -> Void

protocol TrackListViewProtocol {
    var presenter: TrackListPresenterProtocol! { get set }
    
    func showArtistTracks(artists: [Artist])
    func showError(_ error: Error)
    func loading(enabled: Bool)
}

protocol TrackListPresenterProtocol {
    var view: TrackListViewProtocol! { get set }
    var interactor: TrackListInteractorProtocol! { get set }
    var wireFrame: TrackListWireFrameProtocol! { get set }
    
    func viewDidLoad()
    func showTrackDetail(for track: Track)
}

protocol TrackListInteractorProtocol {
    var presenter: TrackListPresenterProtocol! { get set }
    var remoteDataProvider: TracksRemoteDataProvider! { get set }
    var persistenceDataProvider: TracksPersistenceDataProvider! { get set }
    
    func retrieveArtists(completion: @escaping FetchArtistsResults)
}

protocol TrackListWireFrameProtocol {
}
