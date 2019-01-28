//
//  TrackDetailWireFrame.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 25/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

class TrackDetailWireFrame {
    
}

extension TrackDetailWireFrame: TrackDetailWireFrameProtocol {
    
    func createTrackDetailModule(for track: Track) -> UIViewController {

        let view = UIStoryboard.mainStoryboard.viewController(for: .trackDetail) as! TrackDetailViewController
        let presenter = TrackDetailPresenter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.track = track
        presenter.wireFrame = self

        return view

    }
}
