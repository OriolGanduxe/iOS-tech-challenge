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
    
    static func makeAPICall(to endPoint: AlamofireEndPoint, completionHandler:@escaping AlamofireJSONCompletionHandler) {
        Alamofire.request(endPoint.url, method: endPoint.httpMethod, parameters: endPoint.parameters, encoding: endPoint.encoding).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                completionHandler(Result.success(value))
            case .failure(let error):
                completionHandler(Result.failure(error))
            }
        }
    }
}
