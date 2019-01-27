//
//  TrackDetailProtocols.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 25/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

protocol TrackDetailViewProtocol: class {
    var presenter: TrackDetailPresenterProtocol! { get set }
    
    // PRESENTER -> VIEW
    func showTrack(track: Track)
}

protocol TrackDetailPresenterProtocol: class {
    var view: TrackDetailViewProtocol! { get set }
    var wireFrame: TrackDetailWireFrameProtocol! { get set }
    var track: Track! { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
}

protocol TrackDetailWireFrameProtocol: class {
    func createTrackDetailModule(for track: Track) -> UIViewController
}
