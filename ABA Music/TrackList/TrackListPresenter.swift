//
//  TrackListPresenter.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

class TrackListPresenter {
    
    var view: TrackListViewProtocol!
    var interactor: TrackListInteractorProtocol!
    var wireFrame: TrackListWireFrameProtocol!
}

extension TrackListPresenter: TrackListPresenterProtocol {
    
    func viewDidLoad() {
        // TODO: Necessary?
    }
    
    func showTrackDetail(for track: Track, from: UIView) {
        wireFrame.presentTrackDetailModule(track: track, from: from)
    }
    
    func updateArtists(query: String, fetchRemote: Bool) {
        
        if fetchRemote {
            view.loading(enabled: true)
        }
        
        interactor.retrieveArtists(query: query, remote: fetchRemote) { [weak self] (result) in
            guard let self = self else { return }
            
            self.view.loading(enabled: false)
            switch result {
            case .success(let artists):
                
                let sortedArtists = self.sortArtistsAndTracks(artists: artists)
                self.view.showArtistTracks(artists: sortedArtists)
                
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }

    private func sortArtistsAndTracks(artists: [Artist]) -> [Artist] {
        
        let sortedArtists = artists.sorted { $0.artistName < $1.artistName }
        for artist in sortedArtists {
            artist.tracks.sort { $0.trackName < $1.trackName }
        }
        return sortedArtists
    }
}
