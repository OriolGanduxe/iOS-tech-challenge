//
//  TrackListPresenter.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation
import CoreGraphics

class TrackListPresenter {
    
    weak var view: TrackListViewProtocol!
    var interactor: TrackListInteractorProtocol!
    var wireFrame: TrackListWireFrameProtocol!
}

extension TrackListPresenter: TrackListPresenterProtocol {
    
    func viewSizeWillChange(to size: CGSize) {
        wireFrame.dismissTrackDetailModule()
    }
    
    func showTrackDetail(for track: Track) {
        wireFrame.presentTrackDetailModule(track: track)
    }
    
    func updateTracks(query: String, fetchRemote: Bool) {
        
        guard query.count > 0 else {
            view.showEmpty()
            return
        }
        
        if fetchRemote {
            view.loading(enabled: true)
        }
        
        // Interactor will fetch the data regardless the origin and will come back with the updates, using the same data contract
        interactor.retrieveTracks(query: query, remote: fetchRemote) { [weak self] (result) in
            guard let self = self else { return }
            
            self.view.loading(enabled: false)
            switch result {
            case .success(let tracks):
                
                if tracks.count > 0 {
                    let sortedArtists = self.prepareArtistsAndTracks(tracks: tracks)
                    self.view.showArtistTracks(artists: sortedArtists)
                } else {
                    if fetchRemote {
                        self.view.showError(ArtistsError.emptyArtists)
                    } else {
                        self.view.showEmpty()
                    }
                }
                
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }

    // We wrap the tracks around with Artists, so it's simpler to show them in th view, the artists and tracks will be sorted ascending by name too
    private func prepareArtistsAndTracks(tracks: [Track]) -> [Artist] {
        
        var artistsByName = [String: Artist]()
        
        for track in tracks {
            
            if artistsByName[track.artistName] == nil {
                let artist = Artist(artistName: track.artistName, tracks: [])
                artistsByName[track.artistName] = artist
            }
            
            artistsByName[track.artistName]?.tracks.append(track)
        }
        
        let sortedArtists = Array(artistsByName.values).sorted { $0.artistName < $1.artistName }
        for artist in sortedArtists {
            artist.tracks.sort { $0.trackName < $1.trackName }
        }
        return sortedArtists
    }
}
