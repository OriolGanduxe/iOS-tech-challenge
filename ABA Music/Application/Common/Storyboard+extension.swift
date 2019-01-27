//
//  Storyboard+extension.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

enum ModuleStoryboardEntryPoint: String {
    case trackList = "TrackListViewController"
    case trackDetail = "TrackDetailViewController"
}

extension UIStoryboard {
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func viewController(for entryPoint: ModuleStoryboardEntryPoint) -> UIViewController {
        return instantiateViewController(withIdentifier: entryPoint.rawValue)
    }
}
