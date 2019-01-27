//
//  CustomCollectionViewLayout.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 27/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
