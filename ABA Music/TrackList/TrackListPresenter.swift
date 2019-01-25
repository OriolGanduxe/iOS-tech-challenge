//
//  TrackListPresenter.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

class TrackListPresenter {
    
    var view: TrackListViewProtocol!
    var interactor: TrackListInteractorProtocol!
    var wireFrame: TrackListWireFrameProtocol!
}

extension TrackListPresenter: TrackListPresenterProtocol {
    
    func viewDidLoad() {
        
        view.loading(enabled: true)
        
        interactor.retrieveArtists { [weak self] (result) in
            guard let self = self else { return }
            
            self.view.loading(enabled: false)
            switch result {
            case .success(let artists):
                
                let sortedArtists = artists.sorted { $0.artistName < $1.artistName }
                self.view.showArtistTracks(artists: sortedArtists)
                
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }
    
    func showTrackDetail(for track: Track) {
        // TODO
    }
}
