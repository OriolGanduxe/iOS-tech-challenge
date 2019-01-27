//
//  Errors.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 24/01/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation

enum ArtistsError: Error {
    case emptyArtists
}

enum RemoteError: Error {
    case jsonWrongFormat
    case genericError
}
