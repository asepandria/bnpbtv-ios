//
//  BRouter.swift
//  BPNBTV
//
//  Created by Raditya on 4/5/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import Alamofire
enum BRouter:URLRequestConvertible {
    case commonRequest(parameters:Parameters)
    static let baseUrlString = "http://www.bnpbindonesia.tv/api/"
    var method: HTTPMethod {
        switch self {
        case .commonRequest:
            return .post
        }
    }
    var path:String{
        switch self {
        case .commonRequest:
            return ""
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = try BRouter.baseUrlString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        switch self {
        case .commonRequest(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            
        }
        return urlRequest
    }
}
