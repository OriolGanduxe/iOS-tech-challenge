//
//  TrackListWireFrame.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 23/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

class TrackListWireFrame: TrackListWireFrameProtocol {
    
    func createTrackListModule() -> UIViewController {
        
        let navController = UIStoryboard.mainStoryboard.viewController(for: .trackList) as! UINavigationController
        let view = navController.children.first as! TrackListViewController
        let presenter = TrackListPresenter()
        let interactor = TrackListInteractor()
        let persistenceDataManager = TracksPersistenceDataManager()
        let remoteDataManager = TracksRemoteDataManager()
        
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = self
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.persistenceDataProvider = persistenceDataManager
        interactor.remoteDataProvider = remoteDataManager
        
        return navController

    }

    // TODO
//    func presentPostDetailScreen(from view: PostListViewProtocol, forPost post: PostModel) {
//        let postDetailViewController = PostDetailWireFrame.createPostDetailModule(forPost: post)
//
//        if let sourceView = view as? UIViewController {
//            sourceView.navigationController?.pushViewController(postDetailViewController, animated: true)
//        }
//    }
}
