//
//  TrackDetailPresenter.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 25/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

class TrackDetailPresenter {
    
    weak var view: TrackDetailViewProtocol!
    var wireFrame: TrackDetailWireFrameProtocol!
    var track: Track!
        
}

extension TrackDetailPresenter: TrackDetailPresenterProtocol {
    
    func viewDidLoad() {
        view.showTrack(track: track)
    }
}
