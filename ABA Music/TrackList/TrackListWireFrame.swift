//
//  TrackListWireFrame.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

class TrackListWireFrame: NSObject, TrackListWireFrameProtocol {
    
    weak var rootNavController: UINavigationController!
    weak var popover: UIPopoverPresentationController!

    func createTrackListModule() -> UIViewController {
        
        // Creating module parts/dependencies
        self.rootNavController = (UIStoryboard.mainStoryboard.viewController(for: .trackList) as! UINavigationController)
        let view = rootNavController.children.first as! TrackListViewController
        let presenter = TrackListPresenter()
        let interactor = TrackListInteractor()
        let persistenceDataManager = TracksPersistenceDataManager()
        let remoteDataManager = TracksRemoteDataManager()
        
        // Injecting dependencies one to each other
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = self
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.persistenceDataProvider = persistenceDataManager
        interactor.remoteDataProvider = remoteDataManager
        
        return self.rootNavController
    }

    func presentTrackDetailModule(track: Track) {
        
        let trackDetailView = TrackDetailWireFrame().createTrackDetailModule(for: track)
        
        // set the presentation style
        trackDetailView.modalPresentationStyle = UIModalPresentationStyle.popover
        trackDetailView.preferredContentSize = adaptativeContentSize

        // set up the popover presentation controller
        trackDetailView.popoverPresentationController?.permittedArrowDirections = []
        trackDetailView.popoverPresentationController?.delegate = self
        trackDetailView.popoverPresentationController?.sourceView = rootNavController.view
        trackDetailView.popoverPresentationController?.sourceRect = rootNavController.view.bounds
        
        // present the popover
        rootNavController.present(trackDetailView, animated: true, completion: nil)
    }
    
    func dismissTrackDetailModule() {
        rootNavController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    private var adaptativeContentSize: CGSize {
        get {
            // Dummy logic to show a bigger video preview iPad devices
            if UIScreen.main.bounds.width > 600 && UIScreen.main.bounds.height > 600 {
                return CGSize(width: 500, height: 450)
            } else {
                return CGSize(width: 300, height: 330)
            }
        }
    }
}

extension TrackListWireFrame:  UIPopoverPresentationControllerDelegate {
 
    // Required function to show popovers in iPhones
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
