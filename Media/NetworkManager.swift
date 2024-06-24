//
//  NetworkManager.swift
//  Media
//
//  Created by 김성민 on 6/24/24.
//

import Foundation
import Alamofire

class NetworkManager {
    
    // 싱글톤
    static let shared = NetworkManager()
    private init() {}
    
    func trendingRequest(timeWindow: String, completionHandler: @escaping (Result<MovieResponse, AFError>) -> Void) {
        let url = APIURL.trendingURL + timeWindow
        let parameters: Parameters = [
            "language" : "en-US"
        ]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.accessTokenAuth
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: MovieResponse.self) { response in
            completionHandler(response.result)
        }
    }
    
}
