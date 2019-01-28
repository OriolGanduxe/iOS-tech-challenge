//
//  TrackDetailProtocols.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 25/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

// Presenter talking to View
protocol TrackDetailViewProtocol: class {
    var presenter: TrackDetailPresenterProtocol! { get set }
    
    func showTrack(track: Track)
}

// View talking to Presenter
protocol TrackDetailPresenterProtocol: class {
    var view: TrackDetailViewProtocol! { get set }
    var wireFrame: TrackDetailWireFrameProtocol! { get set }
    var track: Track! { get set }
    
    func viewDidLoad()
}

// Presenter talking to WireFrame
protocol TrackDetailWireFrameProtocol: class {
    func createTrackDetailModule(for track: Track) -> UIViewController
}
