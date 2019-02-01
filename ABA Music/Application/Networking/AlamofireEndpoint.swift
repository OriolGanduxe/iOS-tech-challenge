//
//  AlamofireEndpoint.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 01/02/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import Foundation
import Alamofire

protocol AlamofireEndPoint {
    
    /// Provides all the information required to make the API call from Alamofire
    func provideValues()-> (url: String, httpMethod: HTTPMethod, parameters:[String:Any]?, encoding: ParameterEncoding)
    
    var url: URLConvertible         { get }
    var httpMethod: HTTPMethod      { get }
    var parameters: [String: Any]?  { get }
    var encoding: ParameterEncoding { get }
}

extension AlamofireEndPoint {
    
    var url: URLConvertible         { return provideValues().url }
    var httpMethod: HTTPMethod      { return provideValues().httpMethod }
    var parameters: [String: Any]?  { return provideValues().parameters }
    var encoding: ParameterEncoding { return provideValues().encoding }
}
