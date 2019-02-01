//
//  AlamoFireJSONClient.swift
//  ABA Music
//
//  Created by Oriol Ganduxé Pregona on 01/02/2019.
//  Copyright © 2019 ABA English. All rights reserved.
//

import UIKit
import Alamofire

typealias AlamofireJSONCompletionHandler = (Result<Any>)->()

enum AlamoFireJSONClient {
    
    // TODO
//    manager: SessionManager,
//    static func makeAPIObjectCall<T>(to endPoint: AlamofireEndPoint, completionHandler:@escaping AlamofireJSONCompletionHandler) {
//        
//        // TODO: Come later and make this generic
//        
//        Alamofire.request(endPoint.url, method: endPoint.httpMethod, parameters: endPoint.parameters, encoding: endPoint.encoding).validate().responseArray(keyPath: "results") { (response: DataResponse<[Track]>) in
//            switch response.result {
//            case .success(let value):
//                completionHandler(Result.success(value))
//            case .failure(let error):
//                completionHandler(Result.failure(error))
//            }
//        }
//    }
}
